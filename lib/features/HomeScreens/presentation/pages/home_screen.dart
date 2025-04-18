import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../shared/widgets/custom_dialog.dart';
import '../bloc/bloc/home_bloc.dart';
import '../bloc/event/home_event.dart';
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
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadUserEvent());
    _printToken();
  }

  Future<void> _printToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      print('User ID Token: $token');
    } else {
      print('No user logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await _showExitDialog(context);
        if (exitApp) {
          SystemNavigator.pop(); // Closes the app
        }
        return false; // Prevents the default back action
      },
      child: Scaffold(
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
        print('HomeState: $state');

        return const NativeGoogleMap();
      },
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => CustomDialog(
            title: "Exit App",
            message: "Are you sure you want to exit?",
            confirmText: "Yes",
            cancelText: "No",
            confirmColor: Theme.of(context).indicatorColor,
            cancelColor: Theme.of(context).primaryColorDark,
            onConfirm: () {
              Navigator.of(context).pop(true);
            },
            onCancel: () {
              Navigator.of(context).pop(false);
            },
          ),
        ) ??
        false;
  }
}

class NativeGoogleMap extends StatelessWidget {
  const NativeGoogleMap({super.key});

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'native_google_map',
      layoutDirection: TextDirection.ltr,
      creationParams: {
        'showMarkersByDefault': false, // Explicitly disable markers
      },
      creationParamsCodec: const StandardMessageCodec(), // Add this line
    );
  }
}
