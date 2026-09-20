import test from 'node:test';
import assert from 'node:assert/strict';
import { ApiError, createClient } from '../src/api/client';

test('logout uses DELETE and current Bearer token, with no refresh-token body', async (t) => {
  let received: RequestInit | undefined;
  let url = '';
  t.mock.method(globalThis, 'fetch', async (input: string, init: RequestInit) => {
    url = input;
    received = init;
    return new Response(null, { status: 204 });
  });
  const result = await createClient('http://localhost:8080/', 'test-token')(
    '/auth/logout',
    'DELETE',
  );
  assert.equal(url, 'http://localhost:8080/api/auth/logout');
  assert.equal(received?.method, 'DELETE');
  assert.equal((received?.headers as Record<string, string>).Authorization, 'Bearer test-token');
  assert.equal(received?.body, undefined);
  assert.equal(result, undefined);
});

test('registration is public and sends JSON unchanged', async (t) => {
  t.mock.method(globalThis, 'fetch', async (_: string, init: RequestInit) => {
    assert.equal((init.headers as Record<string, string>).Authorization, undefined);
    assert.equal((init.headers as Record<string, string>)['Content-Type'], 'application/json');
    assert.deepEqual(JSON.parse(init.body as string), { email: 'test@example.com' });
    return Response.json({ accessToken: 'issued' });
  });
  assert.deepEqual(
    await createClient('http://localhost:8080', '')('/auth/register', 'POST', {
      email: 'test@example.com',
    }),
    { accessToken: 'issued' },
  );
});

test('expired authenticated requests clear the session and report 401', async (t) => {
  let cleared = false;
  t.mock.method(globalThis, 'fetch', async () => new Response('', { status: 401 }));
  await assert.rejects(
    createClient('http://localhost', 'expired', () => {
      cleared = true;
    })('/trips'),
    (e) => e instanceof ApiError && e.status === 401,
  );
  assert.equal(cleared, true);
});

test('validation errors from Spring are surfaced, not replaced with network error', async (t) => {
  t.mock.method(globalThis, 'fetch', async () =>
    Response.json({ email: 'Invalid email' }, { status: 400 }),
  );
  await assert.rejects(
    createClient('http://localhost', '')('/auth/login', 'POST', {}),
    /Invalid email/,
  );
});

test('network errors offer connection guidance without falling back to demo data', async (t) => {
  t.mock.method(globalThis, 'fetch', async () => {
    throw new TypeError('Failed to fetch');
  });
  await assert.rejects(createClient('http://localhost', '')('/trips'), /Không kết nối được/);
});
