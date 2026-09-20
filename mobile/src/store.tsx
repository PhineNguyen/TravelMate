import { normalizeBaseUrl } from './lib';
import React, {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';
import { Platform } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import * as SecureStore from 'expo-secure-store';
import { createClient } from './api/client';
import { createDemoClient } from './api/demo-client';
import { DemoData, initialDemo } from './demo';
import type { Session } from './types';

const SESSION_KEY = 'travelmate.session.v1';
const sessionStorage = {
  get: () =>
    Platform.OS === 'web'
      ? Promise.resolve(
          typeof sessionStorageWeb() !== 'undefined'
            ? sessionStorageWeb()?.getItem(SESSION_KEY) || null
            : null,
        )
      : SecureStore.getItemAsync(SESSION_KEY),
  set: async (value: string | null) => {
    if (Platform.OS === 'web') {
      if (value) sessionStorageWeb()?.setItem(SESSION_KEY, value);
      else sessionStorageWeb()?.removeItem(SESSION_KEY);
    } else if (value) await SecureStore.setItemAsync(SESSION_KEY, value);
    else await SecureStore.deleteItemAsync(SESSION_KEY);
  },
};
function sessionStorageWeb() {
  try {
    return globalThis.sessionStorage;
  } catch {
    return undefined;
  }
}
type Store = {
  session: Session | null;
  ready: boolean;
  baseUrl: string;
  setBaseUrl: (url: string) => Promise<void>;
  setSession: (s: Session | null) => Promise<void>;
  startDemo: () => Promise<void>;
  logout: () => Promise<void>;
  request: ReturnType<typeof createClient>;
};
const Context = createContext<Store>(null!);
export function AppProvider({ children }: { children: React.ReactNode }) {
  const [session, changeSession] = useState<Session | null>(null);
  const [ready, setReady] = useState(false);
  const [baseUrl, changeBase] = useState(
    process.env.EXPO_PUBLIC_API_URL ||
      (Platform.OS === 'android' ? 'http://10.0.2.2:8080' : 'http://localhost:8080'),
  );
  const demo = useRef<DemoData>(initialDemo());
  useEffect(() => {
    let alive = true;
    (async () => {
      try {
        const [saved, base, sandbox] = await Promise.all([
          sessionStorage.get(),
          AsyncStorage.getItem('travelmate.base'),
          AsyncStorage.getItem('travelmate.demo'),
        ]);
        if (!alive) return;
        if (saved) changeSession(JSON.parse(saved));
        if (base) changeBase(base);
        if (sandbox) demo.current = JSON.parse(sandbox);
      } catch {
        /* Recover from inaccessible or stale local storage with a clean session. */
      } finally {
        if (alive) setReady(true);
      }
    })();
    return () => {
      alive = false;
    };
  }, []);
  const setSession = useCallback(async (s: Session | null) => {
    await sessionStorage.set(s ? JSON.stringify(s) : null);
    changeSession(s);
  }, []);
  const request = useMemo(
    () =>
      session?.demo
        ? createDemoClient(
            () => demo.current,
            async (d) => {
              await AsyncStorage.setItem('travelmate.demo', JSON.stringify(d));
              demo.current = d;
            },
          )
        : createClient(baseUrl, session?.accessToken || '', () => {
            void setSession(null);
          }),
    [session?.demo, session?.accessToken, baseUrl, setSession],
  );
  const setBaseUrl = async (url: string) => {
    const normalized = normalizeBaseUrl(url);
    await AsyncStorage.setItem('travelmate.base', normalized);
    changeBase(normalized);
    await setSession(null);
  };
  const startDemo = async () =>
    setSession({
      accessToken: '',
      demo: true,
      user: {
        id: 1,
        fullName: 'Minh Anh',
        email: 'demo@travelmate.local',
        onboardingCompleted: true,
      },
    });
  const logout = async () => {
    try {
      if (session && !session.demo) await request('/auth/logout', 'DELETE');
    } finally {
      await setSession(null);
    }
  };
  return (
    <Context.Provider
      value={{ session, ready, baseUrl, setBaseUrl, setSession, startDemo, logout, request }}
    >
      {children}
    </Context.Provider>
  );
}
export const useApp = () => useContext(Context);

export function useResource<T>(loader: () => Promise<T>, deps: React.DependencyList = []) {
  const [data, setData] = useState<T>();
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const generation = useRef(0);
  const reload = useCallback(async () => {
    const run = ++generation.current;
    setLoading(true);
    setError('');
    try {
      const value = await loader();
      if (run === generation.current) setData(value);
    } catch (e) {
      if (run === generation.current)
        setError(e instanceof Error ? e.message : 'Không tải được dữ liệu.');
    } finally {
      if (run === generation.current) setLoading(false);
    }
  }, deps);
  useEffect(() => {
    void reload();
    return () => {
      generation.current++;
    };
  }, [reload]);
  return { data, loading, error, reload, setData };
}
