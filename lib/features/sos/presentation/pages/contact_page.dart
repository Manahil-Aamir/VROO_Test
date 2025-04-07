import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/sos/presentation/widgets/add_dialog.dart';
import 'package:vroo_test/features/sos/presentation/widgets/contact_list.dart';
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

  void _showSnackbar(String message) {
    final theme = Theme.of(context);
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: theme.indicatorColor,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.w),
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
              child: BlocConsumer<SosBloc, SosState>(
                listener: (context, state) {
                  if (state is SosError) {
                    if (state.message !=
                        'Emergency contact with this phone number already exists.') {
                      _showSnackbar(state.message);
                    } // Show error message in a Snackbar
                  }
                },
                builder: (context, state) {
                  if (state is SosLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SosLoaded) {
                    return ContactList(
                        contacts: state.contacts, userId: widget.userId);
                  } else if (state is SosError) {
                    // Preserve previous contacts & show the Snackbar message
                    return ContactList(
                        contacts: state.previousContacts,
                        userId: widget.userId);
                  }
                  return const Center(child: Text("No contacts added yet."));
                },
              ),
            ),
            GradientButton(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return BlocProvider.value(
                      value: context.read<SosBloc>(), // Provide existing bloc
                      child: AddContactDialog(userId: widget.userId),
                    );
                  },
                );
              },
              text: "Add Contact",
            )
          ],
        ),
      ),
    );
  }
}
