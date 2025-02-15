import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/appbar_no_icon.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp(BuildContext context) {
    final theme = Theme.of(context);
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Email, password, and confirm password cannot be empty."),
          backgroundColor: theme.indicatorColor,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Passwords do not match."),
          backgroundColor: theme.indicatorColor,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    context.read<SignUpBloc>().add(SignUpSubmitted(
          _emailController.text,
          _passwordController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarNoIcon(heading: 'Sign Up'),
      body: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            print('success');
            context.read<Navigation>().navigateTo('/email-verification');
          } else if (state is SignUpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InputField(
                  controller: _emailController,
                  labelText: 'Email',
                ),
                SizedBox(height: 20.h),
                InputField(
                  labelText: 'Password',
                  controller: _passwordController,
                  obscure: true,
                ),
                SizedBox(height: 20.h),
                InputField(
                  labelText: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscure: true,
                ),
                SizedBox(height: 20.h),
                GradientButton(
                  onTap:
                      state is SignUpLoading ? () {} : () => _signUp(context),
                  text: 'Sign Up',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
