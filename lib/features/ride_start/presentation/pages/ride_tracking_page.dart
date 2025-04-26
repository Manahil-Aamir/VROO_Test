import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vroo_test/features/ride_start/data/models/ridestart_data_model.dart';
import '../../data/data_source/driver_tracker.dart';
import '../../data/models/inride_passenger_model.dart';

class LocationServiceMonitor {
  final VoidCallback onEnabled;
  bool _lastStatus = false;
  Timer? _checkTimer;

  LocationServiceMonitor({required this.onEnabled});

  Future<void> startMonitoring() async {
    _lastStatus = await Geolocator.isLocationServiceEnabled();
    _checkTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final currentStatus = await Geolocator.isLocationServiceEnabled();
      if (currentStatus && !_lastStatus) {
        onEnabled();
      }
      _lastStatus = currentStatus;
    });
  }

  void stopMonitoring() {
    _checkTimer?.cancel();
  }
}

class RideTrackingScreen extends StatefulWidget {
  final RidestartDataModel rideData;

  const RideTrackingScreen({super.key, required this.rideData});

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen>
    with WidgetsBindingObserver {
  late RealTimeRideTracker _rideTracker;
  final MethodChannel _mapChannel =
      const MethodChannel('com.example.vroo_test/ride_map');
  late LocationServiceMonitor _locationMonitor;

  bool _isMapReady = false;
  bool _isTracking = false;
  bool _isLoading = true;
  String? _errorMessage;
  int? _mapViewId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _locationMonitor = LocationServiceMonitor(
      onEnabled: _resumeTrackingAutomatically,
    );
    _locationMonitor.startMonitoring();
    _initializeApp();
  }

  @override
  void dispose() {
    _locationMonitor.stopMonitoring();
    WidgetsBinding.instance.removeObserver(this);
    _rideTracker.dispose();
    super.dispose();
  }

  Future<void> _resumeTrackingAutomatically() async {
    if (!_isTracking && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location enabled - resuming tracking'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      await _toggleTracking();
    }
  }

  Future<void> _openLocationSettings() async {
    try {
      final opened = await Geolocator.openLocationSettings();
      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open location settings'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _initializeApp() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      _rideTracker = RealTimeRideTracker(rideId: widget.rideData.id);
      await _rideTracker.initialize();
      await _rideTracker.loadHistoricalRouteData();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Initialization failed: ${e.toString()}';
      });
    }
  }

  Future<void> _initializeMap(int viewId) async {
    try {
      final passengers = widget.rideData.passengers.map((passenger) {
        final p = passenger;
        return {
          'id': p.riderId,
          'name': p.riderName,
          'pickupLat': p.rideRequest.source.coords[0],
          'pickupLng': p.rideRequest.source.coords[1],
          'dropoffLat': p.rideRequest.destination.coords[0],
          'dropoffLng': p.rideRequest.destination.coords[1],
          'sameSource': p.rideRequest.matches.any((m) => m.sameSource),
        };
      }).toList();

      await _mapChannel.invokeMethod('initializeMap', {
        'viewId': viewId,
        'source': {
          'lat': widget.rideData.source.coords[0],
          'lng': widget.rideData.source.coords[1],
        },
        'destination': {
          'lat': widget.rideData.destination.coords[0],
          'lng': widget.rideData.destination.coords[1],
        },
        'routeCoords': [],
        'passengers': passengers,
      });

      await _mapChannel.invokeMethod('fitRouteToScreen', {'viewId': viewId});
      setState(() => _isMapReady = true);
    } catch (e) {
      setState(() {
        _errorMessage = 'Map initialization failed: ${e.toString()}';
      });
    }
  }

  Future<void> _toggleTracking() async {
    final servicesEnabled = await Geolocator.isLocationServiceEnabled();

    if (!servicesEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enable location services to track'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    setState(() => _isTracking = !_isTracking);
    try {
      if (_isTracking) {
        await _rideTracker.startTracking();
      } else {
        await _rideTracker.stopTracking();
      }
    } catch (e) {
      setState(() => _isTracking = !_isTracking);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tracking error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _endRide() async {
    try {
      await _rideTracker.stopTracking();
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to end ride: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Ride'),
        actions: [
          if (_isMapReady)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _mapChannel
                  .invokeMethod('fitRouteToScreen', {'viewId': _mapViewId}),
            ),
        ],
      ),
      body: _buildContent(),
      floatingActionButton: _isMapReady
          ? FloatingActionButton(
              onPressed: () => _mapChannel
                  .invokeMethod('centerOnVehicle', {'viewId': _mapViewId}),
              child: const Icon(Icons.my_location),
            )
          : null,
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initializeApp,
              child: const Text('Retry Initialization'),
            ),
          ],
        ),
      );
    }

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
        _buildRideControls(),
      ],
    );
  }

  Widget _buildMapView() {
    return AndroidView(
      viewType: 'ride_tracking_map',
      creationParams: <String, dynamic>{
        'initialLat': widget.rideData.source.coords[0],
        'initialLng': widget.rideData.source.coords[1],
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
      top: 16,
      right: 16,
      child: Column(
        children: [
          _buildMapButton(
            Icons.add,
            () => _mapChannel.invokeMethod('zoomIn', {'viewId': _mapViewId}),
          ),
          SizedBox(height: 8),
          _buildMapButton(
            Icons.remove,
            () => _mapChannel.invokeMethod('zoomOut', {'viewId': _mapViewId}),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(icon: Icon(icon), onPressed: onPressed),
    );
  }

  Widget _buildRideControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (!_isTracking)
            ElevatedButton(
              onPressed: _openLocationSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Enable Location Services'),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (_isTracking)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _endRide,
                    icon: const Icon(Icons.stop),
                    label: const Text('End Ride'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                )
              else
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggleTracking,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Resume Ride'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
