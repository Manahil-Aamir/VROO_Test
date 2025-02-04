import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../shared/widgets/location_selection_button_widget.dart';
import '../../../../shared/widgets/top_bar_widget.dart';
import '../../dependency_injection/driver_home_di.dart';
import '../bloc/bloc/driver_home_bloc.dart';
import '../bloc/event/driver_home_event.dart';
import '../bloc/state/driver_home_state.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  @override
  Widget build(BuildContext context) {
    context.read<DriverHomeBloc>().add(ClearSharedPreferencesEvent());
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<DriverHomeBloc, DriverHomeState>(
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
