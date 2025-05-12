import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../testing.dart';

class TestingPage extends StatelessWidget {
  const TestingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TestingBloc(),
      child: const TestingView(),
    );
  }
}

class TestingView extends StatelessWidget {
  const TestingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestingBloc, TestingState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<TestingBloc>().add(TestingIncrementEvent());
                    },
                    key: const Key('increment_button'),
                    child: const Text('Increment'),
                  ),
                  Text(state.count.toString()),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TestingBloc>().add(TestingDecrementEvent());
                    },
                    child: const Text('Decrement'),
                  ),
                ],
              ),
              Text(state.text),
              TextField(
                onChanged: (value) {
                  context.read<TestingBloc>().add(TestingSetTextEvent(value));
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TestingPage(),
                    settings: const RouteSettings(name: 'testing'),
                  ));
                },
                child: const Text('Navigate'),
              ),
            ],
          ),
        );
      },
    );
  }
}
