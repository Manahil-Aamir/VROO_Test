import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../rider_journey/data/model/source_and_dest_model.dart';
import '../bloc/role_bloc.dart';
import '../widgets/location_input_widget.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  _LocationSelectionScreenState createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  String? fromPlaceId;
  String? fromDescription;
  String? toPlaceId;
  String? toDescription;

  @override
  void initState() {
    super.initState();
    _loadSavedLocations();
  }

  Future<void> _loadSavedLocations() async {
    final role = context.read<RoleBloc>().state.role.toLowerCase();
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fromPlaceId = prefs.getString('${role}_fromPlaceId');
      fromDescription = prefs.getString('${role}_fromDescription');
      toPlaceId = prefs.getString('${role}_toPlaceId');
      toDescription = prefs.getString('${role}_toDescription');
    });
  }

  Future<void> _saveSelectedLocation({
    required String keyId,
    required String keyDesc,
    required String placeId,
    required String description,
  }) async {
    final role = context.read<RoleBloc>().state.role.toLowerCase();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${role}_$keyId', placeId);
    await prefs.setString('${role}_$keyDesc', description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(heading: "Select Location"),
      body: BlocBuilder<RoleBloc, RoleState>(
        builder: (context, roleState) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  // LocationInputField is now properly nested under the BlocProvider
                  LocationInputField(
                    label: 'From where would you go?',
                    initialValue: fromDescription,
                    onPlaceSelected: (placeId, description) {
                      setState(() {
                        fromPlaceId = placeId;
                        fromDescription = description;
                      });
                      _saveSelectedLocation(
                        keyId: 'fromPlaceId',
                        keyDesc: 'fromDescription',
                        placeId: placeId,
                        description: description,
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  LocationInputField(
                    label: 'Where would you go?',
                    initialValue: toDescription,
                    onPlaceSelected: (placeId, description) {
                      setState(() {
                        toPlaceId = placeId;
                        toDescription = description;
                      });
                      _saveSelectedLocation(
                        keyId: 'toPlaceId',
                        keyDesc: 'toDescription',
                        placeId: placeId,
                        description: description,
                      );
                    },
                  ),
                  SizedBox(height: 40.h),
                  _buildNextButton(context, roleState.role),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, String role) {
    final theme = Theme.of(context);
    return GradientButton(
      onTap: () {
        if (fromPlaceId != null && toPlaceId != null) {
          _handleNavigation(context, role);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: theme.indicatorColor,
              content: const Text('Please select both locations!'),
            ),
          );
        }
      },
      text: 'Next',
    );
  }

  void _handleNavigation(BuildContext context, String role) {
    final args = {
      'fromPlaceId': fromPlaceId,
      'toPlaceId': toPlaceId,
      'fromDescription': fromDescription,
      'toDescription': toDescription,
      'role': role.toLowerCase(),
    };

    final location = SourceAndDestModel(
      fromPlaceId: fromPlaceId!,
      fromDescription: fromDescription!,
      toPlaceId: toPlaceId!,
      toDescription: toDescription!,
  );

    final route = role == 'Driver' 
        ? '/route_display_page' 
        : '/r1_page';

    final arguments = role == 'Driver' 
        ? args 
        : {'location': location};;

    context.read<Navigation>().navigateTo(route, arguments: arguments);
  }
}