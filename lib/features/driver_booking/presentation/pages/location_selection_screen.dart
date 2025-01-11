import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/shared/widgets/Appbar.dart';
import '../../../../shared/widgets/recent_place_item.dart';
import '../bloc/location_selection_bloc.dart';
import '../../../../shared/widgets/location_input_field.dart';

class LocationSelectionScreen extends StatelessWidget {
  final String role;

  const LocationSelectionScreen({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(heading: "Select Location"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocProvider(
              create: (_) => LocationSelectionBloc(),
              child: LocationInputField(
                label: 'From where would you go?',
                onPlaceSelected: (placeId, description) {
                  print('From Location Selected: $description ($placeId)');
                  // Save this location to your state or logic
                },
              ),
            ),
            const SizedBox(height: 10),
            BlocProvider(
              create: (_) => LocationSelectionBloc(),
              child: LocationInputField(
                label: 'Where would you go?',
                onPlaceSelected: (placeId, description) {
                  print('To Location Selected: $description ($placeId)');
                  // Save this location to your state or logic
                },
              ),
            ),
            const SizedBox(height: 20),
            const RecentPlaceItem(
              title: 'Office',
              address: '2972 Westheimer Rd.',
              distance: '2.7km'
            ),
          ],
        ),
      ),
    );
  }
}
