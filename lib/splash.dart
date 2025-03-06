import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/app_bloc.dart';
import '../../../../app/app_state.dart';
import '../../../../core/router/routes.dart';
import 'app/app_event.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Add slight delay
    context.read<AppBloc>().add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state is AppAuthenticated) {
          Navigator.pushReplacementNamed(context, Routes.home);
        } else if (state is AppUnauthenticated) {
          Navigator.pushReplacementNamed(context, Routes.sign_in);
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset('assets/images/splash.png'),
        ),
      ),
    );
  }
}
