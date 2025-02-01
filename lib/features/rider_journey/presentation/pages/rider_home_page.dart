import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/bottomnavbar.dart';
import '../../dependancy_injection/rider_home_di.dart';
import '../bloc/bloc/rider_home_bloc.dart';
import '../bloc/state/rider_home_state.dart';
import '../widgets/locationselection.dart';
import '../widgets/topbarwidget.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  _RiderHomeScreenState createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: RiderHomeDependencyInjection.init(),
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<RiderHomeBloc, RiderHomeState>(
              builder: (context, state) {
                return const NativeGoogleMap(); // Replaced GoogleMap with NativeGoogleMap
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

// Widget to embed the native Android Google Map
class NativeGoogleMap extends StatelessWidget {
  const NativeGoogleMap({super.key});

  @override
  Widget build(BuildContext context) {
    return const AndroidView(
      viewType: 'native_google_map',
      layoutDirection: TextDirection.ltr,
      creationParamsCodec: StandardMessageCodec(),
    );
  }
}
