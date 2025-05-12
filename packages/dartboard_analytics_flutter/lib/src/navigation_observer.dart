import 'package:dartboard_analytics/dartboard_analytics.dart';
import 'package:flutter/widgets.dart';

/// {@template dartboard_analytics_navigation_observer}
/// A navigation observer that logs navigation events to Dartboard Analytics.
/// {@endtemplate}
class DartboardAnalyticsNavigationObserver extends NavigatorObserver {
  /// {@macro dartboard_analytics_navigation_observer}
  DartboardAnalyticsNavigationObserver({DartboardAnalytics? analytics})
    : _analytics = analytics ?? DartboardAnalytics.instance;

  final DartboardAnalytics _analytics;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _analytics.log(
      'navigation',
      payload: {
        'route': route.settings.name,
        'previous_route': previousRoute?.settings.name,
      },
    );
  }
}
