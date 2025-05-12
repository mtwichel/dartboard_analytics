import 'package:dartboard_analytics/dartboard_analytics.dart';
import 'package:flutter/material.dart';

/// {@template widget_monitor}
/// A widget that monitors the widgets in the app and logs the events to
/// Dartboard Analytics.
/// {@endtemplate}
class WidgetMonitor extends StatelessWidget {
  /// {@macro widget_monitor}
  const WidgetMonitor({
    required this.child,
    required DartboardAnalytics dartboardAnalytics,
    this.additionalReportableWidgets = const {},
    super.key,
  }) : _dartboardAnalytics = dartboardAnalytics;

  final DartboardAnalytics _dartboardAnalytics;

  /// The child widget to monitor.
  final Widget child;

  /// Additional widgets to report.
  final Set<Type> additionalReportableWidgets;

  static const _standardReportableWidgets = {
    Text,
    TextButton,
    ElevatedButton,
    OutlinedButton,
    IconButton,
    Icon,
    Image,
  };

  Set<Type> get _reportableWidgets =>
      _standardReportableWidgets.union(additionalReportableWidgets);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) {
        _visitElement(context as Element, details);
      },
      child: child,
    );
  }

  void _visitElement(Element element, PointerDownEvent details) {
    if (element.renderObject is RenderBox) {
      final box = element.renderObject! as RenderBox;
      final key = element.widget.key?.toString();
      final globalBounds = box._rectLocalToGlobal(box.semanticBounds);
      final widget = element.widget;
      if (globalBounds.contains(details.position)) {
        if (key != null && _reportableWidgets.contains(widget.runtimeType)) {
          _dartboardAnalytics.log(
            'widget_pressed',
            payload: {
              'widget_key': key,
              'widget_type': widget.runtimeType.toString(),
              'bounding_box': {
                'left': globalBounds.left,
                'top': globalBounds.top,
                'right': globalBounds.right,
                'bottom': globalBounds.bottom,
              },
            },
          );
        }
      }
    }
    element.visitChildren((childElement) {
      _visitElement(childElement, details);
    });
  }
}

extension on RenderBox {
  Rect _rectLocalToGlobal(Rect localRect) {
    final topLeft = localToGlobal(localRect.topLeft);
    final bottomRight = localToGlobal(localRect.bottomRight);
    return Rect.fromPoints(topLeft, bottomRight);
  }
}
