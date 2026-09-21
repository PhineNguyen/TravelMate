import { DemoData, initialDemo, templates } from '../demo';
import { today } from '../lib';
import { ApiError } from './client';

// Explicit sandbox: it never calls a network provider or writes to real accounts.
export function createDemoClient(read: () => DemoData, save: (data: DemoData) => Promise<void>) {
  let sequence = Date.now() * 1000;
  let queue: Promise<unknown> = Promise.resolve();
  async function execute<T>(path: string, method = 'GET', body?: any): Promise<T> {
    const data: DemoData = JSON.parse(JSON.stringify(read()));
    const clean = path.split('?')[0];
    const id = Number(clean.split('/').pop());
    const nextId = () => ++sequence;
    let result: any;
    if (clean === '/trips' && method === 'GET') result = data.trips;
    else if (clean === '/trips' && method === 'POST') {
      result = { ...body, id: nextId(), tripStatus: 'DRAFT' };
      data.trips.unshift(result);
      if (body.planningMode !== 'MANUAL')
        data.items.push(
          ...initialDemo()
            .items.filter((i) => i.dayNumber <= body.duration)
            .map((i) => ({ ...i, id: nextId(), tripId: result.id })),
        );
    } else if (/^\/trips\/\d+\/restore$/.test(clean)) {
      const tripId = Number(clean.split('/')[2]);
      const trip = data.deleted.find((t) => t.id === tripId);
      if (trip) {
        data.trips.unshift(trip);
        data.deleted = data.deleted.filter((t) => t.id !== tripId);
        result = trip;
      }
    } else if (/^\/trips\/\d+$/.test(clean)) {
      const trip = data.trips.find((t) => t.id === id);
      if (!trip) throw new ApiError(404, 'Không tìm thấy chuyến đi.');
      if (method === 'DELETE') {
        data.deleted.push(trip);
        data.trips = data.trips.filter((t) => t.id !== id);
      } else if (method === 'PUT') {
        Object.assign(trip, body);
        result = trip;
      } else result = trip;
    } else if (clean === '/trip-templates') result = templates;
    else if (clean.startsWith('/template-items/template/')) result = initialDemo().items;
    else if (clean === '/places') {
      if (method === 'POST') {
        result = { ...body, id: nextId() };
        data.places.push(result);
      } else {
        const term = decodeURIComponent(path.split('query=')[1] || '').toLowerCase();
        result = data.places.filter((p) => p.name.toLowerCase().includes(term));
      }
    } else if (clean.startsWith('/itinerary-items/trip/'))
      result = data.items
        .filter((i) => i.tripId === id)
        .sort((a, b) => a.dayNumber - b.dayNumber || a.orderIndex - b.orderIndex);
    else if (clean === '/itinerary-items/reorder') {
      body.forEach((patch: any) => {
        const item = data.items.find((i) => i.id === patch.id);
        if (item) Object.assign(item, patch);
      });
    } else if (clean === '/itinerary-items' && method === 'POST') {
      result = { ...body, id: nextId(), place: data.places.find((p) => p.id === body.placeId) };
      data.items.push(result);
    } else if (clean.startsWith('/itinerary-items/')) {
      if (method === 'DELETE') data.items = data.items.filter((i) => i.id !== id);
      else {
        result = data.items.find((i) => i.id === id);
        if (method === 'PUT') Object.assign(result, body);
      }
    } else if (clean.startsWith('/expenses/trip/')) {
      const rows = data.expenses.filter((e) => e.tripId === id);
      result = { content: rows, totalElements: rows.length, last: true };
    } else if (clean === '/expenses') {
      result = { ...body, id: nextId(), expenseDate: body.expenseDate || today() };
      data.expenses.unshift(result);
    } else if (clean.startsWith('/expenses/')) {
      if (method === 'DELETE') data.expenses = data.expenses.filter((e) => e.id !== id);
      else {
        result = data.expenses.find((e) => e.id === id);
        Object.assign(result, body);
      }
    } else if (clean.endsWith('/budget')) {
      const tripId = Number(clean.split('/')[3]);
      const budget = data.trips.find((t) => t.id === tripId)?.totalBudget || 0;
      const spent = data.expenses
        .filter((e) => e.tripId === tripId)
        .reduce((n, e) => n + e.amount, 0);
      result = {
        plannedBudget: budget,
        spentBudget: spent,
        remainingBudget: budget - spent,
        utilizationPercent: budget ? (spent / budget) * 100 : 0,
      };
    } else if (clean.startsWith('/weather/trip/'))
      result = {
        temperature: 28,
        condition: 'Nắng nhẹ · dữ liệu mẫu',
        isOutdoorSafe: true,
        city: 'Đà Nẵng',
      };
    else if (clean.startsWith('/ai-conversations/trip/'))
      result = data.conversations.filter((c) => c.tripId === id);
    else if (clean === '/ai-conversations') {
      result = { ...body, id: nextId(), messages: [] };
      data.conversations.push(result);
    } else if (clean === '/ai-messages/send') {
      const conv = data.conversations.find((c) => c.id === body.conversationId);
      if (!conv) throw new Error('Không tìm thấy cuộc trò chuyện.');
      conv.messages.push({ id: nextId(), senderType: 'USER', content: body.content });
      result = {
        id: nextId(),
        senderType: 'AI',
        content:
          'Đây là phản hồi mẫu để bạn trải nghiệm giao diện. Một ngày thư thả có thể bắt đầu bằng dạo biển lúc 6:30, cà phê lúc 8:00 và khám phá Sơn Trà lúc 10:00.\n\nĐăng nhập tài khoản TravelMate để nhận gợi ý AI riêng cho chuyến đi của bạn.',
      };
      conv.messages.push(result);
    } else if (clean.startsWith('/user-preferences')) {
      if (method !== 'GET') data.preference = { ...data.preference, id: 1, ...body };
      result = data.preference;
      if (!result) throw new ApiError(404, 'Bạn chưa thiết lập sở thích.');
    } else if (clean.startsWith('/users/'))
      result = { id: 1, fullName: 'Minh Anh', email: 'demo@travelmate.local', ...body };
    else if (clean === '/auth/logout') result = undefined;
    else throw new Error('Tính năng này cần tài khoản TravelMate thật.');
    if (method !== 'GET') await save(data);
    return result as T;
  }
  return function request<T>(path: string, method = 'GET', body?: any): Promise<T> {
    const result = queue.then(() => execute<T>(path, method, body));
    queue = result.catch(() => {});
    return result;
  };
}
