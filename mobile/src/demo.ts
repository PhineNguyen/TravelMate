import type { Trip, Item, Expense, Place, Template, Conversation } from './types';
import { today } from './lib';
export const destinations = [
  {
    name: 'Đà Nẵng',
    region: 'MIỀN TRUNG',
    subtitle: 'Một chút biển, một chút bình yên.',
    image: 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=1200&q=85',
    tag: 'Biển & nắng',
    color: '#dae8e3',
  },
  {
    name: 'Hạ Long',
    region: 'MIỀN BẮC',
    subtitle: 'Lạc giữa những kỳ quan.',
    image: 'https://images.unsplash.com/photo-1528127269322-539801943592?w=1200&q=85',
    tag: 'Thiên nhiên',
    color: '#dbe7df',
  },
  {
    name: 'Hội An',
    region: 'MIỀN TRUNG',
    subtitle: 'Chậm lại giữa phố đèn lồng.',
    image: 'https://images.unsplash.com/photo-1528127269322-539801943592?w=900&q=85',
    tag: 'Văn hóa',
    color: '#f1e0ca',
  },
];
export const photoFor = (name: string) =>
  destinations.find((d) => name.toLowerCase().includes(d.name.toLowerCase()))?.image ||
  destinations[1].image;
export type DemoData = {
  preference?: import('./types').Preference;
  trips: Trip[];
  items: Item[];
  expenses: Expense[];
  places: Place[];
  conversations: Conversation[];
  deleted: Trip[];
};
export const templates: Template[] = [
  {
    id: 1,
    title: 'Đà Nẵng, theo cách của bạn',
    destination: 'Đà Nẵng',
    duration: 3,
    estimatedBudget: 4500000,
    category: 'Biển & nghỉ dưỡng',
    description: 'Đón bình minh Mỹ Khê, khám phá Sơn Trà và một buổi chiều ở Hội An.',
  },
  {
    id: 2,
    title: 'Hai ngày giữa vịnh xanh',
    destination: 'Hạ Long',
    duration: 2,
    estimatedBudget: 3200000,
    category: 'Thiên nhiên',
    description: 'Chèo kayak, ngắm hoàng hôn và tìm một khoảng trời riêng.',
  },
];
export function initialDemo(): DemoData {
  const places: Place[] = [
    {
      id: 1,
      name: 'Bãi biển Mỹ Khê',
      city: 'Đà Nẵng',
      description: 'Bắt đầu ngày mới bằng tiếng sóng và một buổi dạo biển thật chậm.',
      latitude: 16.0544,
      longitude: 108.2482,
      rating: 4.8,
      category: 'ENTERTAINMENT',
    },
    {
      id: 2,
      name: 'Cà phê bên biển',
      city: 'Đà Nẵng',
      description: 'Một ly cà phê, một chiếc ghế cạnh cửa sổ và không vội vàng.',
      latitude: 16.0607,
      longitude: 108.2457,
      rating: 4.7,
      category: 'FOOD',
    },
    {
      id: 3,
      name: 'Bán đảo Sơn Trà',
      city: 'Đà Nẵng',
      description: 'Con đường xanh dẫn tới một góc nhìn khác của thành phố.',
      latitude: 16.122,
      longitude: 108.277,
      rating: 4.9,
      category: 'ENTERTAINMENT',
    },
    {
      id: 4,
      name: 'Phố cổ Hội An',
      city: 'Hội An',
      description: 'Dạo phố lúc lên đèn, thử một món ngon và lưu lại vài tấm ảnh.',
      latitude: 15.8801,
      longitude: 108.338,
      rating: 4.9,
      category: 'ENTERTAINMENT',
    },
  ];
  const start = today();
  const end = new Date(start + 'T12:00:00');
  end.setDate(end.getDate() + 2);
  return {
    trips: [
      {
        id: 1,
        destination: 'Đà Nẵng',
        startDate: start,
        endDate: `${end.getFullYear()}-${String(end.getMonth() + 1).padStart(2, '0')}-${String(end.getDate()).padStart(2, '0')}`,
        duration: 3,
        travelerCount: 2,
        totalBudget: 4500000,
        planningMode: 'MANUAL',
        tripStatus: 'PLANNED',
      },
    ],
    items: places.map((p, i) => ({
      id: i + 1,
      tripId: 1,
      placeId: p.id,
      place: p,
      dayNumber: i === 3 ? 2 : 1,
      orderIndex: i + 1,
      startTime: ['06:30', '08:00', '10:00', '16:30'][i],
      duration: 90,
      costEstimate: [0, 120000, 0, 200000][i],
      note: p.description,
    })),
    expenses: [
      {
        id: 1,
        tripId: 1,
        createdById: 1,
        amount: 1200000,
        category: 'HOTEL',
        description: 'Một căn phòng nhìn ra biển',
        expenseDate: start,
      },
      {
        id: 2,
        tripId: 1,
        createdById: 1,
        amount: 180000,
        category: 'FOOD',
        description: 'Bữa sáng & cà phê',
        expenseDate: start,
      },
    ],
    places,
    conversations: [],
    deleted: [],
  };
}
