import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/bottomnavbar.dart';
import '../../../../shared/widgets/side_bar.dart';
import '../../../../shared/widgets/top_bar_rider_widget.dart';
import '../../dependancy_injection/rider_home_di.dart';
import '../bloc/bloc/rider_home_bloc.dart';
import '../bloc/state/rider_home_state.dart';
import '../widgets/locationselection.dart';
import '../../../../shared/widgets/top_bar_widget.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  _RiderHomeScreenState createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: BlocProvider.value(
        value: context.read<
            RiderHomeBloc>(), // Ensure SidebarWidget has access to RiderHomeBloc
        child: const SidebarWidget(),
      ),
      body: Stack(
        children: [
          BlocConsumer<RiderHomeBloc, RiderHomeState>(
            listener: (context, state) {
              print('State:$state');
              if (state is RiderHomeLogoutSuccess) {
                print('logging out');
                Future.microtask(
                    () => context.read<Navigation>().navigateTo('/sign_in'));
              }
            },
            builder: (context, state) {
              return const NativeGoogleMap(); // Replaced GoogleMap with NativeGoogleMap
            },
          ),
          TopBarRiderWidget(
            roleText: 'Rider',
            scaffoldKey: key,
          ),
          const RiderLocationSelectionButtonsWidget(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
        onTap: (index) {
          // Handle bottom navigation tap
        },
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
