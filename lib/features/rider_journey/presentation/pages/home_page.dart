import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/bottomnavbar.dart';
import '../../di/home_di.dart';
import '../bloc/bloc/home_bloc.dart';
import '../bloc/state/home_state.dart';
import '../widgets/locationselection.dart';
import '../widgets/topbarwidget.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  _RiderHomeScreenState createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  late GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: RiderHomeDependencyInjection.init(),
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<RiderHomeBloc, RiderHomeState>(
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
