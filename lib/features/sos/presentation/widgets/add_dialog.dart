import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/shared/widgets/dialog_button.dart';
import 'package:vroo_test/shared/widgets/input_field.dart';

import '../../data/models/contact_model.dart';
import '../bloc/bloc/sos_bloc.dart';
import '../bloc/event/sos_event.dart';

class AddContactDialog extends StatelessWidget {
  final String userId;

  const AddContactDialog({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nameController = TextEditingController();
    final numberController = TextEditingController();

    return AlertDialog(
      title: Text(
        "Add Emergency Contact",
        style: theme.textTheme.displayMedium
            ?.copyWith(color: theme.primaryColorDark),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InputField(labelText: 'Name', controller: nameController),
          SizedBox(height: 10),
          InputField(
            labelText: 'Phone Number',
            controller: numberController,
            keyboardType: TextInputType.phone,
            hintText: '+923001234567',
          ),
        ],
      ),
      actions: [
        DialogButton(
          onTap: () => Navigator.pop(context),
          text: "Cancel",
          color: Colors.grey,
        ),
        DialogButton(
          onTap: () {
            final newContact = ContactModel(
              name: nameController.text,
              number: numberController.text,
            );
            context.read<SosBloc>().add(AddContact(newContact, userId));
            Navigator.pop(context);
          },
          text: "Add",
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
