import 'dart:async';
import 'dart:math';

import 'package:analytics/testing/testing.dart';
import 'package:dartboard_analytics/dartboard_analytics.dart';
import 'package:dartboard_analytics_bloc/dartboard_analytics_bloc.dart';
import 'package:dartboard_analytics_flutter/dartboard_analytics_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DartboardAnalytics.init(
    directory: (await getApplicationDocumentsDirectory()).path,
  );

  DartboardAnalytics.instance.userId = '123';

  Bloc.observer = DartboardAnalyticsBlocObserver();

  runApp(MainApp(analytics: DartboardAnalytics.instance));
}

class MainApp extends StatelessWidget {
  MainApp({super.key, required this.analytics});

  final DartboardAnalytics analytics;
  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return WidgetMonitor(
      dartboardAnalytics: analytics,
      child: MaterialApp(
        navigatorObservers: [
          DartboardAnalyticsNavigationObserver(analytics: analytics),
        ],
        home: Scaffold(body: TestingPage()),
      ),
    );
  }
}
