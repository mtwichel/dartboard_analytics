import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dartboard_analytics_server/event.dart';
import 'package:dartboard_analytics_server/storage/storage.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
  final body = await context.request.body();
  final decoded = jsonDecode(body);
  if (decoded is! List) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final events = decoded
      .whereType<String>()
      .map(jsonDecode)
      .whereType<Map<dynamic, dynamic>>()
      .map(Map<String, dynamic>.from)
      .map(Event.fromJson);

  final storage = context.read<EventStorage>();
  await storage.addEvents(events);

  return Response(statusCode: HttpStatus.accepted);
}
