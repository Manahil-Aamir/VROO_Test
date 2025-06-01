import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/authentication/presentation/widgets/verify_button.dart';

import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/appbar_no_icon.dart';
import '../bloc/bloc/email_verification_bloc.dart';
import '../bloc/event/email_verification_event.dart';
import '../bloc/state/email_verification_state.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with WidgetsBindingObserver {
  Timer? _verificationTimer;
  bool _isVerified = false;
  bool _userDeletedOrNavigated = false; // Prevent multiple delete calls
  EmailVerificationBloc? _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = context.read<EmailVerificationBloc>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc ??= context.read<EmailVerificationBloc>();
  }

  void _startVerificationCheck(BuildContext context) {
    _verificationTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (mounted && _bloc != null && !_userDeletedOrNavigated) {
          _bloc!.add(EmailVerificationCheckRequested());
        } else {
          timer.cancel();
        }
      },
    );
  }

  void _deleteUserIfNeeded() {
    if (!_isVerified && !_userDeletedOrNavigated && _bloc != null) {
      _userDeletedOrNavigated = true;
      _bloc!.add(EmailVerificationDeleteUserRequested());
      print('User deletion requested due to app closure/navigation');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('App lifecycle state changed: $state');

    switch (state) {
      case AppLifecycleState.detached:
        // App is completely closed/terminated
        print('App detached - deleting unverified user');
        _deleteUserIfNeeded();
        break;
      case AppLifecycleState.paused:
        // App is in background - don't delete, user might come back
        print('App paused - not deleting user');
        break;
      case AppLifecycleState.inactive:
        // App is inactive (e.g., phone call, system dialog)
        // Don't delete here as it might be temporary
        break;
      case AppLifecycleState.resumed:
        // App came back to foreground
        print('App resumed');
        break;
      case AppLifecycleState.hidden:
        // App is hidden but still running - don't delete
        print('App hidden - not deleting user');
        break;
    }
  }

  Future<bool> _onWillPop() async {
    print('User attempting to go back');

    if (!_isVerified && !_userDeletedOrNavigated) {
      _deleteUserIfNeeded();
      return true; // Allow navigation
    }

    return true; // Allow navigation if already verified or deleted
  }

  @override
  void dispose() {
    print('EmailVerificationScreen disposing');

    // Final check - if disposing and not verified, delete user
    if (!_isVerified && !_userDeletedOrNavigated) {
      _deleteUserIfNeeded();
    }

    WidgetsBinding.instance.removeObserver(this);
    _verificationTimer?.cancel();
    _bloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Start the timer only once, after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if ((_verificationTimer == null || !_verificationTimer!.isActive) &&
          mounted &&
          !_userDeletedOrNavigated) {
        _startVerificationCheck(context);
      }
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBarNoIcon(heading: 'Email Verification'),
        body: BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
          listener: (context, state) {
            if (state is EmailVerificationSuccess) {
              _isVerified = true;
              _verificationTimer?.cancel();
              print('Email verified successfully');
              if (mounted) {
                context.read<Navigation>().navigateTo('/create_user');
              }
            } else if (state is EmailVerificationFailure) {
              if (!state.error.toLowerCase().contains('not verified') &&
                  mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: theme.indicatorColor,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            } else if (state is EmailVerificationResent) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Verification email resent!'),
                    backgroundColor: theme.secondaryHeaderColor,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            } else if (state is EmailVerificationUserDeleted) {
              print('User deleted successfully');
              if (mounted) {
                // Navigate back to the first screen
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Card(
                    color: theme.scaffoldBackgroundColor,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24.r),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.mark_email_unread,
                              size: 64.r, color: theme.primaryColor),
                          SizedBox(height: 24.h),
                          Text(
                            'Verify Your Email',
                            style: theme.textTheme.displayMedium?.copyWith(
                              color: theme.primaryColorDark,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              "We've sent a verification link to your email address. "
                              "Please check your inbox and follow the instructions. "
                              "We'll automatically check if you've verified your email.",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.primaryColorDark.withOpacity(0.8),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                  color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning_amber,
                                    color: Colors.red, size: 20.r),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    'Warning: Your account will be permanently deleted if you go back or close the app without verifying your email',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 32.h),
                          if (state is EmailVerificationLoading)
                            Column(
                              children: [
                                CircularProgressIndicator(
                                  color: theme.primaryColor,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'Checking verification...',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color:
                                        theme.primaryColorDark.withOpacity(0.7),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                              ],
                            ),
                          SizedBox(height: 18.h),
                          Text(
                            'Didn\'t receive the email?',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.primaryColorDark,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          ResendButton(
                            onTap: () {
                              if (mounted &&
                                  _bloc != null &&
                                  !_userDeletedOrNavigated) {
                                _bloc!.add(EmailVerificationResendRequested());
                              }
                            },
                            text: 'Resend Verify Email',
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
