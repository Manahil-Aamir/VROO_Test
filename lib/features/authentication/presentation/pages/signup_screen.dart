import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/core/utils/validators/auth_validators.dart';
import 'package:vroo_test/shared/widgets/appbar_no_icon.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';
import 'package:vroo_test/shared/widgets/overlay.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/input_field.dart';
import '../bloc/bloc/auth_bloc.dart';
import '../bloc/event/auth_event.dart';
import '../bloc/state/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscurePassword2 = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  void _signUp(BuildContext context) {
    print('Signing up...');
    setState(() {
      _emailError = AuthValidators.validateEmail(_emailController.text);
      _passwordError =
          AuthValidators.validatePassword(_passwordController.text);
      _confirmPasswordError = AuthValidators.validatePasswordsMatch(
        _passwordController.text,
        _confirmPasswordController.text,
      );
    });

    if (_emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null) {
      context.read<SignUpBloc>().add(SignUpSubmitted(
            _emailController.text,
            _passwordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBarNoIcon(heading: 'Sign Up'),
      body: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            print('success');
            context.read<Navigation>().navigateTo('/email-verification');
          } else if (state is SignUpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: theme.indicatorColor,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InputField(
                        controller: _emailController,
                        errorText: _emailError,
                        labelText: 'Email',
                      ),
                      SizedBox(height: 20.h),
                      InputField(
                        labelText: 'Password',
                        controller: _passwordController,
                        errorText: _passwordError,
                        obscure: _obscurePassword,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context)
                                .primaryColor, // Set primary color
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InputField(
                        labelText: 'Confirm Password',
                        controller: _confirmPasswordController,
                        errorText: _confirmPasswordError,
                        obscure: _obscurePassword2,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                              () => _obscurePassword2 = !_obscurePassword2),
                          child: Icon(
                            _obscurePassword2
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context)
                                .primaryColor, // Set primary color
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(color: theme.primaryColorDark),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/sign_in');
                            },
                            style: ButtonStyle(
                              overlayColor: WidgetStateProperty.all(
                                theme.primaryColor.withOpacity(0.1),
                              ),
                            ),
                            child: Text(
                              'Sign In',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.primaryColorDark,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: theme.primaryColor,
                                  decorationThickness: 2.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      GradientButton(
                        onTap: state is SignUpLoading
                            ? () {}
                            : () => _signUp(context),
                        text: 'Sign Up',
                      ),
                    ],
                  ),
                ),
              ),
              // Loading overlay
              if (state is SignUpLoading) const CustomOverlay(),
            ],
          );
        },
      ),
    );
  }
}
