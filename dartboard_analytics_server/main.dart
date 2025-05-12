import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dartboard_analytics_server/storage/storage.dart';
import 'package:postgres/postgres.dart';

late EventStorage storage;

Future<void> init(InternetAddress ip, int port) async {
  final storageType =
      Platform.environment['STORAGE_TYPE']?.toLowerCase() ?? 'file';
  if (storageType == 'postgres') {
    final postgresHost = Platform.environment['POSTGRES_HOST'] ?? 'localhost';
    final postgresDatabase =
        Platform.environment['POSTGRES_DATABASE'] ?? 'postgres';
    final postgresUsername =
        Platform.environment['POSTGRES_USERNAME'] ?? 'postgres';
    final postgresPassword =
        Platform.environment['POSTGRES_PASSWORD'] ?? 'postgres';
    final postgresPort = Platform.environment['POSTGRES_PORT'] ?? '5432';

    storage = PostgresStorage(
      await Connection.open(
        Endpoint(
          host: postgresHost,
          database: postgresDatabase,
          username: postgresUsername,
          password: postgresPassword,
          port: int.parse(postgresPort),
        ),
      ),
    );
  } else if (storageType == 'file') {
    final filePath = Platform.environment['FILE_PATH'] ?? 'db.txt';
    storage = FileStorage(File(filePath));
  } else {
    throw Exception('Invalid storage type: $storageType');
  }
  await storage.init();
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  return serve(handler, ip, port);
}
