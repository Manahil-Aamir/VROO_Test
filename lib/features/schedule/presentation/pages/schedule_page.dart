import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../HomeScreens/presentation/bloc/role_bloc.dart';
import '../bloc/bloc/schedule_bloc.dart';
import '../bloc/event/schedule_event.dart';
import '../bloc/state/schedule_state.dart';
import '../widgets/schedule_card.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        heading: 'Schedule',
        actionIcon: Icons.refresh,
        onActionPressed: () {
          final currentRole = context.read<RoleBloc>().state.role;
          context.read<ScheduleBloc>().add(RefreshSchedulesEvent(role: currentRole));
        },
      ),
      body: BlocBuilder<RoleBloc, RoleState>(
        builder: (context, roleState) {
          return BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: (context, scheduleState) {
              if (scheduleState is ScheduleInitial) {
                // Load schedules with current role
                context.read<ScheduleBloc>().add(LoadSchedulesEvent(role: roleState.role));
                return const Center(child: CircularProgressIndicator(color: ThemeColors.primaryColor));
              } else if (scheduleState is ScheduleLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.primaryColor),
                  ),
                );
              } else if (scheduleState is ScheduleLoaded) {
                if (scheduleState.schedules.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No schedules found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ScheduleBloc>().add(RefreshSchedulesEvent(role: roleState.role));
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: scheduleState.schedules.length,
                    itemBuilder: (context, index) {
                      return ScheduleCard(schedule: scheduleState.schedules[index], role:roleState.role);
                    },
                  ),
                );
              } else if (scheduleState is ScheduleError) {
                print(scheduleState.message);
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/error.png',
                        width: 300.w,
                        height: 300.h,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
