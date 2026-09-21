export class ApiError extends Error {
  constructor(
    public status: number,
    message: string,
  ) {
    super(message);
  }
}
export function createClient(
  baseUrl: string,
  token: string,
  onUnauthorized: () => void = () => {},
) {
  return async function request<T>(path: string, method = 'GET', body?: unknown): Promise<T> {
    const controller = new AbortController();
    const timer = setTimeout(
      () => controller.abort(),
      path.includes('/ai-') || path === '/trips' ? 90000 : 20000,
    );
    try {
      const response = await fetch(`${baseUrl.replace(/\/$/, '')}/api${path}`, {
        method,
        signal: controller.signal,
        headers: {
          Accept: 'application/json',
          ...(body === undefined ? {} : { 'Content-Type': 'application/json' }),
          ...(token ? { Authorization: `Bearer ${token}` } : {}),
        },
        ...(body === undefined ? {} : { body: JSON.stringify(body) }),
      });
      const raw = await response.text();
      let data: any;
      try {
        data = raw ? JSON.parse(raw) : undefined;
      } catch {
        data = undefined;
      }
      if (!response.ok) {
        if (response.status === 401 && token) onUnauthorized();
        const message =
          data?.message ||
          (data && typeof data === 'object'
            ? Object.values(data)
                .filter((v) => typeof v === 'string')
                .join('\n')
            : '') ||
          (response.status === 401
            ? 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.'
            : `Yêu cầu thất bại (${response.status}).`);
        throw new ApiError(response.status, message);
      }
      return data as T;
    } catch (error) {
      if (error instanceof ApiError) throw error;
      if (controller.signal.aborted) throw new Error('Kết nối quá lâu. Vui lòng thử lại.');
      throw new Error(
        'Không kết nối được TravelMate. Kiểm tra mạng và địa chỉ máy chủ trong Cài đặt.',
      );
    } finally {
      clearTimeout(timer);
    }
  };
}
