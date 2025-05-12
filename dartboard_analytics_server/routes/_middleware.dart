import 'package:dart_frog/dart_frog.dart';
import 'package:dartboard_analytics_server/storage/storage.dart';

import '../main.dart';

Handler middleware(Handler handler) => handler.use(requestLogger()).use(
      provider<EventStorage>((_) => storage),
    );
