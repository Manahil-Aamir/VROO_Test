import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/models/contact_model.dart';
import '../bloc/bloc/sos_bloc.dart';
import '../bloc/event/sos_event.dart';

class ContactList extends StatelessWidget {
  final List<ContactModel> contacts;
  final String userId;

  const ContactList({
    super.key,
    required this.contacts,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        print(
            'Contact ID: ${contact.id}, Contact Name: ${contact.name}, Contact Number: ${contact.number}');
        return Card(
          color: theme.scaffoldBackgroundColor,
          elevation: 2.0.h,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.primaryColor,
              child: Icon(Icons.person, color: theme.scaffoldBackgroundColor),
            ),
            title: Text(
              contact.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.primaryColorDark,
              ),
            ),
            subtitle: Text(contact.number,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.primaryColorDark,
                )),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: theme.indicatorColor),
              onPressed: () {
                context.read<SosBloc>().add(DeleteContact(
                      userId,
                      contact.id!,
                    ));
              },
            ),
          ),
        );
      },
    );
  }
}
