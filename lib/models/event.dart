// lib/models/event.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event {
  final String id;
  final String activity;
  final String emoji;
  final int maxPeople;
  final int currentPeople;
  final String time;
  final String? topic;
  final LatLng location;
  final String creatorName;
  final bool isActive;

  Event({
    required this.id,
    required this.activity,
    required this.emoji,
    required this.maxPeople,
    required this.currentPeople,
    required this.time,
    required this.topic,
    required this.location,
    required this.creatorName,
    this.isActive = true,
  });
}
