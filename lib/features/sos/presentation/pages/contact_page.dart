import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/sos/data/models/contact_model.dart';
import 'package:vroo_test/features/sos/presentation/widgets/add_dialog.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../bloc/event/sos_event.dart';
import '../bloc/state/sos_state.dart';
import '../bloc/bloc/sos_bloc.dart';

class ContactScreen extends StatefulWidget {
  final String userId;
  const ContactScreen({super.key, required this.userId});

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  void initState() {
    super.initState();
    // Use Future.microtask so the bloc is found in the widget tree.
    Future.microtask(() {
      if (mounted) {
        context.read<SosBloc>().add(FetchContacts(widget.userId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text("Emergency Contacts",
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: ThemeColors.primaryColorDark,
                  )),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: BlocBuilder<SosBloc, SosState>(
                builder: (context, state) {
                  if (state is SosLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SosLoaded) {
                    return _buildContactList(context, state.contacts);
                  } else if (state is SosError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text("No contacts added yet."));
                },
              ),
            ),
            GradientButton(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AddContactDialog(userId: widget.userId),
                );
              },
              text: "Add Contact",
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContactList(BuildContext context, List<ContactModel> contacts) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: ThemeColors.primaryColor,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              contact.name,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(contact.number),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context
                    .read<SosBloc>()
                    .add(DeleteContact(contact.id!, widget.userId));
              },
            ),
          ),
        );
      },
    );
  }
}
