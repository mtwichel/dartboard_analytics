import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:dartboard_analytics/dartboard_analytics.dart';
import 'package:dartboard_analytics/src/local_storage/local_storage.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

/// {@template dartboard_analytics}
/// The entry point for the Dartboard Analytics library.
/// See [log] to log events.
/// for analytics.
/// {@endtemplate}
class DartboardAnalytics {
  DartboardAnalytics._(this._responses, this._commands)
    : _sessionId = const Uuid().v4() {
    _responses.listen(_handleResponsesFromIsolate);
  }
  late final SendPort _commands;
  final ReceivePort _responses;
  bool _closed = false;
  static bool _initialized = false;
  static late final DartboardAnalytics _instance;
  final _uuid = const Uuid();
  final String _sessionId;

  /// The user's ID.
  String? userId;

  /// Returns the singleton instance of [DartboardAnalytics].
  ///
  /// Throws a [StateError] if the instance is not initialized.
  static DartboardAnalytics get instance {
    if (!_initialized) throw StateError('Not initialized');
    return _instance;
  }

  /// Initializes the [DartboardAnalytics] instance.
  ///
  /// Throws a [StateError] if the instance is already initialized.
  static Future<void> init({
    required String directory,
    Duration timerPeriod = const Duration(seconds: 10),
  }) async {
    if (_initialized) throw StateError('Already initialized');
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();

    initPort.handler = (dynamic initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };

    try {
      await Isolate.spawn(_startRemoteIsolate, (
        port: initPort.sendPort,
        directory: directory,
        timerPeriod: timerPeriod.inSeconds,
      ));
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

    _instance = DartboardAnalytics._(receivePort, sendPort);

    _initialized = true;
  }

  /// Logs a message to the [MorelAnalytics] instance.
  ///
  /// Throws a [StateError] if the instance is closed.
  /// Throws a [StateError] if the instance is not initialized.
  Future<void> log(String name, {Map<String, dynamic> payload = const {}}) {
    final id = _uuid.v4();
    final timestamp = DateTime.now();
    return _rawLog(
      Event(
        id: id,
        name: name,
        payload: payload,
        timestamp: timestamp,
        sessionId: _sessionId,
        userId: userId,
      ).toJson(),
    );
  }

  Future<void> _rawLog(Map<String, dynamic> event) async {
    if (!_initialized) throw StateError('Not initialized');
    if (_closed) throw StateError('Closed');
    _commands.send(event);
  }

  /// Closes the [MorelAnalytics] instance.
  ///
  /// Throws a [StateError] if the instance is already closed.
  void close() {
    if (_closed) throw StateError('Already closed');
    _closed = true;
    _commands.send('shutdown');
    _responses.close();
  }

  void _handleResponsesFromIsolate(dynamic message) {
    if (message is RemoteError) {
      throw message;
    }
  }

  // Isolate side.
  static void _handleCommandsToIsolate(
    ReceivePort receivePort,
    SendPort sendPort,
    Timer timer,
  ) {
    receivePort.listen((message) async {
      if (message == 'shutdown') {
        receivePort.close();
        timer.cancel();
        return;
      }

      if (message is Map<String, dynamic>) {
        try {
          LocalStorage.instance.push(jsonEncode(message));
        } catch (e) {
          sendPort.send(RemoteError(e.toString(), ''));
        }
      }
    });
  }

  static Future<void> _startRemoteIsolate(
    ({SendPort port, int timerPeriod, String directory}) args,
  ) async {
    final (:port, :timerPeriod, :directory) = args;
    final receivePort = ReceivePort();
    port.send(receivePort.sendPort);
    await LocalStorage.init('test', directory);
    final timer = Timer.periodic(Duration(seconds: timerPeriod), (timer) async {
      final values = LocalStorage.instance.flush();
      if (values.isEmpty) return;
      try {
        await http.post(
          Uri.parse('http://localhost:8080/log'),
          body: jsonEncode(values.toList()),
        );
        // TODO(mtwichel): handle error responses
      } catch (e) {
        port.send(RemoteError(e.toString(), ''));
      }
    });
    _handleCommandsToIsolate(receivePort, port, timer);
  }
}
