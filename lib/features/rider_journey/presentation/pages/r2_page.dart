import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/rider_journey/data/model/preferences_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/source_and_dest_model.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../data/model/schedule_model.dart';
import '../bloc/bloc/r2_bloc.dart';
import '../bloc/event/r2_event.dart';
import '../bloc/state/r2_state.dart';
import '../widgets/preference_switch.dart';

class R2Page extends StatefulWidget {
  final ScheduleModel schedule;
  final SourceAndDestModel location;

  const R2Page({
    super.key,
    required this.schedule,
    required this.location,
  });

  void init() {
    print('r2');
    print(location.fromDescription);
  }

  @override
  _R2PageState createState() => _R2PageState();
}

class _R2PageState extends State<R2Page> {
  bool? selectedSameGender;
  bool? selectedWalk;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<R2Bloc, R2State>(
            builder: (context, state) {
              print('val${widget.location.fromDescription}');
              if (state is PreferenceSaved) {
                context.read<R2Bloc>().add(ResetStateEvent());
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.progressIndicatorTheme.color!,
                    ),
                  ),
                );
              }
              if (state is PreferenceInitial) {
                context.read<R2Bloc>().add(LoadPreferenceEvent());
              }
              if (state is PreferenceLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.progressIndicatorTheme.color!,
                    ),
                  ),
                );
              } else if (state is PreferenceLoaded) {
                // Transition to PreferenceInputState with the loaded preference
                final preference = state.loadedPreference;
                context.read<R2Bloc>().add(UpdatePreferenceEvent(
                      sameGender: preference.sameGender,
                      walk: preference.walk,
                    ));
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.progressIndicatorTheme.color!,
                    ),
                  ),
                );
              } else if (state is PreferenceInputState) {
                final bloc = context.read<R2Bloc>();

                return Scaffold(
                  appBar: CustomAppBar(
                    highlightedCircles: 2,
                  ),
                  body: Padding(
                    padding: EdgeInsets.all(30.0.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PreferenceSwitch(
                            icon: Icons.person,
                            label: "Same Gender Only",
                            value: state.sameGender ?? false,
                            onChanged: (value) {
                              context
                                  .read<R2Bloc>()
                                  .add(TogglePreferenceEvent('sameGender'));
                            },
                          ),
                          SizedBox(height: 20.h),
                          PreferenceSwitch(
                            icon: Icons.directions_walk,
                            label: "Prefer Walk",
                            value: state.walk ?? false,
                            onChanged: (value) {
                              bloc.add(TogglePreferenceEvent('walk'));
                            },
                          ),
                          SizedBox(height: 50.h),
                          GradientButton(
                            onTap: () {
                              print(state.sameGender);
                              print(state.walk);
                              final preference = PreferencesModel(
                                sameGender: state.sameGender ?? false,
                                walk: state.walk ?? false,
                              );
                              context
                                  .read<R2Bloc>()
                                  .add(SavePreferenceEvent(preference));
                              print('description');
                              print(preference.walk);
                              context
                                  .read<Navigation>()
                                  .navigateTo('/r3_page', arguments: {
                                'schedule': widget.schedule,
                                'preferences': preference,
                                'location': widget.location,
                              });
                            },
                            text: 'Next',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state is PreferenceError) {
                return Center(
                  child: Text('Error loading preference'),
                );
              } else {
                return Center(child: Text('Unexpected state: $state'));
              }
            },
          )
        ],
      ),
    );
  }
}
