import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../shared/widgets/side_bar.dart';
import '../../../../shared/widgets/top_bar_driver_widget.dart';
import '../../dependency_injection/driver_home_di.dart';
import 'widgets/driver_location_selection_button_widget.dart';
import '../bloc/bloc/driver_home_bloc.dart';
import '../bloc/state/driver_home_state.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: BlocProvider.value(
        value: context.read<DriverHomeBloc>(), // Provide existing instance
        child: SidebarWidget(
          isRider: false,
        ),
      ),
      body: Stack(
        children: [
          BlocListener<DriverHomeBloc, DriverHomeState>(
            listener: (context, state) {
              if (state is DriverHomeLogoutSuccess) {
                context.read<Navigation>().navigateTo('/sign_in');
              }
            },
            child: BlocBuilder<DriverHomeBloc, DriverHomeState>(
              builder: (context, state) {
                return const NativeGoogleMap(); // Replaced GoogleMap with NativeGoogleMap
              },
            ),
          ),
          TopBarDriverWidget(
            scaffoldKey: key,
            roleText: 'Driver',
          ),
          const DriverLocationSelectionButtonsWidget(),
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
