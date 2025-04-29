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
        _expandModal();
      }
    });

    _toFocusNode.addListener(() {
      if (_toFocusNode.hasFocus) {
        _expandModal();
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
    print('Marker update data: $data');
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

    // Request place details for this location
    _methodChannel.invokeMethod('getPlaceDetails', {
      'lat': lat,
      'lng': lng,
      'type': type,
    });
  }

  // Add this new method to better handle place ID loaded from the bloc
  void _handlePlaceIdLoaded(String placeId) {
    // Only update if we have an active marker
    if (activeMarker == null) return;

    setState(() {
      if (activeMarker == 'start') {
        fromPlaceId = placeId;
        // Request address details for this location
        if (fromPosition != null) {
          _methodChannel.invokeMethod('getPlaceDetails', {
            'lat': fromPosition!.latitude,
            'lng': fromPosition!.longitude,
            'type': 'start',
          });
        }
      } else if (activeMarker == 'dest') {
        toPlaceId = placeId;
        // Request address details for this location
        if (toPosition != null) {
          _methodChannel.invokeMethod('getPlaceDetails', {
            'lat': toPosition!.latitude,
            'lng': toPosition!.longitude,
            'type': 'dest',
          });
        }
      }
    });

    // Update markers on the map to reflect the changes
    _updateMapMarkers();
  }

  // Improve the _handlePlaceInfo method to properly update the text controllers
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
          // Update the text controller directly
          _fromController.text = placeName;
        } else {
          toDescription = placeName;
          if (placeId != null && placeId.isNotEmpty) {
            toPlaceId = placeId;
          }
          // Update the text controller directly
          _toController.text = placeName;
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

  // Improve _handleEnhancedPlaceInfo similarly
  Future<void> _handleEnhancedPlaceInfo(Map<String, dynamic> data) async {
    final type = data['type'] as String;
    final address = data['address'] as String? ?? '';
    final placeId = data['placeId'] as String? ?? '';

    if (address.isNotEmpty) {
      setState(() {
        if (type == 'start') {
          fromDescription = address;
          if (placeId.isNotEmpty) fromPlaceId = placeId;
          // Update the controller text directly
          _fromController.text = address;
        } else {
          toDescription = address;
          if (placeId.isNotEmpty) toPlaceId = placeId;
          // Update the controller text directly
          _toController.text = address;
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

  // Improve _handleMapTap to update controllers directly
  Future<void> _handleMapTap(Map<String, dynamic> data) async {
    final key = data['key'] as String;
    final lat = data['lat'] as double;
    final lng = data['lng'] as double;
    final placeName = data['placeName'] as String?;

    setState(() {
      if (key == 'from') {
        fromPosition = LatLng(lat, lng);
        if (placeName != null) {
          fromDescription = placeName;
          _fromController.text = placeName;
        }
        activeMarker = 'start';
      } else {
        toPosition = LatLng(lat, lng);
        if (placeName != null) {
          toDescription = placeName;
          _toController.text = placeName;
        }
        activeMarker = 'dest';
      }
    });

    // Fetch place ID for this location using bloc
    context.read<LocationSelectionBloc>().add(
          FetchPlaceIdFromLatLngEvent(lat, lng),
        );

    // Also request the address details directly from the map
    _methodChannel.invokeMethod('getPlaceDetails', {
      'lat': lat,
      'lng': lng,
      'type': key == 'from' ? 'start' : 'dest',
    });

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

  @override
  @override
/*************  ✨ Windsurf Command ⭐  *************/
  /// Builds the UI for selecting a location on a map.
  ///
  /// It creates a [Scaffold] with an [AppBar] and a [BlocProvider] that
  /// provides the [LocationSelectionBloc] to its descendants.
  ///
  /// The body of the [Scaffold] is a [BlocListener] that listens to the
  /// [LocationSelectionBloc] and updates the UI when the state changes.
  ///
  /// The [BlocListener] has a child which is a [BlocBuilder] that builds the
  /// UI depending on the role of the user.
  ///
  /// The [BlocBuilder] builds a [Stack] with two children. The first child
  /// is the map background which is an [AndroidView] that displays the
  /// native Google Map. The second child is the bottom modal sheet which
  /// displays the location details and the buttons to select the location.
  ///
  /// The [BlocBuilder] also sets up the method channel to handle the
  /// platform view's method calls and updates the map markers when the
  /// platform view is created.
  ///
  /// The [BlocListener] also sets up the method channel to handle the
  /// platform view's method calls and updates the map markers when the
  /// location is selected.
  /// *****  a3807f31-7023-40bb-811d-307f19100356  ******
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: appBar(heading: "Select Location"),
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => context.read<LocationSelectionBloc>(),
        child: BlocListener<LocationSelectionBloc, LocationSelectionState>(
          listener: (context, state) {
            if (state is PlaceIdLoaded) {
              _handlePlaceIdLoaded(state.placeId);
            }
            if (state is LatLngLoaded) {
              // Close keyboard and minimize modal when location is selected
              FocusScope.of(context).unfocus();
              _minimizeModal();
            }
          },
          child: BlocBuilder<RoleBloc, RoleState>(
            builder: (context, roleState) {
              return Stack(
                children: [
                  // Map background
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 250.h,
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
                        _methodChannel = MethodChannel('native_google_map_$id');
                        _methodChannel
                            .setMethodCallHandler(_handleMapMethodCall);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _updateMapMarkers();
                        });
                      },
                    ),
                  ),

                  // Bottom Modal Sheet
                  _buildBottomModal(context, theme, roleState.role),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

// Control modal expansion state
  bool _isModalExpanded = false;

  void _expandModal() {
    if (!_isModalExpanded) {
      setState(() {
        _isModalExpanded = true;
      });
    }
  }

  void _minimizeModal() {
    if (_isModalExpanded) {
      setState(() {
        _isModalExpanded = false;
      });
    }
  }

  Widget _buildBottomModal(BuildContext context, ThemeData theme, String role) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: 0,
      right: 0,
      bottom: 0,
      // When expanded, show more of the modal
      height: _isModalExpanded
          ? MediaQuery.of(context).size.height * 0.825
          : MediaQuery.of(context).size.height * 0.35,
      child: GestureDetector(
        // Allow manual open/close with drag
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            // Swipe up to expand
            _expandModal();
          } else if (details.primaryVelocity! > 0) {
            // Swipe down to minimize
            _minimizeModal();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: theme.primaryColorDark,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar for dragging
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                width: 50.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Location input fields
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.primaryColorDark.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // From Location Field with focus listener
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
                      // To Location Field with focus listener
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
                    ],
                  ),
                ),
              ),

              // Next button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: _buildNextButton(context, role),
              ),
            ],
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
