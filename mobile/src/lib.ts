export const money = (value: number) =>
  new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND',
    maximumFractionDigits: 0,
  }).format(value || 0);
export const compactMoney = (value: number) =>
  value >= 1e6 ? `${Number((value / 1e6).toFixed(1))}tr` : `${Math.round(value / 1000)}k`;
export const today = () => {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
};
export const dateLabel = (date: string) =>
  new Date(date + 'T12:00:00').toLocaleDateString('vi-VN', { day: 'numeric', month: 'short' });
export function durationBetween(start: string, end: string) {
  const valid = (v: string) =>
    /^\d{4}-\d{2}-\d{2}$/.test(v) &&
    !Number.isNaN(Date.parse(v)) &&
    new Date(v).toISOString().slice(0, 10) === v;
  if (!valid(start) || !valid(end)) throw new Error('Ngày phải hợp lệ, theo dạng YYYY-MM-DD.');
  const days = Math.round((Date.parse(end) - Date.parse(start)) / 86400000) + 1;
  if (days < 1 || days > 60)
    throw new Error('Chuyến đi cần từ 1 đến 60 ngày, ngày kết thúc không trước ngày bắt đầu.');
  return days;
}
export function positiveNumber(raw: string, label: string, zero = false) {
  const n = Number(raw);
  if (!raw.trim() || !Number.isFinite(n) || (zero ? n < 0 : n <= 0))
    throw new Error(`${label} cần là số ${zero ? 'không âm' : 'lớn hơn 0'}.`);
  return n;
}
export const errorText = (e: unknown) =>
  e instanceof Error ? e.message : 'Có lỗi xảy ra. Bạn thử lại nhé.';

export function tripFilter(status: string, filter: string) {
  if (filter === 'Tất cả') return true;
  if (filter === 'Đã đi') return status === 'COMPLETED' || status === 'ARCHIVED';
  return ['DRAFT', 'PLANNED', 'ACTIVE'].includes(status);
}

export function normalizeBaseUrl(value: string) {
  try {
    const url = new URL(value.trim());
    if (
      !['http:', 'https:'].includes(url.protocol) ||
      url.username ||
      url.password ||
      url.search ||
      url.hash
    )
      throw new Error();
    if (url.pathname !== '/' && url.pathname !== '') throw new Error();
    return url.origin;
  } catch {
    throw new Error(
      'Nhập địa chỉ máy chủ hợp lệ, ví dụ http://192.168.1.10:8080 (không thêm /api).',
    );
  }
}
