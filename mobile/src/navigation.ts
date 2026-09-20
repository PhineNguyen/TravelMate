import type { Trip } from './types';
export type Route =
  | { name: 'tabs' }
  | {
      name: 'create';
      destination?: string;
      templateId?: number;
      duration?: number;
      budget?: number;
    }
  | { name: 'trip'; trip: Trip }
  | { name: 'preferences' };
export type Navigate = (route: Route) => void;
