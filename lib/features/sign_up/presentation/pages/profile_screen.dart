import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/sign_up/domain/entity/user_entity.dart';
import 'package:vroo_test/features/sign_up/presentation/widgets/gender_dropdown.dart';
import 'package:vroo_test/shared/widgets/appbar_no_icon.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';
import 'package:vroo_test/shared/widgets/input_field.dart';
import '../../../../core/router/navigation.dart';
import '../bloc/bloc/create_user_bloc.dart';
import '../bloc/bloc/phone_verification_bloc.dart';
import '../bloc/event/create_user_event.dart';
import '../bloc/event/phone_verification_event.dart';
import '../bloc/state/create_user_state.dart';
import '../bloc/state/phone_verification_state.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  // Removed genderController since we're using a dropdown for gender.
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBarNoIcon(heading: 'User Info'),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PhoneVerificationBloc, PhoneVerificationState>(
            listener: (context, state) {
              if (state is PhoneVerificationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
          ),
          BlocListener<CreateUserBloc, CreateUserState>(
            listener: (context, state) {
              if (state is CreateUserSuccess) {
                context.read<Navigation>().navigateTo('/riderhome');
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InputField(
                labelText: 'First Name',
                controller: firstNameController,
              ),
              SizedBox(height: 20.h),
              InputField(
                labelText: 'Last Name',
                controller: lastNameController,
              ),
              SizedBox(height: 20.h),
              GenderDropdown(
                items: ['Male', 'Female', 'Other'],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
                selectedValue: selectedGender,
                labelText: 'Gender',
                errorText: null,
                hintText: 'Select Gender',
              ),
              SizedBox(height: 20.h),
              InputField(
                labelText: 'Phone Number',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                hintText: '+923001234567',
              ),
              BlocBuilder<PhoneVerificationBloc, PhoneVerificationState>(
                builder: (context, state) {
                  if (state is PhoneVerificationCodeSent) {
                    return Column(
                      children: [
                        TextField(
                          controller: otpController,
                          decoration: InputDecoration(labelText: 'OTP'),
                        ),
                        ElevatedButton(
                          onPressed: () => context
                              .read<PhoneVerificationBloc>()
                              .add(VerifyOtpEvent(
                                  state.verificationId, otpController.text)),
                          child: const Text('Verify OTP'),
                        ),
                      ],
                    );
                  }
                  return ElevatedButton(
                    onPressed: () => context
                        .read<PhoneVerificationBloc>()
                        .add(SendOtpEvent(phoneController.text)),
                    child: const Text('Send OTP'),
                  );
                },
              ),
              BlocBuilder<PhoneVerificationBloc, PhoneVerificationState>(
                builder: (context, state) {
                  return GradientButton(
                    onTap: state is PhoneVerificationSuccess
                        ? () => _submitCreateUser(context)
                        : () {},
                    text: 'Complete Registration',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitCreateUser(BuildContext context) {
    final createUser = UserEntity(
      email: '', // email,
      first_name: firstNameController.text,
      last_name: lastNameController.text,
      gender: selectedGender,
      phoneNumber: phoneController.text,
    );
    context.read<CreateUserBloc>().add(CreateUserSubmitted(createUser));
  }
}
