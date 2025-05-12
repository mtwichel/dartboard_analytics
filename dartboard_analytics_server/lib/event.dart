// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Event extends Equatable {
  const Event({
    required this.id,
    required this.name,
    required this.payload,
    required this.timestamp,
    required this.sessionId,
    required this.userId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      name: json['name'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String?,
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'payload': payload,
        'timestamp': timestamp.toIso8601String(),
        'sessionId': sessionId,
        if (userId != null) 'userId': userId,
      };

  final String id;
  final String name;
  final Map<String, dynamic> payload;
  final DateTime timestamp;
  final String sessionId;
  final String? userId;

  @override
  List<Object?> get props => [id, name, payload, timestamp, sessionId, userId];
}
