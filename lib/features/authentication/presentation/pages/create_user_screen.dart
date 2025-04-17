import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/features/authentication/presentation/widgets/gender_dropdown.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';
import 'package:vroo_test/shared/widgets/input_field.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/utils/validators/auth_validators.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../data/model/user_model.dart';
import '../bloc/bloc/create_user_bloc.dart';
import '../bloc/event/create_user_event.dart';
import '../bloc/state/create_user_state.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String selectedGender = 'Male';

  String? firstNameError;
  String? lastNameError;
  String? phoneError;

  void _validate(BuildContext context) {
    final firstNameErr = AuthValidators.validateName(firstNameController.text);
    final lastNameErr = AuthValidators.validateName(lastNameController.text);
    final phoneErr = AuthValidators.validateMobileNumber(phoneController.text);

    setState(() {
      firstNameError = firstNameErr;
      lastNameError = lastNameErr;
      phoneError = phoneErr;
    });

    if (firstNameErr != null || lastNameErr != null || phoneErr != null) {
      return; // Do not proceed if there are errors
    }

    _submitCreateUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        heading: 'User Info',
      ),
      body: BlocListener<CreateUserBloc, CreateUserState>(
        listener: (context, state) {
          if (state is CreateUserSuccess) {
            context.read<Navigation>().navigateTo('/home');
          } else if (state is CreateUserFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InputField(
                labelText: 'First Name',
                controller: firstNameController,
                errorText: firstNameError,
              ),
              const SizedBox(height: 20),
              InputField(
                labelText: 'Last Name',
                controller: lastNameController,
                errorText: lastNameError,
              ),
              const SizedBox(height: 20),
              GenderDropdown(
                items: ['Male', 'Female', 'Other'],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
                selectedValue: selectedGender,
                labelText: 'Gender',
                hintText: 'Select Gender',
                errorText: null,
              ),
              const SizedBox(height: 20),
              InputField(
                labelText: 'Phone Number',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                hintText: '+923001234567',
                errorText: phoneError,
              ),
              const SizedBox(height: 30),
              GradientButton(
                onTap: () => _validate(context),
                text: 'Complete Registration',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitCreateUser(BuildContext context) {
    final createUser = UserModel(
      name: '${firstNameController.text} ${lastNameController.text}',
      gender: selectedGender,
      phoneNumber: phoneController.text,
      email: FirebaseAuth.instance.currentUser!.email!,
    );
    print(createUser.toJson());

    context.read<CreateUserBloc>().add(CreateUserSubmitted(user: createUser));
  }
}
