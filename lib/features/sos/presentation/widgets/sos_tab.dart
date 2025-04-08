import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/custom_dialog.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';
import '../../data/data_source/tracking_data_source.dart';
import '../bloc/bloc/sos_bloc.dart';
import '../bloc/event/sos_event.dart';
import '../bloc/state/sos_state.dart';

class SosTab extends StatefulWidget {
  final String uid;

  const SosTab({super.key, required this.uid});

  @override
  _SosTabState createState() => _SosTabState();
}

class _SosTabState extends State<SosTab> with SingleTickerProviderStateMixin {
  String _latestSessionId = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<SosBloc, SosState>(
      listener: (context, state) {
        if (state is SosTriggered) {
          _latestSessionId = state.sessionId;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("SOS Triggered Successfully!"),
              backgroundColor: theme.secondaryHeaderColor,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is SosError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.indicatorColor,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SOS Button
              InkResponse(
                onTap: () =>
                    BlocProvider.of<SosBloc>(context).add(TriggerSos()),
                borderRadius: BorderRadius.circular(90),
                splashColor: theme.indicatorColor.withOpacity(0.3),
                highlightColor: theme.indicatorColor.withOpacity(0.2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 180.w,
                  height: 180.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.indicatorColor,
                        theme.indicatorColor.withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.indicatorColor.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "SOS",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              GradientButton(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (dialogContext) => CustomDialog(
                            title: "Stop Tracking",
                            message: "Are you sure you want to stop tracking?",
                            confirmColor: theme.indicatorColor,
                            cancelColor: theme.primaryColorDark,
                            confirmText: "Yes",
                            cancelText: "No",
                            onConfirm: () {
                              Navigator.pop(dialogContext);
                              SosTrackerService(sessionId: _latestSessionId)
                                  .stopTracking();
                            },
                            onCancel: () {
                              Navigator.pop(dialogContext);
                            },
                          ));
                },
                text: 'Stop Tracking',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
