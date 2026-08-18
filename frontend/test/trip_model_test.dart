import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/trip_planning/home/data/models/trip_model.dart';

void main() {
  test('TripModel parses backend trip response JSON', () {
    final trip = TripModel.fromJson({
      'id': 1,
      'ownerId': 9,
      'destination': 'Tokyo',
      'startDate': '2026-08-18',
      'duration': 5,
      'travelerCount': 2,
      'totalBudget': 4200,
      'tripStatus': 'ACTIVE',
      'createdAt': '2026-08-10T10:00:00',
      'updatedAt': '2026-08-10T10:00:00',
    });

    expect(trip.id, 1);
    expect(trip.destination, 'Tokyo');
    expect(trip.startDate, '2026-08-18');
    expect(trip.duration, 5);
    expect(trip.totalBudget, 4200);
    expect(trip.status, 'ACTIVE');
  });
}
