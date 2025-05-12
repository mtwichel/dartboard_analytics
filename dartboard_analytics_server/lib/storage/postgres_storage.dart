import 'package:dartboard_analytics_server/event.dart';
import 'package:dartboard_analytics_server/storage/storage.dart';
import 'package:postgres/postgres.dart';

/// {@template postgres_storage}
/// A storage for events that writes to a postgres database.
/// {@endtemplate}
class PostgresStorage extends EventStorage {
  /// {@macro postgres_storage}
  const PostgresStorage(this._db);

  final Connection _db;

  @override
  Future<void> addEvents(Iterable<Event> events) async {
    final valuesPlaceholderBuilder = StringBuffer();
    for (var i = 0; i < events.length; i++) {
      valuesPlaceholderBuilder.writeln(
        '''(id$i, name$i, payload$i, timestamp$i, session_id$i, user_id$i)''',
      );
    }
    await _db.execute(
      '''
      INSERT INTO events (id, name, payload, timestamp, session_id, user_id)
      VALUES 
      $valuesPlaceholderBuilder
      ''',
      parameters: {
        for (final (i, event) in events.indexed) 'id$i': event.id,
        for (final (i, event) in events.indexed) 'name$i': event.name,
        for (final (i, event) in events.indexed) 'payload$i': event.payload,
        for (final (i, event) in events.indexed) 'timestamp$i': event.timestamp,
        for (final (i, event) in events.indexed)
          'session_id$i': event.sessionId,
        for (final (i, event) in events.indexed) 'user_id$i': event.userId,
      },
    );
  }

  @override
  Future<void> init() {
    return _db.execute(
      '''
CREATE TABLE IF NOT EXISTS events (
  id UUID PRIMARY KEY,
  name TEXT,
  payload JSONB,
  timestamp TIMESTAMP,
  session_id TEXT,
  user_id TEXT);''',
    );
  }
}
