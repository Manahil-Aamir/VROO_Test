// Main RideTrackingScreen
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../HomeScreens/data/data_source/coords_data_source.dart';
import '../../data/models/rider_view_model.dart';
import '../bloc/bloc/ride_view_bloc.dart';
import '../bloc/event/rideview_event.dart';
import '../bloc/state/rideview_state.dart';
import '../widgets/rideview_modal.dart';

class RideViewScreen extends StatefulWidget {
  final String rideId;
  final List<List<double>>? coords;

  const RideViewScreen({super.key, required this.rideId, this.coords});

  @override
  State<RideViewScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideViewScreen>
    with WidgetsBindingObserver {
  final MethodChannel _mapChannel =
      const MethodChannel('com.example.vroo_test/ride_map');

  bool _isMapReady = false;
  bool _isLoading = true;
  String? _errorMessage;
  int? _mapViewId;
  RideViewModel? _rideData;

  // For route updates
  late CoordsDataSource _coordsDataSource;
  Timer? _routeUpdateTimer;
  List<List<double>> _currentRouteCoords = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _coordsDataSource = CoordsDataSource();

    // Initialize ride by triggering the bloc event with ride ID
    context.read<RideViewBloc>().add(InitializeRideViewEvent(widget.rideId));

    // Set initial coordinates if provided
    if (widget.coords != null) {
      _currentRouteCoords = widget.coords!;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopRouteUpdates();
    super.dispose();
  }

  void _startRouteUpdates() {
    // Cancel any existing timer
    _stopRouteUpdates();

    // Start new timer to fetch route coordinates every 10 seconds
    _routeUpdateTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      try {
        final updatedCoords =
            await _coordsDataSource.fetchRouteCoordinates(widget.rideId);
        if (updatedCoords.isNotEmpty && mounted) {
          setState(() {
            _currentRouteCoords = updatedCoords;
          });

          // Update map with new coordinates
          if (_mapViewId != null && _isMapReady) {
            await _mapChannel.invokeMethod('updateRouteCoordinates', {
              'viewId': _mapViewId,
              'routeCoords': _currentRouteCoords,
            });
          }
        }
      } catch (e) {
        print('Error updating route coordinates: $e');
      }
    });
  }

  void _stopRouteUpdates() {
    _routeUpdateTimer?.cancel();
    _routeUpdateTimer = null;
  }

  Future<void> _initializeMap(int viewId) async {
    if (_rideData == null) {
      setState(() {
        _errorMessage = 'Cannot initialize map: Ride data is not available';
      });
      return;
    }

    try {
      // For passenger view, we don't need to pass passenger array
      await _mapChannel.invokeMethod('initializeMap', {
        'viewId': viewId,
        'source': {
          'lat': _rideData!.passengerData.source.coords[0],
          'lng': _rideData!.passengerData.source.coords[1],
        },
        'destination': {
          'lat': _rideData!.passengerData.destination.coords[0],
          'lng': _rideData!.passengerData.destination.coords[0],
        },
        'routeCoords': _currentRouteCoords,
        'passengers': [], // Empty as this is rider view
      });
      print(
          'Source: lat=${_rideData!.passengerData.source.coords[0]}, lng=${_rideData!.passengerData.source.coords[1]}');
      print(
          'Destination: lat=${_rideData!.passengerData.destination.coords[0]}, lng=${_rideData!.passengerData.destination.coords[1]}');

      await _mapChannel.invokeMethod('fitRouteToScreen', {'viewId': viewId});
      setState(() => _isMapReady = true);

      // Start regular route updates after map is ready
      _startRouteUpdates();
    } catch (e) {
      setState(() {
        _errorMessage = 'Map initialization failed: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RideViewBloc, RideViewState>(
      listener: (context, state) {
        if (state is RideViewSuccess) {
          print('Ride view loaded successfully: ${state.rideData}');
          setState(() {
            _rideData = state.rideData;
            _isLoading = false;

            // Initialize route coords from ride data if available
            if (widget.coords != null) {
              _currentRouteCoords = widget.coords!;
            }
          });
        } else if (state is RideViewFailure) {
          setState(() {
            _isLoading = false;
            _errorMessage = state.errorMessage;
          });
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);

        return Scaffold(
          body: Stack(
            children: [
              _buildContent(state),
              // Top navigation bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: theme.primaryColorDark),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        if (_isMapReady && _mapViewId != null)
                          IconButton(
                            icon: Icon(Icons.refresh,
                                color: theme.primaryColorDark),
                            onPressed: () => _mapChannel.invokeMethod(
                                'fitRouteToScreen', {'viewId': _mapViewId}),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Driver info modal at bottom
              if (_rideData != null && !_isLoading)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: RideDetailsBottomSheet(
                    rideData: _rideData!,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(RideViewState state) {
    if (state is RideViewLoading || _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is RideViewFailure || _errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage ?? (state as RideViewFailure).errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    }

    if (_rideData != null) {
      return Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildMapView(),
                if (_isMapReady) _buildMapControls(),
              ],
            ),
          ),
        ],
      );
    }

    return const Center(child: Text('Waiting for ride data...'));
  }

  Widget _buildMapView() {
    if (_rideData == null) return const SizedBox.shrink();

    return AndroidView(
      viewType: 'ride_tracking_map',
      creationParams: <String, dynamic>{
        'initialLat': _rideData!.passengerData.source.coords[0] ??
            _rideData!.source.coords[0],
        'initialLng': _rideData!.passengerData.source.coords[1] ??
            _rideData!.source.coords[1],
      },
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (int id) {
        _mapViewId = id;
        _initializeMap(id);
      },
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      top: 150.h,
      right: 16,
      child: Column(
        children: [
          _buildMapButton(
            Icons.add,
            () => _mapViewId != null
                ? _mapChannel.invokeMethod('zoomIn', {'viewId': _mapViewId})
                : null,
          ),
          const SizedBox(height: 8),
          _buildMapButton(
            Icons.remove,
            () => _mapViewId != null
                ? _mapChannel.invokeMethod('zoomOut', {'viewId': _mapViewId})
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(IconData icon, VoidCallback? onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        disabledColor: Colors.grey,
      ),
    );
  }
}

// Bottom sheet to display driver and ride details
