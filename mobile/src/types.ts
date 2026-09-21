export type User = {
  id: number;
  fullName: string;
  email: string;
  avatarUrl?: string;
  onboardingCompleted?: boolean;
  location?: string;
};
export type Session = { accessToken: string; user: User; demo?: boolean };
export type Trip = {
  id: number;
  destination: string;
  startDate: string;
  endDate: string;
  duration: number;
  travelerCount: number;
  totalBudget: number;
  planningMode: 'MANUAL' | 'AI' | 'TEMPLATE';
  tripStatus: string;
  templateId?: number;
};
export type TripInput = Omit<Trip, 'id' | 'tripStatus'> & {
  travelStyle?: string;
  preferences?: string[];
};
export type Place = {
  id: number;
  name: string;
  description?: string;
  city?: string;
  latitude?: number;
  longitude?: number;
  rating?: number;
  imageUrl?: string;
  category?: string;
};
export type Item = {
  id: number;
  tripId: number;
  placeId?: number;
  place?: Place;
  dayNumber: number;
  orderIndex: number;
  startTime?: string;
  duration?: number;
  note?: string;
  costEstimate?: number;
  sourceType?: string;
};
export type Category = 'FOOD' | 'HOTEL' | 'TRANSPORT' | 'SHOPPING' | 'ENTERTAINMENT' | 'OTHER';
export type Expense = {
  id: number;
  tripId: number;
  createdById: number;
  amount: number;
  category: Category;
  description: string;
  expenseDate: string;
};
export type Template = {
  id: number;
  title: string;
  destination: string;
  duration: number;
  estimatedBudget: number;
  description?: string;
  thumbnailUrl?: string;
  category?: string;
};
export type Message = { id: number; senderType: 'USER' | 'AI'; content: string };
export type Conversation = { id: number; tripId: number; messages: Message[] };
export type Preference = {
  id?: number;
  preferredStyle: string;
  favoriteCategories?: string;
  minBudget?: number;
  maxBudget?: number;
  avgTripDays?: number;
  preferredRegion?: string;
};
export type Weather = {
  temperature: number;
  condition: string;
  isOutdoorSafe: boolean;
  city: string;
};
export type Budget = {
  plannedBudget: number;
  spentBudget: number;
  remainingBudget: number;
  utilizationPercent: number;
};
