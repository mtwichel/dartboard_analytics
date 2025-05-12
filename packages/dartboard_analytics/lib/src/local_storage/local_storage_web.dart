import 'dart:async';

import 'package:dartboard_analytics/src/local_storage/local_storage.dart';
import 'package:web/web.dart' show window;

/// {@template local_storage_impl}
/// A local storage implementation for the Dartboard Analytics library.
/// {@endtemplate}
class LocalStorageImpl implements LocalStorage {
  LocalStorageImpl._({required this.storageKey});

  /// Initializes the [LocalStorageImpl] instance.
  static Future<LocalStorageImpl> init(String storageKey) {
    return Future.value(LocalStorageImpl._(storageKey: storageKey));
  }

  /// The storage key.
  final String storageKey;

  @override
  Iterable<String> flush() sync* {
    for (var i = 0; i < window.localStorage.length; i++) {
      final key = window.localStorage.key(i)!;
      if (key.startsWith(storageKey)) {
        yield key.substring(storageKey.length + 1);
      }
    }
    window.localStorage.clear();
  }

  @override
  void push(String value) {
    window.localStorage.setItem('$storageKey|$value', value);
  }
}
