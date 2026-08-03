import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from app.config import settings

class PostgresChatStore:
    def __init__(self):
        self.host = settings.DB_HOST
        self.port = settings.DB_PORT
        self.dbname = settings.DB_NAME
        self.user = settings.DB_USER
        self.password = settings.DB_PASSWORD
        self._init_db()

    def _ensure_db_exists(self):
        try:
            # Connect to default postgres DB
            conn = psycopg2.connect(
                host=self.host,
                port=self.port,
                user=self.user,
                password=self.password,
                database="postgres"
            )
            conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
            with conn.cursor() as cursor:
                cursor.execute("SELECT 1 FROM pg_catalog.pg_database WHERE datname = %s", (self.dbname,))
                exists = cursor.fetchone()
                if not exists:
                    cursor.execute(f'CREATE DATABASE "{self.dbname}"')
                    print(f"PostgreSQL database '{self.dbname}' created successfully!")
            conn.close()
        except Exception as e:
            print(f"Error ensuring PostgreSQL database exists: {e}")

    def _init_db(self):
        self._ensure_db_exists()
        try:
            with psycopg2.connect(
                host=self.host,
                port=self.port,
                user=self.user,
                password=self.password,
                database=self.dbname
            ) as conn:
                with conn.cursor() as cursor:
                    cursor.execute("""
                        CREATE TABLE IF NOT EXISTS chat_messages (
                            id SERIAL PRIMARY KEY,
                            session_id VARCHAR(255) NOT NULL,
                            role VARCHAR(50) NOT NULL,
                            content TEXT NOT NULL,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                        )
                    """)
                    cursor.execute("CREATE INDEX IF NOT EXISTS idx_session ON chat_messages(session_id)")
                    conn.commit()
        except Exception as e:
            print(f"Error initializing chat_messages table in PostgreSQL: {e}")

    def get_history(self, session_id: str) -> list:
        try:
            with psycopg2.connect(
                host=self.host,
                port=self.port,
                user=self.user,
                password=self.password,
                database=self.dbname
            ) as conn:
                with conn.cursor() as cursor:
                    cursor.execute(
                        "SELECT role, content FROM chat_messages WHERE session_id = %s ORDER BY id ASC",
                        (session_id,)
                    )
                    rows = cursor.fetchall()
                    return [{"role": row[0], "content": row[1]} for row in rows]
        except Exception as e:
            print(f"Error fetching chat history from PostgreSQL: {e}")
            return []

    def add_message(self, session_id: str, role: str, content: str):
        try:
            with psycopg2.connect(
                host=self.host,
                port=self.port,
                user=self.user,
                password=self.password,
                database=self.dbname
            ) as conn:
                with conn.cursor() as cursor:
                    cursor.execute(
                        "INSERT INTO chat_messages (session_id, role, content) VALUES (%s, %s, %s)",
                        (session_id, role, content)
                    )
                    conn.commit()
        except Exception as e:
            print(f"Error saving chat message to PostgreSQL: {e}")

    def clear_history(self, session_id: str):
        try:
            with psycopg2.connect(
                host=self.host,
                port=self.port,
                user=self.user,
                password=self.password,
                database=self.dbname
            ) as conn:
                with conn.cursor() as cursor:
                    cursor.execute(
                        "DELETE FROM chat_messages WHERE session_id = %s",
                        (session_id,)
                    )
                    conn.commit()
        except Exception as e:
            print(f"Error clearing chat history from PostgreSQL: {e}")
