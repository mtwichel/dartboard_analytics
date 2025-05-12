part of 'testing_bloc.dart';

sealed class TestingEvent extends Equatable {
  const TestingEvent();

  @override
  List<Object> get props => [];
}

class TestingIncrementEvent extends TestingEvent {
  const TestingIncrementEvent();
}

class TestingDecrementEvent extends TestingEvent {
  const TestingDecrementEvent();
}

class TestingSetTextEvent extends TestingEvent {
  const TestingSetTextEvent(this.text);

  final String text;
}
