// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:vroo_test/features/rider_journey/data/model/preferences_model.dart';
// import 'package:vroo_test/features/rider_journey/data/model/source_and_dest_model.dart';
// import '../../../../core/router/navigation.dart';
// import '../../../../shared/widgets/custom_app_bar.dart';
// import '../../../../shared/widgets/gradient_button.dart';
// import '../../data/model/schedule_model.dart';
// import '../bloc/bloc/r2_bloc.dart';
// import '../bloc/event/r2_event.dart';
// import '../bloc/state/r2_state.dart';
// import '../widgets/preference_switch.dart';

// class R2Page extends StatefulWidget {
//   final ScheduleModel schedule;
//   final SourceAndDestModel location;

//   const R2Page({
//     super.key,
//     required this.schedule,
//     required this.location,
//   });

//   void init() {
//     print('r2');
//     print(location.fromDescription);
//   }

//   @override
//   _R2PageState createState() => _R2PageState();
// }

// class _R2PageState extends State<R2Page> {
//   bool? selectedSameGender;
//   bool? selectedWalk;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           BlocBuilder<R2Bloc, R2State>(
//             builder: (context, state) {
//               print('val${widget.location.fromDescription}');
//               if (state is PreferenceSaved) {
//                 context.read<R2Bloc>().add(ResetStateEvent());
//                 return Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       theme.primaryColor,
//                     ),
//                   ),
//                 );
//               }
//               if (state is PreferenceInitial) {
//                 context.read<R2Bloc>().add(LoadPreferenceEvent());
//               }
//               if (state is PreferenceLoading) {
//                 return Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       theme.primaryColor,
//                     ),
//                   ),
//                 );
//               } else if (state is PreferenceLoaded) {
//                 final preference = state.loadedPreference;
//                 context.read<R2Bloc>().add(UpdatePreferenceEvent(
//                       sameGender: preference.sameGender,
//                       walk: preference.walk,
//                     ));
//                 return Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       theme.primaryColor,
//                     ),
//                   ),
//                 );
//               } else if (state is PreferenceInputState) {
//                 return Scaffold(
//                   backgroundColor: Colors.white,
//                   appBar: CustomAppBar(
//                     highlightedCircles: 2,
//                   ),
//                   body: Column(
//                     children: [
//                       Expanded(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 40.w),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               // Clean title
//                               Text(
//                                 "Ride Preference",
//                                 style: TextStyle(
//                                   fontSize: 32.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: theme.primaryColorDark,
//                                   letterSpacing: -0.5,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
                              
//                               SizedBox(height: 12.h),
                              
//                               Text(
//                                 "Choose your comfort setting",
//                                 style: TextStyle(
//                                   fontSize: 16.sp,
//                                   color: theme.primaryColorDark.withOpacity(0.6),
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
                              
//                               SizedBox(height: 80.h),
                              
//                               // Minimalist preference card
//                               GestureDetector(
//                                 onTap: () {
//                                   context
//                                       .read<R2Bloc>()
//                                       .add(TogglePreferenceEvent('sameGender'));
//                                 },
//                                 child: AnimatedContainer(
//                                   duration: Duration(milliseconds: 200),
//                                   width: double.infinity,
//                                   padding: EdgeInsets.all(40.w),
//                                   decoration: BoxDecoration(
//                                     color: state.sameGender == true 
//                                       ? theme.primaryColor 
//                                       : Colors.white,
//                                     borderRadius: BorderRadius.circular(20.r),
//                                     border: Border.all(
//                                       color: theme.primaryColor,
//                                       width: 2,
//                                     ),
//                                   ),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       // Icon
//                                       Icon(
//                                         Icons.people,
//                                         size: 48.sp,
//                                         color: state.sameGender == true 
//                                           ? Colors.white 
//                                           : theme.primaryColor,
//                                       ),
                                      
//                                       SizedBox(height: 20.h),
                                      
//                                       // Title
//                                       Text(
//                                         "Same Gender Only",
//                                         style: TextStyle(
//                                           fontSize: 20.sp,
//                                           fontWeight: FontWeight.w600,
//                                           color: state.sameGender == true 
//                                             ? Colors.white 
//                                             : theme.primaryColorDark,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
                                      
//                                       SizedBox(height: 8.h),
                                      
//                                       // Description
//                                       Text(
//                                         "Travel with riders of the same gender",
//                                         style: TextStyle(
//                                           fontSize: 14.sp,
//                                           color: state.sameGender == true 
//                                             ? Colors.white.withOpacity(0.9) 
//                                             : theme.primaryColorDark.withOpacity(0.6),
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
                              
//                               SizedBox(height: 24.h),
                              
