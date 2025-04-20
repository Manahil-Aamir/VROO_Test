import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/authentication/presentation/bloc/bloc/sign_in_bloc.dart';
import 'package:vroo_test/features/authentication/presentation/bloc/state/sign_in_state.dart';
import 'package:vroo_test/features/authentication/presentation/bloc/user_bloc.dart';
import 'package:vroo_test/shared/widgets/appbar_no_icon.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';
import 'package:vroo_test/shared/widgets/input_field.dart';

import '../../../../core/router/navigation.dart';
import '../../data/data_source/user_preference.dart';
import '../bloc/event/sign_in_event.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; 

  bool _isLoginMode = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headingTitle = _isLoginMode ? 'Sign In' : 'Forgot Password';

    return Scaffold(
      appBar: AppBarNoIcon(heading: headingTitle),
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) async {
          if (state is AuthLoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login Successful!'),
                backgroundColor: theme.secondaryHeaderColor,
                duration: Duration(seconds: 3),
              ),
            );
            context.read<Navigation>().navigateTo('/home');
            await UserPreferences.saveUser(state.user);
            context.read<UserBloc>().add(SetUserEvent(user: state.user));
          } else if (state is AuthLoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid Email or Password'),
                backgroundColor: theme.indicatorColor,
                duration: Duration(seconds: 3),
              ),
            );
          } else if (state is AuthPasswordResetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Password Reset Email Sent!'),
                backgroundColor: theme.secondaryHeaderColor,
                duration: Duration(seconds: 3),
              ),
            );
          } else if (state is AuthPasswordResetFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid Email'),
                backgroundColor: theme.indicatorColor,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                InputField(
                  labelText: 'Email',
                  controller: _emailController,
                ),
                SizedBox(height: 20.h),

                if (_isLoginMode)
                  InputField(
                    labelText: 'Password',
                    controller: _passwordController,
                    obscure: _obscurePassword,
                    // Added eye icon toggle
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).primaryColor, // Set primary color
                      ),
                    ),
                  ),

                if (_isLoginMode) SizedBox(height: 5.h),
                if (_isLoginMode)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => setState(() => _isLoginMode = false),
                      child: Text(
                        'Forgot Password?',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.primaryColor),
                      ),
                    ),
                  ),

                SizedBox(height: 14.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Does not have an account? ",
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: theme.primaryColorDark),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(
                          theme.primaryColor.withOpacity(0.1),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/sign_up'),
                      child: Text(
                        'Sign Up',
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
                  onTap: () {
                    if (_isLoginMode) {
                      context.read<SignInBloc>().add(
                        LoginEvent(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                      );
                    } else {
                      context.read<SignInBloc>().add(
                        ForgotPasswordEvent(
                          email: _emailController.text.trim(),
                        ),
                      );
                      context.read<Navigation>().navigateTo('/sign_in');
                      setState(() => _isLoginMode = true);
                    }
                  },
                  text: _isLoginMode ? 'Login' : 'Reset Password',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
