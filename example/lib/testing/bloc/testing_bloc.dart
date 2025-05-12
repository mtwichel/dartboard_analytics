import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'testing_event.dart';
part 'testing_state.dart';

class TestingBloc extends Bloc<TestingEvent, TestingState> {
  TestingBloc() : super(const TestingState()) {
    on<TestingIncrementEvent>(_onIncrement);
    on<TestingDecrementEvent>(_onDecrement);
    on<TestingSetTextEvent>(_onSetText);
  }

  void _onIncrement(TestingIncrementEvent event, Emitter<TestingState> emit) {
    emit(state.copyWith(count: state.count + 1));
  }

  void _onDecrement(TestingDecrementEvent event, Emitter<TestingState> emit) {
    emit(state.copyWith(count: state.count - 1));
  }

  void _onSetText(TestingSetTextEvent event, Emitter<TestingState> emit) {
    emit(state.copyWith(text: event.text));
  }
}
