import 'dart:async';
import 'dart:io';

import 'package:dartboard_analytics/src/local_storage/local_storage.dart';
import 'package:path/path.dart' as p;

/// {@template local_storage_impl}
/// A local storage implementation for the Dartboard Analytics library.
/// {@endtemplate}
class LocalStorageImpl implements LocalStorage {
  LocalStorageImpl._(this._storageFile);

  /// Initializes the [LocalStorageImpl] instance.
  static Future<LocalStorageImpl> init(
    String storageKey,
    String? directory,
  ) async {
    if (directory == null) {
      throw ArgumentError('Directory is required');
    }
    final storagePath = p.join(directory, storageKey);

    final storageFile = File(storagePath);

    if (!storageFile.existsSync()) {
      storageFile.createSync();
    }

    try {
      return LocalStorageImpl._(storageFile);
    } catch (e) {
      stderr
        ..writeln('Error parsing local storage content')
        ..writeln(e);

      storageFile.writeAsStringSync('');
      return LocalStorageImpl._(storageFile);
    }
  }

  final File _storageFile;

  @override
  Iterable<String> flush() {
    final answer = _storageFile
        .readAsStringSync()
        .split('\n')
        .where((e) => e.isNotEmpty);
    _storageFile.writeAsStringSync('');
    return answer;
  }

  @override
  void push(String value) {
    _storageFile.writeAsStringSync('$value\n', mode: FileMode.append);
  }
}
