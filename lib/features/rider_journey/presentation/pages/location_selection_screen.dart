import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart'; // Add provider import
import 'package:vroo_test/features/rider_journey/data/model/source_and_dest_model.dart';
import 'package:vroo_test/features/rider_journey/domain/entity/source_and_dest_entity.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/Appbar.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/location_selection_input.dart';
import '../../dependancy_injection/location_selection_di.dart';

class RiderLocationSelectionScreen extends StatefulWidget {
  final String role;

  const RiderLocationSelectionScreen({required this.role, super.key});

  @override
  _LocationSelectionScreenState createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState
    extends State<RiderLocationSelectionScreen> {
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
      providers: LocationSelectionDependencyInjection
          .init(), // Assuming this provides all necessary dependencies
      builder: (context, child) => Scaffold(
        appBar: appBar(heading: "Select Location"), // Custom AppBar
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                LocationInputField(
                  label: 'From where would you go?',
                  initialValue: fromDescription,
                  onPlaceSelected: (placeId, description) {
                    print('from');
                    print(placeId);
                    print(description);
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
                GradientButton(
                  onTap: () {
                    if (fromPlaceId != null && toPlaceId != null) {
                      print('to');
                      print(toPlaceId);
                      print(toDescription);
                      SourceAndDestModel location = SourceAndDestModel(
                        fromPlaceId: fromPlaceId!,
                        fromDescription: fromDescription!,
                        toPlaceId: toPlaceId!,
                        toDescription: toDescription!,
                      );
                      context.read<Navigation>().navigateTo(
                        Routes.r1Page,
                        arguments: {
                          'location': location,
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
                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
