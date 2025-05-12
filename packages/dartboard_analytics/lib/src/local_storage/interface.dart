import 'package:dartboard_analytics/src/local_storage/local_storage_io.dart'
    if (dart.library.js_util) './local_storage_web.dart';

/// {@template local_storage}
/// A local storage interface for the Dartboard Analytics library.
/// {@endtemplate}
abstract interface class LocalStorage {
  static bool _initialized = false;
  static late LocalStorage _localStorage;

  /// Initializes the [LocalStorage] instance.
  static Future<void> init(String storageKey, [String? directory]) async {
    _localStorage = await LocalStorageImpl.init(storageKey, directory);
    _initialized = true;
  }

  /// Get the instance of [LocalStorage].
  static LocalStorage get instance {
    if (!_initialized) throw Exception('LocalStorage not initialized');
    return _localStorage;
  }

  /// Push a value to the local storage.
  void push(String value);

  /// Flush the local storage.
  Iterable<String> flush();
}
