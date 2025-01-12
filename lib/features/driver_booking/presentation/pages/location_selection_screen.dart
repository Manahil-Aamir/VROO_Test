import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/Appbar.dart';
import '../../dependency_injection/location_selection_di.dart';
import '../bloc/location_selection_bloc.dart';
import '../../../../shared/widgets/location_input_field.dart';
import '../../../../shared/widgets/gradientButton.dart';
import '../bloc/location_selection_event.dart';

class LocationSelectionScreen extends StatelessWidget {
  final String role;
    String? fromPlaceId;
    String? fromDescription;
    String? toPlaceId;
    String? toDescription;

  LocationSelectionScreen({required this.role, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(heading: "Select Location"),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Close keyboard and suggestions
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BlocProvider(
                create: (_) => LocationSelectionBloc(
                  DependencyInjector.fetchSuggestionsUseCase,
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
              const SizedBox(height: 10),
              BlocProvider(
                create: (_) => LocationSelectionBloc(
                  DependencyInjector.fetchSuggestionsUseCase,
                ),
                child: LocationInputField(
                  label: 'Where would you go?',
                  onPlaceSelected: (placeId, description) {
                    print('To Location Selected: $description ($placeId)');
                    toPlaceId = placeId;
                    toDescription = description;
                  },
                ),
              ),
              const Spacer(),
              GradientButton(
                onTap: () {
                  if (fromPlaceId != null && toPlaceId != null) {
                    Navigator.of(context).pushNamed(
                      '/d1',
                      arguments: {
                      'fromPlaceId': fromPlaceId,
                      'fromDescription': fromDescription,
                      'toPlaceId': toPlaceId,
                      'toDescription': toDescription,
                      },
                    );
                } else {
                  // Optionally show a message if the user hasn't selected both locations
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select both locations!')),
                  );
                }
              },
                text: 'Next',
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}



// class LocationSelectionScreen extends StatelessWidget {
//   final String role;

//   const LocationSelectionScreen({required this.role, super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Declare FocusNodes for both input fields
//     final focusNode1 = FocusNode();
//     final focusNode2 = FocusNode();

//     return Scaffold(
//       appBar: appBar(heading: "Select Location"),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // First input field
//             GestureDetector(
//               onTap: () {
//                 focusNode1.requestFocus(); // Focus first input
//                 focusNode2.unfocus(); // Unfocus second input
//               },
//               child: BlocProvider(
//                 create: (_) => LocationSelectionBloc(
//                   DependencyInjector.fetchSuggestionsUseCase,
//                 ),
//                 child: LocationInputField(
//                   label: 'From where would you go?',
//                   focusNode: focusNode1,
//                   onPlaceSelected: (placeId, description) {
//                     print('From Location Selected: $description ($placeId)');
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             // Second input field
//             GestureDetector(
//               onTap: () {
//                 focusNode2.requestFocus(); // Focus second input
//                 focusNode1.unfocus(); // Unfocus first input
//               },
//               child: BlocProvider(
//                 create: (_) => LocationSelectionBloc(
//                   DependencyInjector.fetchSuggestionsUseCase,
//                 ),
//                 child: LocationInputField(
//                   label: 'Where would you go?',
//                   focusNode: focusNode2,
//                   onPlaceSelected: (placeId, description) {
//                     print('To Location Selected: $description ($placeId)');
//                   },
//                 ),
//               ),
//             ),
//             const Spacer(),
//             GradientButton(
//               onTap: () {
//                 Navigator.of(context).pushNamed('/d1');
//               },
//               text: 'Next',
//             ),
//             SizedBox(height: 60),
//           ],
//         ),
//       ),
//     );
//   }
// }

