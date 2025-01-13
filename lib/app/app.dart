import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/router/navigation.dart';
import '../core/router/routes.dart';
import 'app_bloc.dart';
import 'app_state.dart';
import '../core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            useInheritedMediaQuery: true,
            rebuildFactor: (old, data) => true,
            builder: (context, widget) {
              return MaterialApp(
                navigatorKey: Navigation.navigatorKey,
                title: "Your App Title",
                theme: AppTheme.getThemeData(),
                debugShowCheckedModeBanner: false,
                builder: (context, widget) {
                  widget ??= const Center(
                    child: Text('App Widget is null'),
                  );
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    child: widget,
                  );
                },
                initialRoute: Routes.riderhome,
                onGenerateRoute: Routes().generateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
