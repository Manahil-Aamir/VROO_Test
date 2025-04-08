import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/shared/widgets/dialog_button.dart';
import 'package:vroo_test/shared/widgets/input_field.dart';

import '../../../../core/utils/validators/auth_validators.dart';
import '../../data/models/contact_model.dart';
import '../bloc/bloc/sos_bloc.dart';
import '../bloc/event/sos_event.dart';
import '../bloc/state/sos_state.dart';

class AddContactDialog extends StatefulWidget {
  const AddContactDialog({super.key});

  @override
  _AddContactDialogState createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  String? nameError;
  String? numberError;

  void _validateAndAddContact() {
    setState(() {
      nameError = AuthValidators.validateName(nameController.text);
      numberError = AuthValidators.validateMobileNumber(numberController.text);
    });

    if (nameError == null && numberError == null) {
      final newContact = ContactModel(
        name: nameController.text,
        number: numberController.text,
      );
      context.read<SosBloc>().add(AddContact(newContact));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<SosBloc, SosState>(
      listener: (context, state) {
        if (state is SosError) {
          if (state.message ==
              'Emergency contact with this phone number already exists.') {
            setState(() {
              numberError = 'Number already exists';
            });
          }
          if (state.message == 'A user can have up to 5 emergency contacts.') {
            Navigator.pop(context);
          }
        } else if (state is SosLoaded) {
          Navigator.pop(context); // Close the dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Contact added successfully!"),
              backgroundColor: theme.secondaryHeaderColor,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: AlertDialog(
        title: Text(
          "Add Emergency Contact",
          style: theme.textTheme.displayMedium?.copyWith(
            color: theme.primaryColorDark,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(
              labelText: 'Name',
              controller: nameController,
              errorText: nameError,
            ),
            const SizedBox(height: 10),
            InputField(
              labelText: 'Phone Number',
              controller: numberController,
              keyboardType: TextInputType.phone,
              hintText: '+923001234567',
              errorText: numberError,
            ),
          ],
        ),
        actions: [
          DialogButton(
            onTap: () => Navigator.pop(context),
            text: "Cancel",
            color: theme.primaryColorLight,
          ),
          DialogButton(
            onTap: _validateAndAddContact,
            text: "Add",
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
