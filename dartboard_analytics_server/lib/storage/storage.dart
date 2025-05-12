// ignore_for_file: one_member_abstracts
import 'package:dartboard_analytics_server/event.dart';

export './file_storage.dart';
export './postgres_storage.dart';

/// {@template event_storage}
/// A storage for events.
/// {@endtemplate}
abstract class EventStorage {
  /// {@macro event_storage}
  const EventStorage();

  /// Initializes the storage.
  Future<void> init();

  /// Adds a list of events to the storage.
  Future<void> addEvents(Iterable<Event> events);
}
