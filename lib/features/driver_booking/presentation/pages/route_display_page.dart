import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../dependency_injection/route_di.dart';
import '../bloc/bloc/route_bloc.dart';
import '../bloc/event/route_event.dart';
import '../bloc/state/route_state.dart';
import 'route_map_screen.dart';

class RouteDisplayPage extends StatelessWidget {
  final String fromPlaceId;
  final String toPlaceId;
  final String fromPlaceDesc;
  final String toPlaceDesc;

  RouteDisplayPage({
    required this.fromPlaceId,
    required this.toPlaceId,
    required this.fromPlaceDesc,
    required this.toPlaceDesc,
    super.key,
  }) {
    print('From Place ID: $fromPlaceId');
    print('To Place ID: $toPlaceId');
    print('From Place Description: $fromPlaceDesc');
    print('To Place Description: $toPlaceDesc');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: RouteDependencyInjection.init(),
      builder: (context, child) => Scaffold(
        appBar: appBar(heading: 'Select Route'),
        body: BlocBuilder<RouteBloc, RouteState>(
          builder: (context, state) {
            if (state is RouteInitial) {
              context
                  .read<RouteBloc>()
                  .add(FetchRoutesEvent(fromPlaceId, toPlaceId));
              return const Center(child: CircularProgressIndicator());
            } else if (state is RouteLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RouteLoaded) {
              final routeData = state.routeData['data'];
              print('Route Data: $routeData');
              return RouteMapScreen(
                routeData: state.routeData['data'],
                fromPlaceDesc: fromPlaceDesc,
                toPlaceDesc: toPlaceDesc,
                fromPlaceId: fromPlaceId,
                toPlaceId: toPlaceId,
              );
            } else if (state is RouteError) {
              print('Error loading routes: ${state.message}');
              return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/error.png',
                    width: 300.w,
                    height: 300.h,
                    fit: BoxFit.contain,
                  ),
                  // SizedBox(height: 16.h),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 32.w),
                  //   child: Text(
                  //     'Failed to load cars. Please try again later.',
                  //     style: TextStyle(
                  //       color: ThemeColors.buttonTextColor,
                  //       fontSize: 16.sp,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                ],
              ),
            );
            }
            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }
}
