import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../shared/widgets/location_selection_button_widget.dart';
import '../../../../shared/widgets/top_bar_widget.dart';
import '../../dependency_injection/driver_home_di.dart';
import '../bloc/bloc/driver_home_bloc.dart';
import '../bloc/state/driver_home_state.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  late GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: DriverHomeDependencyInjection.init(),
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<DriverHomeBloc, DriverHomeState>(
              builder: (context, state) {
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: const LatLng(24.941875, 67.114297),
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                );
              },
            ),
            const TopBarWidget(),
            const LocationSelectionButtonsWidget(),
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
}