//                               // Status text
//                               Text(
//                                 state.sameGender == true ? "Selected" : "Tap to select",
//                                 style: TextStyle(
//                                   fontSize: 14.sp,
//                                   color: state.sameGender == true 
//                                     ? theme.primaryColor 
//                                     : theme.primaryColorDark.withOpacity(0.5),
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
                      
//                       // Bottom button
//                       Padding(
//                         padding: EdgeInsets.all(40.w),
//                         child: GradientButton(
//                           onTap: () {
//                             print(state.sameGender);
//                             print(state.walk);
//                             final preference = PreferencesModel(
//                               sameGender: state.sameGender ?? false,
//                               walk: false, // Walk remains false as per requirement
//                             );
//                             context
//                                 .read<R2Bloc>()
//                                 .add(SavePreferenceEvent(preference));
//                             print('description');
//                             print(preference.walk);
//                             context
//                                 .read<Navigation>()
//                                 .navigateTo('/r3_page', arguments: {
//                               'schedule': widget.schedule,
//                               'preferences': preference,
//                               'location': widget.location,
//                             });
//                           },
//                           text: 'Continue',
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               } else if (state is PreferenceError) {
//                 return Center(
//                   child: Text(
//                     'Error loading preference',
//                     style: TextStyle(color: theme.primaryColorDark),
//                   ),
//                 );
//               } else {
//                 return Center(
//                   child: Text(
//                     'Unexpected state: $state',
//                     style: TextStyle(color: theme.primaryColorDark),
//                   ),
//                 );
//               }
//             },
//           )
//         ],
//       ),
//     );
//   }
// }


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
      backgroundColor: Colors.white,
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
                      theme.primaryColor,
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
                      theme.primaryColor,
                    ),
                  ),
                );
              } else if (state is PreferenceLoaded) {
                final preference = state.loadedPreference;
                context.read<R2Bloc>().add(UpdatePreferenceEvent(
                      sameGender: preference.sameGender,
                      walk: preference.walk,
                    ));
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.primaryColor,
                    ),
                  ),
                );
              } else if (state is PreferenceInputState) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: CustomAppBar(
                    highlightedCircles: 2,
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Top icon with circular background
                              Container(
                                width: 120.w,
                                height: 120.w,
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  margin: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 32.sp,
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: 40.h),
                              
                              // Main title
                              Text(
                                "Travel Preference",
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w700,
                                  color: theme.primaryColorDark,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              SizedBox(height: 16.h),
                              
                              // Single description
                              Text(
                                "Would you prefer to travel only with passengers of the same gender?",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: theme.primaryColorDark.withOpacity(0.6),
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              SizedBox(height: 60.h),
                              
                              // Yes/No toggle
                              Container(
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                child: Stack(
                                  children: [
                                    // Background options
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: state.sameGender == false 
                                                  ? theme.primaryColor 
                                                  : theme.primaryColorDark.withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: state.sameGender == true 
                                                  ? theme.primaryColor 
                                                  : theme.primaryColorDark.withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    // Sliding indicator
                                    AnimatedAlign(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      alignment: state.sameGender == true 
                                        ? Alignment.centerRight 
                                        : Alignment.centerLeft,
                                      child: Container(
                                        width: 160.w, // Half of the container width minus padding
                                        margin: EdgeInsets.all(4.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(21.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            state.sameGender == true ? "Yes" : "No",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    // Invisible tap targets
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (state.sameGender != false) {
                                                context
                                                    .read<R2Bloc>()
                                                    .add(TogglePreferenceEvent('sameGender'));
                                              }
                                            },
                                            behavior: HitTestBehavior.translucent,
                                            child: Container(),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (state.sameGender != true) {
                                                context
                                                    .read<R2Bloc>()
                                                    .add(TogglePreferenceEvent('sameGender'));
                                              }
                                            },
                                            behavior: HitTestBehavior.translucent,
                                            child: Container(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ), 
                              SizedBox(height: 40.h),
                              
                              // Bottom text
                              Text(
                                state.sameGender == true 
                                  ? "You'll be matched with same gender travelers"
                                  : "You'll be matched with all travelers",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: theme.primaryColorDark.withOpacity(0.5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Bottom button
                      // Replace the ElevatedButton with GradientButton in the bottom button section
                      Padding(
                        padding: EdgeInsets.fromLTRB(32.w, 32.w, 32.w, 50.w),
                        child: GradientButton(
                          onTap: () {
                            print(state.sameGender);
                            print(state.walk);
                            final preference = PreferencesModel(
                              sameGender: state.sameGender ?? false,
                              walk: false, // Walk remains false as per requirement
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
                      ),
                                          
                    ],
                  ),
                );
              } else if (state is PreferenceError) {
                return Center(
                  child: Text(
                    'Error loading preference',
                    style: TextStyle(color: theme.primaryColorDark),
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    'Unexpected state: $state',
                    style: TextStyle(color: theme.primaryColorDark),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
