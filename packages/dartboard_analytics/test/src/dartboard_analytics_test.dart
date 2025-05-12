// ignore_for_file: prefer_const_constructors
import 'package:dartboard_analytics/dartboard_analytics.dart';
import 'package:test/test.dart';

void main() {
  group('DartboardAnalytics', () {
    test('can be instantiated', () {
      expect(DartboardAnalytics.instance, isNotNull);
    });
  });
}
