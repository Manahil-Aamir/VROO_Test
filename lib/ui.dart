import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/app/app_state.dart';
import 'app/app_bloc.dart';

class SimpleUI extends StatelessWidget {
  const SimpleUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        // You can add custom logic here if needed when the state changes.
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Simple UI Example'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display different text based on the state of your BLoC
              BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  // // You can modify this depending on your state logic.
                  // if (state is AppLoadingState) {
                  //   return const CircularProgressIndicator();
                  // } else if (state is AppErrorState) {
                  //   return Text(
                  //     'Error: ${state.message}',
                  //     style: TextStyle(color: Colors.red),
                  //   );
                  // }
                  // // Default state or successful state
                  return const Text(
                    'Hello, Flutter!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Trigger an action in the BLoC when the button is pressed.
                  //context.read<AppBloc>().add(AppButtonPressedEvent());
                },
                child: const Text('Press Me'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
