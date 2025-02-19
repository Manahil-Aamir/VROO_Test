import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/features/sign_up/presentation/widgets/gender_dropdown.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';
import 'package:vroo_test/shared/widgets/input_field.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/utils/validators/auth_validators.dart';
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

  void _validate(BuildContext context) {
    final theme = Theme.of(context);
    final firstNameError =
        AuthValidators.validateName(firstNameController.text);
    final lastNameError = AuthValidators.validateName(lastNameController.text);
    final mobileError =
        AuthValidators.validateMobileNumber(phoneController.text);

    String? errorMessage;
    if (firstNameError != null) {
      errorMessage = firstNameError;
    } else if (lastNameError != null) {
      errorMessage = lastNameError;
    } else
      errorMessage = mobileError;

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: theme.indicatorColor,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    _submitCreateUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Info')),
      body: BlocListener<CreateUserBloc, CreateUserState>(
        listener: (context, state) {
          if (state is CreateUserSuccess) {
            context.read<Navigation>().navigateTo('/riderhome');
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
              ),
              const SizedBox(height: 20),
              InputField(
                labelText: 'Last Name',
                controller: lastNameController,
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
      id: FirebaseAuth.instance.currentUser!.uid,
      name: '${firstNameController.text} ${lastNameController.text}',
      gender: selectedGender,
      phoneNumber: phoneController.text,
    );
    print(createUser.toJson());

    context.read<CreateUserBloc>().add(CreateUserSubmitted(user: createUser));
  }
}
