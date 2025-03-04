import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../bloc/bloc/home_bloc.dart';
import '../bloc/state/home_state.dart';
import '../widgets/location_selection_button_widget.dart';
import '../widgets/side_bar_widget.dart';
import '../widgets/top_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarWidget(),
      body: Stack(
        children: [
          _buildMapContent(),
          TopBarWidget(scaffoldKey: _scaffoldKey),
          const LocationSelectionButtonsWidget(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
      ),
    );
  }

  Widget _buildMapContent() {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLogoutSuccess) {
          context.read<Navigation>().navigateTo('/sign_in');
        }
      },
      builder: (context, state) {
        return const NativeGoogleMap();
      },
    );
  }
}

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