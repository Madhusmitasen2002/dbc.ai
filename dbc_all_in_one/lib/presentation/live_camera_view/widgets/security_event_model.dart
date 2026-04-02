// security_event_model.dart
// Shared data model used by SecurityHistoryWidget and LiveCameraView.

import 'package:flutter/material.dart';

enum SecurityEventType { motion, person, vehicle, alert, snapshot, audio }

class SecurityEvent {
  final String id;
  final SecurityEventType type;
  final String cameraName;
  final String zone;
  final DateTime timestamp;
  final String description;
  final double? confidence;
  final bool isResolved;

  const SecurityEvent({
    required this.id,
    required this.type,
    required this.cameraName,
    required this.zone,
    required this.timestamp,
    required this.description,
    this.confidence,
    this.isResolved = false,
  });

  IconData get icon => switch (type) {
        SecurityEventType.motion => Icons.sensors_rounded,
        SecurityEventType.person => Icons.person_rounded,
        SecurityEventType.vehicle => Icons.directions_car_rounded,
        SecurityEventType.alert => Icons.warning_amber_rounded,
        SecurityEventType.snapshot => Icons.camera_alt_outlined,
        SecurityEventType.audio => Icons.mic_rounded,
      };

  Color get color => switch (type) {
        SecurityEventType.motion => const Color(0xFFF59E0B),
        SecurityEventType.person => const Color(0xFF6B46C1),
        SecurityEventType.vehicle => const Color(0xFF3B82F6),
        SecurityEventType.alert => const Color(0xFFEF4444),
        SecurityEventType.snapshot => const Color(0xFF10B981),
        SecurityEventType.audio => const Color(0xFF8B5CF6),
      };

  String get typeLabel => switch (type) {
        SecurityEventType.motion => 'Motion',
        SecurityEventType.person => 'Person',
        SecurityEventType.vehicle => 'Vehicle',
        SecurityEventType.alert => 'Alert',
        SecurityEventType.snapshot => 'Snapshot',
        SecurityEventType.audio => 'Audio',
      };
}
