import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vroo_test/features/matching/data/models/matching_rides_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/schedule_model.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';
import 'package:vroo_test/shared/widgets/zigzag.dart';

import '../../../../core/router/navigation.dart';
import '../bloc/bloc/booking_confirmation_bloc.dart';
import '../bloc/state/booking_confirmation_state.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final String rideRequestId;
  final List<MatchingRideModel> matchingRides;
  final TimeOfDay minPickupTime;
  final TimeOfDay maxPickupTime;
  final ScheduleModel schedule;

  const BookingConfirmationScreen({
    super.key,
    required this.rideRequestId,
    required this.matchingRides,
    required this.minPickupTime,
    required this.maxPickupTime,
    required this.schedule,
  });

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _textController;
  late AnimationController _buttonController;
  late AnimationController _pulseController;
  
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _buttonFadeAnimation;
  late Animation<Offset> _buttonSlideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Icon animations
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _iconScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    ));
    
    _iconRotationAnimation = Tween<double>(
      begin: -0.2,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeOutBack,
    ));

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));
    
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Button animations
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _buttonFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOut,
    ));
    
    _buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOutCubic,
    ));

    // Continuous pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _iconController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _textController.forward();
    
    await Future.delayed(const Duration(milliseconds: 200));
    _buttonController.forward();
    
    // Start continuous pulse animation
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<BookingConfirmationBloc, BookingConfirmationState>(
      listener: (context, state) {
        if (state is BookingConfirmationSuccess) {
          context.read<Navigation>().navigateTo(
            '/matching_rides',
            arguments: {
              'rideRequestId': widget.rideRequestId,
              'matchingRides': widget.matchingRides,
              'minPickupTime': widget.minPickupTime,
              'maxPickupTime': widget.maxPickupTime,
              'schedule': widget.schedule,
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                // Top spacer to center content vertically
                const Spacer(flex: 1),
                
                // Animated Icon with pulse effect
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: AnimatedBuilder(
                        animation: _iconController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _iconScaleAnimation.value,
                            child: Transform.rotate(
                              angle: _iconRotationAnimation.value,
                              child: Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade400.withOpacity(0.1),
                                      Colors.green.shade200.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.1),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const ZigZagIconWidget(),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                
                SizedBox(height: 45.h),
                
                // Animated Headline Text
                SlideTransition(
                  position: _textSlideAnimation,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Text(
                      "Request Created Successfully!",
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: theme.primaryColorDark,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                
                SizedBox(height: 20.h),
                
                // Animated Description Text with green highlight
                SlideTransition(
                  position: _textSlideAnimation,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.hintColor,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(text: "You've helped "),
                          TextSpan(
                            text: "reduce traffic and emissions",
                            style: TextStyle(
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          const TextSpan(text: " — great work!"),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Environmental impact indicators
                SizedBox(height: 40.h),
                SlideTransition(
                  position: _textSlideAnimation,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildImpactIndicator(
                          icon: Icons.nature,
                          label: "Eco-Friendly",
                          color: Colors.green.shade500,
                        ),
                        _buildImpactIndicator(
                          icon: Icons.traffic,
                          label: "Less Traffic",
                          color: Colors.orange.shade500,
                        ),
                        _buildImpactIndicator(
                          icon: Icons.people,
                          label: "Community",
                          color: Colors.blue.shade500,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Bottom spacer to push button to bottom
                const Spacer(flex: 1),
                
                // Animated Button
                SlideTransition(
                  position: _buttonSlideAnimation,
                  child: FadeTransition(
                    opacity: _buttonFadeAnimation,
                    child: GradientButton(
                      text: 'See Matching Riders',
                      onTap: () => _navigateToMatchingRides(context),
                    ),
                  ),
                ),
                
                SizedBox(height: 90.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImpactIndicator({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20.w,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _navigateToMatchingRides(BuildContext context) {
    context.read<Navigation>().navigateTo(
      '/matching_rides',
      arguments: {
        'rideRequestId': widget.rideRequestId,
        'matchingRides': widget.matchingRides,
        'minPickupTime': widget.minPickupTime,
        'maxPickupTime': widget.maxPickupTime,
        'schedule': widget.schedule,
      },
    );
  }
}
