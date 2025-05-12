part of 'testing_bloc.dart';

class TestingState extends Equatable {
  const TestingState({
    this.count = 0,
    this.text = '',
  });

  final int count;
  final String text;

  @override
  List<Object> get props => [count, text];

  TestingState copyWith({
    int? count,
    String? text,
  }) {
    return TestingState(
      count: count ?? this.count,
      text: text ?? this.text,
    );
  }
}
