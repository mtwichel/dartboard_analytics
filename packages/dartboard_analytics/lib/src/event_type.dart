/// The type of event.
enum EventType {
  /// The user tapped a widget.
  tap,

  /// The state of a Bloc/Cubit changed.
  stateChange,

  /// A Bloc received an event.
  blocEvent,

  /// A navigation event occurred.
  navigation,
}
