import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/Appbar.dart';
import '../../../../shared/widgets/gradientButton.dart';
import '../../../../shared/widgets/location_selection_input.dart';
import '../../dependency_injection/location_selection_di.dart';
import '../../domain/usecases/fetch_suggestions_usecase.dart';
import '../bloc/bloc/location_selection_bloc.dart';

class LocationSelectionScreen extends StatelessWidget {
  final String role;
  String? fromPlaceId;
  String? fromDescription;
  String? toPlaceId;
  String? toDescription;

  LocationSelectionScreen({required this.role, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: LocationDependencyInjection.init(),
      child: Scaffold(
        appBar: appBar(heading: "Select Location"),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Close keyboard and suggestions
          },
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                BlocProvider(
                  create: (context) => LocationSelectionBloc(
                    context.read<FetchSuggestionsUseCase>(),
                  ),
                  child: LocationInputField(
                    label: 'From where would you go?',
                    onPlaceSelected: (placeId, description) {
                      fromPlaceId = placeId;
                      fromDescription = description;
                      print('From Location Selected: $description ($placeId)');
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                BlocProvider(
                  create: (context) => LocationSelectionBloc(
                    context.read<FetchSuggestionsUseCase>(),
                  ),
                  child: LocationInputField(
                    label: 'Where would you go?',
                    onPlaceSelected: (placeId, description) {
                      toPlaceId = placeId;
                      toDescription = description;
                      print('To Location Selected: $description ($placeId)');
                    },
                  ),
                ),
                const Spacer(),
                GradientButton(
                  onTap: () {
                    if (fromPlaceId != null && toPlaceId != null) {
                      context.read<Navigation>().navigateTo(
                        Routes.d1,
                        arguments: {
                          'toPlaceID': toPlaceId,
                          'fromPlaceID': fromPlaceId,
                          'toDescription': toDescription,
                          'fromDescription': fromDescription,
                        }
                      );
                      // Navigator.pushNamed(
                      //   context,
                      //   Routes.d1,
                      //   arguments: {
                      //     'toPlaceID': toPlaceId,
                      //     'fromPlaceID': fromPlaceId,
                      //     'toDescription': toDescription,
                      //     'fromDescription': fromDescription,
                      //   },
                      // );
                    } else {
                      // Optionally show a message if the user hasn't selected both locations
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
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

