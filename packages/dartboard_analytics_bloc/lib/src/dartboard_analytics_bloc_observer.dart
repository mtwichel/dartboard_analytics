import 'package:bloc/bloc.dart';
import 'package:dartboard_analytics/dartboard_analytics.dart';

/// {@template dartboard_analytics_bloc_observer}
/// A BlocObserver that reports to DartboardAnalytics
/// {@endtemplate}
class DartboardAnalyticsBlocObserver implements BlocObserver {
  /// {@macro dartboard_analytics_bloc_observer}
  DartboardAnalyticsBlocObserver({DartboardAnalytics? analytics})
    : _analytics = analytics ?? DartboardAnalytics.instance;

  final DartboardAnalytics _analytics;

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    _analytics.log(
      'bloc_state_change',
      payload: {
        'bloc': '${bloc.runtimeType}',
        'before': '${change.currentState}',
        'after': '${change.nextState}',
      },
    );
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    _analytics.log(
      'bloc_close',
      payload: {'bloc': '${bloc.runtimeType}', 'state': '${bloc.state}'},
    );
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    _analytics.log(
      'bloc_create',
      payload: {'bloc': '${bloc.runtimeType}', 'state': '${bloc.state}'},
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _analytics.log(
      'bloc_error',
      payload: {
        'bloc': '${bloc.runtimeType}',
        'state': '${bloc.state}',
        'error': '$error',
        'stackTrace': '$stackTrace',
      },
    );
  }

  @override
  void onEvent(BlocBase<dynamic> bloc, Object? event) {
    _analytics.log(
      'bloc_event',
      payload: {'bloc': '${bloc.runtimeType}', 'event': '$event'},
    );
  }

  @override
  void onTransition(
    BlocBase<dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    _analytics.log(
      'bloc_transition',
      payload: {
        'bloc': '${bloc.runtimeType}',
        'from': '${transition.currentState}',
        'to': '${transition.nextState}',
        'event': '${transition.event}',
      },
    );
  }
}
