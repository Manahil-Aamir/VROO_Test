import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../rider_journey/data/model/source_and_dest_model.dart';
import '../bloc/bloc/location_selection_bloc.dart';
import '../bloc/event/location_selection_event.dart';
import '../bloc/role_bloc.dart';
import '../bloc/state/location_selection_state.dart';
import '../widgets/location_input_widget.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  _LocationSelectionScreenState createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  String? fromPlaceId;
  String? fromDescription;
  String? toPlaceId;
  String? toDescription;
  LatLng? fromPosition;
  LatLng? toPosition;
  String? activeMarker;
  late MethodChannel _methodChannel;
  final FocusNode _fromFocusNode = FocusNode();
  final FocusNode _toFocusNode = FocusNode();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedLocations();
    _setupFocusListeners();
  }

  void _setupFocusListeners() {
    _fromFocusNode.addListener(() {
      if (_fromFocusNode.hasFocus) {
        setState(() => activeMarker = 'start');
        _updateMapMarkers();
      }
    });
    _toFocusNode.addListener(() {
      if (_toFocusNode.hasFocus) {
        setState(() => activeMarker = 'dest');
        _updateMapMarkers();
      }
    });
  }

  @override
  void dispose() {
    _fromFocusNode.dispose();
    _toFocusNode.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedLocations() async {
    final role = context.read<RoleBloc>().state.role.toLowerCase();
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      fromPlaceId = prefs.getString('${role}_fromPlaceId');
      fromDescription = prefs.getString('${role}_fromDescription');
      toPlaceId = prefs.getString('${role}_toPlaceId');
      toDescription = prefs.getString('${role}_toDescription');

      final fromLat = prefs.getDouble('${role}_fromLat');
      final fromLng = prefs.getDouble('${role}_fromLng');
      final toLat = prefs.getDouble('${role}_toLat');
      final toLng = prefs.getDouble('${role}_toLng');

      fromPosition = (fromLat != null && fromLng != null)
          ? LatLng(fromLat, fromLng)
          : null;
      toPosition =
          (toLat != null && toLng != null) ? LatLng(toLat, toLng) : null;

      _fromController.text = fromDescription ?? '';
      _toController.text = toDescription ?? '';
    });
  }

  Future<void> _saveLocation({
    required String keyPrefix,
    required String? placeId,
    required String? description,
    required LatLng? position,
  }) async {
    if (placeId == null || description == null) return;

    final role = context.read<RoleBloc>().state.role.toLowerCase();
    final prefs = await SharedPreferences.getInstance();

    await Future.wait([
      prefs.setString('${role}_${keyPrefix}PlaceId', placeId),
      prefs.setString('${role}_${keyPrefix}Description', description),
      if (position != null) ...[
        prefs.setDouble('${role}_${keyPrefix}Lat', position.latitude),
        prefs.setDouble('${role}_${keyPrefix}Lng', position.longitude),
      ],
    ]);
  }

  Future<dynamic> _handleMapMethodCall(MethodCall call) async {
    try {
      final data = Map<String, dynamic>.from(call.arguments);
      debugPrint('Map method: ${call.method} - $data');

      switch (call.method) {
        case "onMarkerMoved":
          await _handleMarkerUpdate(data);
          break;
        case "onPlaceInfo":
          await _handlePlaceInfo(data);
          break;
        case "onEnhancedPlaceInfo":
          await _handleEnhancedPlaceInfo(data);
          break;
        case "mapTap":
          await _handleMapTap(data);
          break;
      }
    } catch (e) {
      debugPrint('Error handling ${call.method}: $e');
    }
    return null;
  }

  Future<void> _handleMarkerUpdate(Map<String, dynamic> data) async {
    final type = data['type'] as String;
    final lat = data['lat'] as double;
    final lng = data['lng'] as double;
    final position = LatLng(lat, lng);

    // Update active marker type and position
    setState(() {
      activeMarker = type == 'start' ? 'start' : 'dest';
      if (type == 'start') {
        fromPosition = position;
      } else {
        toPosition = position;
      }
    });

    // Fetch place ID from coordinates using bloc
    context.read<LocationSelectionBloc>().add(
          FetchPlaceIdFromLatLngEvent(lat, lng),
        );

    // Set active marker to ensure correct field gets updated when place ID is returned
    setState(() {
      activeMarker = type == 'start' ? 'start' : 'dest';
    });
  }

  Future<void> _handlePlaceInfo(Map<String, dynamic> data) async {
    final type = data['type'] as String;
    final placeName = data['placeName'] as String? ?? '';
    final placeId = data['placeId'] as String?;

    if (placeName.isNotEmpty) {
      setState(() {
        if (type == 'start') {
          fromDescription = placeName;
          if (placeId != null && placeId.isNotEmpty) {
            fromPlaceId = placeId;
          }
          print("from description: $fromDescription");
          _fromController.text = fromDescription ?? '';
        } else {
          toDescription = placeName;
          if (placeId != null && placeId.isNotEmpty) {
            toPlaceId = placeId;
          }
          print("to description: $toDescription");
          _toController.text = toDescription ?? '';
        }
      });

      if (placeId != null && placeId.isNotEmpty) {
        await _saveLocation(
          keyPrefix: type == 'start' ? 'from' : 'to',
          placeId: placeId,
          description: type == 'start' ? fromDescription : toDescription,
          position: type == 'start' ? fromPosition : toPosition,
        );
      }
    }
  }

  Future<void> _handleEnhancedPlaceInfo(Map<String, dynamic> data) async {
    final type = data['type'] as String;
    final address = data['address'] as String? ?? '';
    final placeId = data['placeId'] as String? ?? '';

    if (address.isNotEmpty) {
      setState(() {
        if (type == 'start') {
          fromDescription = address;
          if (placeId.isNotEmpty) fromPlaceId = placeId;
          print("from description: $fromDescription");
          _fromController.text = fromDescription ?? '';
        } else {
          toDescription = address;
          if (placeId.isNotEmpty) toPlaceId = placeId;
          print("to description: $toDescription");
          _toController.text = toDescription ?? '';
        }
      });

      await _saveLocation(
        keyPrefix: type == 'start' ? 'from' : 'to',
        placeId: type == 'start' ? fromPlaceId : toPlaceId,
        description: type == 'start' ? fromDescription : toDescription,
        position: type == 'start' ? fromPosition : toPosition,
      );
    }
  }

  Future<void> _handleMapTap(Map<String, dynamic> data) async {
    final key = data['key'] as String;
    final lat = data['lat'] as double;
    final lng = data['lng'] as double;
    final placeName = data['placeName'] as String?;

    setState(() {
      if (key == 'from') {
        fromPosition = LatLng(lat, lng);
        fromDescription = placeName ?? fromDescription;
        activeMarker = 'start';
        _fromController.text = fromDescription ?? '';
      } else {
        toPosition = LatLng(lat, lng);
        toDescription = placeName ?? toDescription;
        activeMarker = 'dest';
        _toController.text = toDescription ?? '';
      }
    });

    // Fetch place ID for this location using bloc
    context.read<LocationSelectionBloc>().add(
          FetchPlaceIdFromLatLngEvent(lat, lng),
        );

    _updateMapMarkers();
  }

  void _updateMapMarkers() {
    _methodChannel.invokeMethod('updateMarkers', {
      'startLat': fromPosition?.latitude,
      'startLng': fromPosition?.longitude,
      'startPlaceId': fromPlaceId,
      'startDescription': fromDescription,
      'destLat': toPosition?.latitude,
      'destLng': toPosition?.longitude,
      'destPlaceId': toPlaceId,
      'destDescription': toDescription,
      'activeMarker': activeMarker,
      'showLabels': true,
    });
  }

  void _updatePlaceIdForActiveMarker(String placeId) {
    // Only update if we have an active marker
    if (activeMarker == null) return;

    setState(() {
      if (activeMarker == 'start') {
        fromPlaceId = placeId;
        if (fromPosition != null) {
          _saveLocation(
            keyPrefix: 'from',
            placeId: placeId,
            description: fromDescription ?? 'Selected location',
            position: fromPosition,
          );
        }
      } else if (activeMarker == 'dest') {
        toPlaceId = placeId;
        if (toPosition != null) {
          _saveLocation(
            keyPrefix: 'to',
            placeId: placeId,
            description: toDescription ?? 'Selected location',
            position: toPosition,
          );
        }
      }
    });

    // Update markers on the map to reflect the changes
    _updateMapMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(heading: "Select Location"),
      body: BlocProvider(
        create: (context) => context.read<LocationSelectionBloc>(),
        child: BlocListener<LocationSelectionBloc, LocationSelectionState>(
          listener: (context, state) {
            if (state is PlaceIdLoaded) {
              _updatePlaceIdForActiveMarker(state.placeId);
            }
          },
          child: BlocBuilder<RoleBloc, RoleState>(
            builder: (context, roleState) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Column(
                    children: [
                      LocationInputField(
                        label: 'From where would you go?',
                        controller: _fromController,
                        focusNode: _fromFocusNode,
                        onPlaceSelected: (placeId, description, position) {
                          setState(() {
                            fromPlaceId = placeId;
                            fromDescription = description;
                            fromPosition = position;
                            activeMarker = 'start';
                          });
                          _saveLocation(
                            keyPrefix: 'from',
                            placeId: placeId,
                            description: description,
                            position: position,
                          );
                          _updateMapMarkers();
                        },
                      ),
                      SizedBox(height: 10.h),
                      LocationInputField(
                        label: 'Where would you go?',
                        controller: _toController,
                        focusNode: _toFocusNode,
                        onPlaceSelected: (placeId, description, position) {
                          setState(() {
                            toPlaceId = placeId;
                            toDescription = description;
                            toPosition = position;
                            activeMarker = 'dest';
                          });
                          _saveLocation(
                            keyPrefix: 'to',
                            placeId: placeId,
                            description: description,
                            position: position,
                          );
                          _updateMapMarkers();
                        },
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        height: 300.h,
                        child: AndroidView(
                          viewType: 'native_google_map',
                          layoutDirection: TextDirection.ltr,
                          creationParams: {
                            'initialStartPos': fromPosition?.toMap() ??
                                const LatLng(24.9412, 67.1139).toMap(),
                            'initialDestPos': toPosition?.toMap() ??
                                const LatLng(24.9312, 67.1239).toMap(),
                            'initialActiveMarker': activeMarker,
                            'showMarkersByDefault': true,
                            'showMarkers': true,
                            'showLabels': true,
                            'forceShowLabels': true,
                          },
                          creationParamsCodec: const StandardMessageCodec(),
                          onPlatformViewCreated: (id) {
                            _methodChannel =
                                MethodChannel('native_google_map_$id');
                            _methodChannel
                                .setMethodCallHandler(_handleMapMethodCall);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _updateMapMarkers();
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _buildNextButton(context, roleState.role),
                      SizedBox(height: 60.h),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, String role) {
    return GradientButton(
      onTap: () {
        if (fromPlaceId != null && toPlaceId != null) {
          _handleNavigation(context, role);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select both locations!')),
          );
        }
      },
      text: 'Next',
    );
  }

  void _handleNavigation(BuildContext context, String role) {
    final location = SourceAndDestModel(
      fromPlaceId: fromPlaceId!,
      fromDescription: fromDescription!,
      toPlaceId: toPlaceId!,
      toDescription: toDescription!,
    );

    final route = role == 'Driver' ? '/route_display_page' : '/r1_page';
    final arguments = role == 'Driver'
        ? {
            'fromPlaceId': fromPlaceId,
            'toPlaceId': toPlaceId,
            'fromDescription': fromDescription,
            'toDescription': toDescription,
            'fromPosition': fromPosition?.toMap(),
            'toPosition': toPosition?.toMap(),
            'role': role.toLowerCase(),
          }
        : {'location': location};

    Navigator.of(context).pushNamed(route, arguments: arguments);
  }
}

extension LatLngExtension on LatLng {
  Map<String, double> toMap() {
    return {'lat': latitude, 'lng': longitude};
  }
}

LatLng getSafePosition(LatLng? position, LatLng fallback) {
  return (position == null ||
          (position.latitude == 0 && position.longitude == 0))
      ? fallback
      : position;
}
