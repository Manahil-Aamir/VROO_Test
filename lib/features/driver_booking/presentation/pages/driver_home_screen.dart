import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../shared/widgets/bottomNav.dart';
import '../../../../shared/widgets/icon_button.dart';
import '../../../../shared/widgets/location_buttons.dart';
import '../bloc/driver_home_bloc.dart';
import '../bloc/driver_home_event.dart';
import '../bloc/driver_home_state.dart';

class DriverHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverHomeBloc(),
      child: Scaffold(
        body: Stack(
          children: [
            // Google Map
            GoogleMap(
              onMapCreated: (controller) {},
              initialCameraPosition: CameraPosition(
                target: const LatLng(24.941875, 67.114297),
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
            // Top bar
            Positioned(
              top: 40,
              left: 20,
              right: 20,
              child: _buildTopBar(),
            ),
            // Location selection buttons
            Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: BlocBuilder<DriverHomeBloc, DriverHomeState>(
                builder: (context, state) {
                  return LocationButtons(
                    onStartingPointTap: () => BlocProvider.of<DriverHomeBloc>(context).add(
                      SelectStartingPoint('Starting Point', 'Location A'),
                    ),
                    onDestinationTap: () => BlocProvider.of<DriverHomeBloc>(context).add(
                      SelectDestinationPoint('Destination', 'Location B'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: 0,
          onTap: (index) {
            // Handle bottom navigation tap
          },
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomIconButton(
          icon: Icons.menu,
          onPressed: () {},
        ),
        Container(
          width: 150,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFEC8825),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Center(
            child: Text(
              'Driver',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        CustomIconButton(
          icon: Icons.notifications,
          onPressed: () {},
        ),
      ],
    );
  }
}
