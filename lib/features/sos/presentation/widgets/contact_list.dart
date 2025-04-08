import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vroo_test/shared/widgets/custom_dialog.dart';

import '../../../../core/theme/color/color_theme.dart';
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
        final initials = contact.name.isNotEmpty 
            ? contact.name.split(' ').map((e) => e[0]).take(2).join() 
            : '?';
        
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: theme.primaryColorDark.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            leading: CircleAvatar(
              radius: 24.r,
              backgroundColor: theme.primaryColor,
              child: Text(
                initials,
                style: TextStyle(
                  color: theme.scaffoldBackgroundColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              contact.name,
              style: TextStyle(
                color: ThemeColors.buttonTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                contact.number,
                style: TextStyle(
                  color: ThemeColors.buttonTextColor,
                  fontSize: 12.sp,
                ),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, 
                  color: ThemeColors.buttonTextColor, 
                  size: 20.r),
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
                      context.read<SosBloc>().add(DeleteContact(contact.id!));
                    },
                    onCancel: () {
                      Navigator.pop(dialogContext);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
