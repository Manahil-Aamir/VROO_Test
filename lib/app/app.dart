import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'app_bloc.dart';
import 'app_event.dart';
import 'app_state.dart';
import '../core/router/navigation.dart';
import '../core/router/routes.dart';
import '../core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => AppBloc()..add(AppStarted()),
        ),
      ],
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            useInheritedMediaQuery: true,
            builder: (context, child) {
              return MaterialApp(
                navigatorKey: Navigation.navigatorKey,
                title: "Vroo",
                theme: AppTheme.getThemeData(),
                debugShowCheckedModeBanner: false,
                builder: (context, widget) {
                  widget ??= const Center(child: Text('App Widget is null'));
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    child: widget,
                  );
                },
                // initialRoute: _getInitialRoute(state),
                initialRoute: Routes.car,
                onGenerateRoute: Routes().generateRoute,
              );
            },
          );
        },
      ),
    );
  }

  String _getInitialRoute(AppState state) {
    if (state is AppAuthenticated) {
      return Routes.home;
    } else if (state is AppUnauthenticated) {
      return Routes.sign_in;
    }
    return Routes.splash;
  }
}