import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/core/theme/color/color_theme.dart';
import 'package:vroo_test/features/authentication/presentation/widgets/form_field_container.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';
import 'package:vroo_test/shared/widgets/overlay.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/utils/validators/auth_validators.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../data/data_source/user_preference.dart';
import '../../data/model/user_model.dart';
import '../bloc/bloc/create_user_bloc.dart';
import '../bloc/event/create_user_event.dart';
import '../bloc/state/create_user_state.dart';
import '../bloc/user_bloc.dart';
import '../widgets/gender_dropdown.dart';

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
  String? genderError;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  String _processPhoneNumber(String input) {
    String digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    if (digits.length < 10 || digits.length > 11) {
      return '';
    }
    return '+92$digits';
  }

  void _validate(BuildContext context) {
    final trimmedFirstName = firstNameController.text.trim();
    final trimmedLastName = lastNameController.text.trim();
    final processedPhone = _processPhoneNumber(phoneController.text);

    setState(() {
      firstNameError = AuthValidators.validateName(trimmedFirstName);
      lastNameError = AuthValidators.validateName(trimmedLastName);
      phoneError = processedPhone.isEmpty 
          ? 'Enter valid 10-11 digit number' 
          : AuthValidators.validateMobileNumber(processedPhone);
    });

    if (firstNameError != null || lastNameError != null || phoneError != null) {
      return;
    }

    _submitCreateUser(context, trimmedFirstName, trimmedLastName, processedPhone);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: appBar(heading: 'User Info'),
      body: BlocConsumer<CreateUserBloc, CreateUserState>(
        listener: (context, state) async {
          if (state is CreateUserSuccess) {
            final trimmedFirstName = firstNameController.text.trim();
            final trimmedLastName = lastNameController.text.trim();
            final processedPhone = _processPhoneNumber(phoneController.text);
            
            final user = UserModel(
              uid: '',
              name: '$trimmedFirstName $trimmedLastName',
              gender: selectedGender,
              phoneNumber: processedPhone,
              email: FirebaseAuth.instance.currentUser!.email!,
            );
            await UserPreferences.saveUser(user);
            context.read<UserBloc>().add(SetUserEvent(user: user));
            context.read<Navigation>().navigateTo('/home');
          } else if (state is CreateUserFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(16.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // First Name Field
                    _buildFormField(
                      theme,
                      'First Name', 
                      firstNameController, 
                      firstNameError,
                    ),
                    SizedBox(height: 20.h),
                    
                    // Last Name Field
                    _buildFormField(
                      theme,
                      'Last Name', 
                      lastNameController, 
                      lastNameError,
                    ),
                    SizedBox(height: 20.h),
                    
                    // Gender Dropdown - using the new StyledDropdown
                    GenderDropdown(
                      selectedValue: selectedGender,
                      labelText: 'Gender',
                      hintText: 'Select Gender',
                      errorText: genderError,
                      items: genderOptions,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            selectedGender = value;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    
                    // Phone Number Field
                    _buildPhoneField(theme),
                    SizedBox(height: 30.h),
                    
                    // Submit Button
                    GradientButton(
                      onTap: () => _validate(context),
                      text: 'Complete Registration',
                    ),
                  ],
                ),
              ),
              if (state is CreateUserLoading) const CustomOverlay(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPhoneField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: theme.inputDecorationTheme.labelStyle,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            // Country Code Container
            Container(
              width: 70.w,
              height: 56.h,
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 16.h,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: phoneError != null
                      ? ThemeColors.accentColor
                      : ThemeColors.primaryColorLight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '+92',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.primaryColorDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Phone Number Input Field
            Expanded(
              child: Container(
                height: 56.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: phoneError != null
                        ? ThemeColors.accentColor
                        : ThemeColors.primaryColorLight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: ThemeColors.primaryColorDark,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: InputDecoration(
                    hintText: '3XX XXXXXXX',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: ThemeColors.primaryColorLight,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (phoneError != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 12.w),
            child: Text(
              phoneError!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: ThemeColors.accentColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFormField(
    ThemeData theme,
    String label,
    TextEditingController controller,
    String? errorText,
  ) {
    return FormFieldContainer(
      labelText: label,
      errorText: errorText,
      child: TextField(
        controller: controller,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: ThemeColors.primaryColorDark,
        ),
        decoration: InputDecoration(
          hintText: 'Enter $label',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: ThemeColors.primaryColorLight,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  void _submitCreateUser(
    BuildContext context,
    String trimmedFirstName,
    String trimmedLastName,
    String processedPhone,
  ) {
    context.read<CreateUserBloc>().add(
      CreateUserSubmitted(
        user: UserModel(
          uid: '',
          name: '$trimmedFirstName $trimmedLastName',
          gender: selectedGender,
          phoneNumber: processedPhone,
          email: FirebaseAuth.instance.currentUser!.email!,
        ),
      ),
    );
  }
}
