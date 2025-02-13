import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../bloc/bloc/route_map_bloc.dart';
import '../bloc/event/route_map_event.dart';

class RouteMapScreen extends StatefulWidget {
  final List<dynamic> routeData;
  final String fromPlaceDesc;
  final String toPlaceDesc;
  final String fromPlaceId;
  final String toPlaceId;

  const RouteMapScreen({
    super.key,
    required this.routeData,
    required this.fromPlaceDesc,
    required this.toPlaceDesc,
    required this.fromPlaceId,
    required this.toPlaceId,
  });

  @override
  _RouteMapScreenState createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  static const MethodChannel _channel = MethodChannel('NativeMapViewChannel');
  Map<String, dynamic>? _selectedRoute;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendRoutesToNative();
    });

    _channel.setMethodCallHandler((call) async {
      if (call.method == "onRouteSelected") {
        setState(() {
          _selectedRoute = jsonDecode(call.arguments);
        });
      }
    });
  }

  void _sendRoutesToNative() {
    print('Sending routes to native view');
    print(widget.routeData);
    _channel.invokeMethod("drawRoutes", jsonEncode(widget.routeData));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc()..add(LoadRoutesEvent(widget.routeData)),
      child: Scaffold(
        body: Stack(
          children: [
            // Native Android Google Maps View
            Positioned.fill(
              child: AndroidView(
                viewType: 'NativeMapView',
                layoutDirection: TextDirection.ltr,
                creationParams: {
                  "routeData": jsonEncode(widget.routeData),
                },
                creationParamsCodec: const StandardMessageCodec(),
              ),
            ),

            // Route Information Card
            if (_selectedRoute != null)
              Positioned(
                bottom: 80.h,
                left: 20.w,
                right: 100.w,
                child: Card(
                  color: Theme.of(context).canvasColor,
                  elevation: 4,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Text(
                      'Distance: ${_selectedRoute!['distance']}\n'
                      'Duration: ${_selectedRoute!['duration']}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Theme.of(context).primaryColorDark),
                    ),
                  ),
                ),
              ),

            // Select Route Button
            Positioned(
              bottom: 20.h,
              left: 20.w,
              right: 100.w,
              child: GradientButton(
                onTap: () {
                  if (_selectedRoute != null) {
                    Navigator.pushNamed(
                      context,
                      Routes.d1,
                      arguments: {
                        'toPlaceID': widget.toPlaceId,
                        'fromPlaceID': widget.fromPlaceId,
                        'toDescription': widget.toPlaceDesc,
                        'fromDescription': widget.fromPlaceDesc,
                        'selectedRouteCoords': _selectedRoute!['coords'],
                        'distance': _selectedRoute!['distance'],
                        'duration': _selectedRoute!['duration'],
                      },
                    );
                  }
                }, // Disable button if no route selected
                text: 'Select Route',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
