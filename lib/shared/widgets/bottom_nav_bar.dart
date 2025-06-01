import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/HomeScreens/presentation/bloc/role_bloc.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavBar({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    String route;
    switch (index) {
      case 0:
        route = '/home';
        break;
      case 1:
        final role = context.read<RoleBloc>().state.role;
        route =
            role == 'Driver' ? '/active_ride_driver' : '/ride_request_rider';
        break;
      case 2:
        route = '/chat';
        break;
      case 3:
        route = '/user_profile';
        break;
      default:
        return;
    }

    if (selectedIndex != index) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<RoleBloc, RoleState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (index) {
              IconData iconData;
              String label;

              switch (index) {
                case 0:
                  iconData = Icons.home;
                  label = 'Home';
                  break;
                case 1:
                  iconData = Icons.list_alt_rounded;
                  label = 'Rides';
                  break;
                case 2:
                  iconData = Icons.chat_bubble_outline;
                  label = 'Chat';
                  break;
                case 3:
                  iconData = Icons.person_outline;
                  label = 'Profile';
                  break;
                default:
                  iconData = Icons.help_outline;
                  label = 'Help';
              }

              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () => _onItemTapped(context, index),
                child: Transform.translate(
                  offset: isSelected ? const Offset(0, -20) : Offset.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.4),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: Icon(
                          iconData,
                          color: isSelected
                              ? theme.canvasColor
                              : theme.primaryColorLight,
                          size: isSelected ? 30 : 24,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (isSelected)
                        Text(
                          label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
