import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart'; 
import '../../../../core/router/navigation.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/location_selection_input.dart';
import '../../dependency_injection/location_selection_di.dart';

class LocationSelectionScreen extends StatefulWidget {
  final String role;

  const LocationSelectionScreen({required this.role, super.key});

  @override
  _LocationSelectionScreenState createState() =>
      _LocationSelectionScreenState();
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
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fromPlaceId = prefs.getString('fromPlaceId');
      fromDescription = prefs.getString('fromDescription');
      toPlaceId = prefs.getString('toPlaceId');
      toDescription = prefs.getString('toDescription');
    });
  }

  Future<void> _saveSelectedLocation(
      {required String keyId,
      required String keyDesc,
      required String placeId,
      required String description}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyId, placeId);
    await prefs.setString(keyDesc, description);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MultiProvider(
      providers: LocationSelectionDependencyInjection.init(),
      builder: (context, child) => Scaffold(
        appBar: appBar(heading: "Select Location"),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Column(
                    children: [
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
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.h),
              child: GradientButton(
                onTap: () {
                  if (fromPlaceId != null && toPlaceId != null) {
                    context.read<Navigation>().navigateTo(
                      '/d1',
                      arguments: {
                        'toPlaceId': toPlaceId,
                        'fromPlaceId': fromPlaceId,
                        'toDescription': toDescription,
                        'fromDescription': fromDescription,
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: theme.indicatorColor,
                        content: Text('Please select both locations!'),
                      ),
                    );
                  }
                },
                text: 'Next',
              ),
            ),
            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }

}
