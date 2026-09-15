import asyncio
import time
import asyncpg
from typing import Optional, List, Dict
from app.core.config import settings

class PostgresChatStore:
    def __init__(self):
        self.host = settings.DB_HOST
        self.port = settings.DB_PORT
        self.dbname = settings.DB_NAME
        self.user = settings.DB_USER
        self.password = settings.DB_PASSWORD
        self.pool: Optional[asyncpg.Pool] = None
        self._lock = asyncio.Lock()
        self._last_fail_time: float = 0.0
        self._retry_cooldown: float = 20.0  # seconds between reconnection attempts if DB down

    async def _ensure_db_exists(self):
        """Connect to default 'postgres' database and create target database if it doesn't exist."""
        try:
            conn = await asyncpg.connect(
                host=self.host,
                port=self.port,
                user=self.user,
                password=self.password,
                database="postgres",
                timeout=2.0
            )
            try:
                exists = await conn.fetchval(
                    "SELECT 1 FROM pg_catalog.pg_database WHERE datname = $1",
                    self.dbname
                )
                if not exists:
                    await conn.execute(f'CREATE DATABASE "{self.dbname}"')
                    print(f"[PostgresChatStore] Database '{self.dbname}' created successfully.")
            finally:
                await conn.close()
        except Exception as e:
            print(f"[PostgresChatStore] Warning ensuring DB exists: {e}")

    async def init_pool(self):
        """Initialize the connection pool and migrate schema with cooldown to prevent blocking."""
        if self.pool is not None and not self.pool.is_closing():
            return

        now = time.time()
        if now - self._last_fail_time < self._retry_cooldown:
            return

        async with self._lock:
            if self.pool is not None and not self.pool.is_closing():
                return
            if now - self._last_fail_time < self._retry_cooldown:
                return

            await self._ensure_db_exists()
            try:
                self.pool = await asyncpg.create_pool(
                    host=self.host,
                    port=self.port,
                    user=self.user,
                    password=self.password,
                    database=self.dbname,
                    min_size=2,
                    max_size=10,
                    command_timeout=10.0,
                    timeout=2.0
                )
                async with self.pool.acquire() as conn:
                    await conn.execute("""
                        CREATE TABLE IF NOT EXISTS chat_messages (
                            id SERIAL PRIMARY KEY,
                            session_id VARCHAR(255) NOT NULL,
                            role VARCHAR(50) NOT NULL,
                            content TEXT NOT NULL,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                        );
                        CREATE INDEX IF NOT EXISTS idx_session ON chat_messages(session_id);
                    """)
                print(f"[PostgresChatStore] Connection pool initialized for '{self.dbname}'.")
            except Exception as e:
                print(f"[PostgresChatStore] Error initializing pool: {e}")
                self.pool = None
                self._last_fail_time = time.time()

    async def get_pool(self) -> Optional[asyncpg.Pool]:
        if self.pool is None or self.pool.is_closing():
            await self.init_pool()
        return self.pool

    async def close_pool(self):
        if self.pool is not None:
            await self.pool.close()
            self.pool = None
            print("[PostgresChatStore] Connection pool closed.")

    async def get_history(self, session_id: str) -> List[Dict[str, str]]:
        try:
            pool = await self.get_pool()
            if not pool:
                return []
            async with pool.acquire() as conn:
                rows = await conn.fetch(
                    "SELECT role, content FROM chat_messages WHERE session_id = $1 ORDER BY id ASC",
                    session_id
                )
                return [{"role": row["role"], "content": row["content"]} for row in rows]
        except Exception as e:
            print(f"[PostgresChatStore] Error fetching history for session {session_id}: {e}")
            return []

    async def add_message(self, session_id: str, role: str, content: str):
        try:
            pool = await self.get_pool()
            if not pool:
                return
            async with pool.acquire() as conn:
                await conn.execute(
                    "INSERT INTO chat_messages (session_id, role, content) VALUES ($1, $2, $3)",
                    session_id, role, content
                )
        except Exception as e:
            print(f"[PostgresChatStore] Error saving message for session {session_id}: {e}")

    async def clear_history(self, session_id: str):
        try:
            pool = await self.get_pool()
            if not pool:
                return
            async with pool.acquire() as conn:
                await conn.execute(
                    "DELETE FROM chat_messages WHERE session_id = $1",
                    session_id
                )
        except Exception as e:
            print(f"[PostgresChatStore] Error clearing history for session {session_id}: {e}")
