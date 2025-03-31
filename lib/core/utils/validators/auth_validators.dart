class AuthValidators {
  static final RegExp _emailRegExp = RegExp(
    // r'^[a-zA-Z0-9._%+-]+@(khi\.iba\.edu\.pk|iba\.edu\.pk)$',
    r'^[a-zA-Z0-9._%+-]+@(khi\.iba\.edu\.pk|iba\.edu\.pk|gmail\.com)$',
  );

  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d{2,})(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$',
  );

  static final RegExp _nameRegExp = RegExp(
    r'^[a-zA-Z]+$',
  );

  static final RegExp _mobileNumberRegExp = RegExp(
    r'^\+92\d{10}$',
  );

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty';
    } else if (!_emailRegExp.hasMatch(email)) {
      return 'Invalid email format. Please use a valid IBA email address.';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    } else if (!_passwordRegExp.hasMatch(password)) {
      return 'Password must be at least 8 characters long, include at least two digits, one special character, and one letter';
    }
    return null;
  }

  static String? validatePasswordsMatch(
      String password, String confirmPassword) {
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateName(String name) {
    if (name.isEmpty) {
      return 'Name cannot be empty';
    } else if (!_nameRegExp.hasMatch(name)) {
      return 'Name can only contain letters';
    }
    return null;
  }

  static String? validateMobileNumber(String mobileNumber) {
    if (mobileNumber.isEmpty) {
      return 'Mobile number cannot be empty';
    } else if (!_mobileNumberRegExp.hasMatch(mobileNumber)) {
      return 'Invalid mobile number format';
    }
    return null;
  }
}
