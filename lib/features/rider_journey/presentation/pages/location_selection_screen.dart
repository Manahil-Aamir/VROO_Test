import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vroo_test/features/rider_journey/presentation/bloc/state/location_selection_state.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/Appbar.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/location_selection_input.dart';
import '../../dependancy_injection/location_selection_di.dart';
import '../../domain/usecases/location_usecase.dart';
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
      child: Builder(
        builder: (context) => Scaffold(
          appBar: appBar(heading: "Select Location"),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: BlocBuilder<LocationSelectionBloc, LocationSelectionState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // "From" location input field
                      BlocProvider(
                        create: (_) => LocationSelectionBloc(
                          context.read<FetchSuggestionsUseCase>(),
                        ),
                        child: LocationInputField(
                          label: 'From where would you go?',
                          onPlaceSelected: (placeId, description) {
                            fromPlaceId = placeId;
                            fromDescription = description;
                            print(
                                'From Location Selected: $description ($placeId)');
                          },
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // "To" location input field
                      BlocProvider(
                        create: (_) => LocationSelectionBloc(
                          context.read<FetchSuggestionsUseCase>(),
                        ),
                        child: LocationInputField(
                          label: 'Where would you go?',
                          onPlaceSelected: (placeId, description) {
                            toPlaceId = placeId;
                            toDescription = description;
                            print(
                                'To Location Selected: $description ($placeId)');
                          },
                        ),
                      ),
                      const Spacer(),

                      // Gradient button for navigation
                      GradientButton(
                        onTap: () {
                          if (fromPlaceId != null &&
                              toPlaceId != null &&
                              role == 'rider') {
                            context.read<Navigation>().navigateTo(
                              Routes.r1Page,
                              arguments: {
                                'fromDescription': fromDescription ?? '',
                                'toDescription': toDescription ?? '',
                                'fromPlaceId': fromPlaceId ?? '',
                                'toPlaceId': toPlaceId ?? '',
                              },
                            );
                          } else {
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
