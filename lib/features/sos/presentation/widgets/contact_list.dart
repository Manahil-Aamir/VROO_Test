import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/custom_dialog.dart';
import '../../../../shared/widgets/initials_circle_avatar.dart';
import '../../data/models/contact_model.dart';
import '../bloc/bloc/sos_bloc.dart';
import '../bloc/event/sos_event.dart';

class ContactList extends StatelessWidget {
  final List<ContactModel> contacts;

  const ContactList({
    super.key,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        print('Contact ID: ${contact.id}, Contact Name: ${contact.name}, Contact Number: ${contact.number}');
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: theme.primaryColorDark.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            leading: InitialsCircleAvatar(
              initials: contact.name[0].toUpperCase(),
              radius: 20.r, 
              showCameraIcon: false,
            ),
            title: Text(
              contact.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.scaffoldBackgroundColor,
              ),
            ),
            subtitle: Text(contact.number,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.scaffoldBackgroundColor,
                )),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: theme.indicatorColor),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (dialogContext) => CustomDialog(
                          title: 'Delete Contact',
                          message: 'Are you sure you want to delete this contact?',
                          confirmText: 'Delete',
                          cancelText: 'Cancel',
                          confirmColor: theme.indicatorColor,
                          cancelColor: theme.primaryColorDark,
                          onConfirm: () {
                            Navigator.pop(dialogContext);
                            context.read<SosBloc>().add(DeleteContact(
                                  contact.id!,
                                ));
                          },
                          onCancel: () {
                            Navigator.pop(dialogContext);
                          },
                        ));
              },
            ),
          ),
        );
      },
    );
  }
}
