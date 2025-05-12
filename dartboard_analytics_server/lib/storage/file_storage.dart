import 'dart:io';

import 'package:dartboard_analytics_server/event.dart';
import 'package:dartboard_analytics_server/storage/storage.dart';

/// {@template file_storage}
/// A storage for events that writes to a file.
/// {@endtemplate}
class FileStorage extends EventStorage {
  /// {@macro file_storage}
  const FileStorage(this._db);

  final File _db;

  @override
  Future<void> addEvents(Iterable<Event> events) async {
    for (final event in events) {
      _db.writeAsStringSync('$event\n', mode: FileMode.append);
    }
  }

  @override
  Future<void> init() async {
    if (!_db.existsSync()) {
      _db.createSync();
    }
  }
}
