import test from 'node:test';
import assert from 'node:assert/strict';
import { durationBetween, normalizeBaseUrl, positiveNumber, tripFilter } from '../src/lib';
import { initialDemo } from '../src/demo';
import { createDemoClient } from '../src/api/demo-client';
import type { Budget, Expense, Item, Preference, Trip } from '../src/types';

test('trip duration counts both dates and handles leap years', () => {
  assert.equal(durationBetween('2028-02-28', '2028-03-01'), 3);
  assert.equal(durationBetween('2026-10-01', '2026-10-01'), 1);
});
test('invalid dates, reversed dates and excessive duration are rejected', () => {
  for (const [a, b] of [
    ['2026-02-30', '2026-03-01'],
    ['2026-10-02', '2026-10-01'],
    ['2026-01-01', '2026-12-31'],
    ['abc', '2026-10-01'],
  ])
    assert.throws(() => durationBetween(a, b));
});
test('numeric inputs reject blanks, negatives and infinity', () => {
  for (const n of ['', ' ', '-1', 'Infinity', 'abc'])
    assert.throws(() => positiveNumber(n, 'Budget'));
  assert.equal(positiveNumber('0', 'Budget', true), 0);
  assert.equal(positiveNumber('250000', 'Budget'), 250000);
});
test('API base configuration rejects credentials, /api suffix and non-http URLs', () => {
  assert.equal(normalizeBaseUrl(' http://192.168.1.2:8080/ '), 'http://192.168.1.2:8080');
  for (const url of [
    'ftp://example.com',
    'https://user:pass@example.com',
    'http://localhost:8080/api',
    'https://example.com?token=abc',
    'garbage',
  ])
    assert.throws(() => normalizeBaseUrl(url));
});
test('cancelled and archived trips are not listed as upcoming', () => {
  assert.equal(tripFilter('CANCELLED', 'Sắp tới'), false);
  assert.equal(tripFilter('ARCHIVED', 'Sắp tới'), false);
  assert.equal(tripFilter('ACTIVE', 'Sắp tới'), true);
  assert.equal(tripFilter('COMPLETED', 'Đã đi'), true);
});

function sandbox() {
  let state = initialDemo();
  const request = createDemoClient(
    () => state,
    async (data) => {
      state = data;
    },
  );
  return { request, get: () => state };
}
test('demo trip can be deleted and restored with its itinerary intact', async () => {
  const { request } = sandbox();
  await request('/trips/1', 'DELETE');
  assert.equal((await request<Trip[]>('/trips')).length, 0);
  await request('/trips/1/restore', 'PUT');
  assert.equal((await request<Trip[]>('/trips')).length, 1);
  assert.equal((await request<Item[]>('/itinerary-items/trip/1')).length, 4);
});
test('editing and deleting expenses updates the budget calculation', async () => {
  const { request } = sandbox();
  const before = await request<Budget>('/insights/trips/1/budget');
  const added = await request<Expense>('/expenses', 'POST', {
    tripId: 1,
    amount: 50000,
    category: 'FOOD',
  });
  assert.equal(
    (await request<Budget>('/insights/trips/1/budget')).spentBudget,
    before.spentBudget + 50000,
  );
  await request(`/expenses/${added.id}`, 'PUT', { amount: 90000 });
  assert.equal(
    (await request<Budget>('/insights/trips/1/budget')).spentBudget,
    before.spentBudget + 90000,
  );
  await request(`/expenses/${added.id}`, 'DELETE');
  assert.equal((await request<Budget>('/insights/trips/1/budget')).spentBudget, before.spentBudget);
});
test('demo preferences persist when screen is reopened', async () => {
  const { request } = sandbox();
  await request('/user-preferences', 'POST', { preferredStyle: 'Văn hóa', maxBudget: 4000000 });
  assert.equal((await request<Preference>('/user-preferences/user/1')).preferredStyle, 'Văn hóa');
});
test('concurrent demo writes retain both changes and unique IDs', async () => {
  const { request } = sandbox();
  const body = { tripId: 1, amount: 10000, category: 'FOOD' };
  const rows = await Promise.all([
    request<Expense>('/expenses', 'POST', body),
    request<Expense>('/expenses', 'POST', body),
  ]);
  assert.notEqual(rows[0].id, rows[1].id);
  const expenses = await request<{ content: Expense[] }>('/expenses/trip/1');
  assert.equal(expenses.content.length, 4);
});
test('reorder is reflected in the day timeline', async () => {
  const { request } = sandbox();
  await request('/itinerary-items/reorder', 'PUT', [
    { id: 1, dayNumber: 1, orderIndex: 3 },
    { id: 3, dayNumber: 1, orderIndex: 1 },
  ]);
  assert.equal((await request<Item[]>('/itinerary-items/trip/1'))[0].id, 3);
});
