import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/sos/presentation/widgets/add_dialog.dart';
import 'package:vroo_test/features/sos/presentation/widgets/contact_list.dart';
import 'package:vroo_test/shared/widgets/Appbar.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';
import '../bloc/event/sos_event.dart';
import '../bloc/state/sos_state.dart';
import '../bloc/bloc/sos_bloc.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

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
        context.read<SosBloc>().add(FetchContacts());
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
    return Scaffold(
      appBar: appBar(heading: 'Emergency Contacts'),
      body: Padding(
        padding: EdgeInsets.all(30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    return ContactList(contacts: state.contacts);
                  } else if (state is SosError) {
                    // Preserve previous contacts & show the Snackbar message
                    if (state.previousContacts.isNotEmpty) {
                      _showSnackbar(state.message);
                      return ContactList(contacts: state.previousContacts);
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/error.png',
                              width: 300.w,
                              height: 300.h,
                              fit: BoxFit.contain,
                            ),
                            // SizedBox(height: 16.h),
                            // Text(
                            //   state.message,
                            //   style: TextStyle(
                            //     color: Theme.of(context).indicatorColor,
                            //     fontSize: 16.sp,
                            //   ),
                            //   textAlign: TextAlign.center,
                            // ),
                          ],
                        ),
                      );
                    }
                    // return ContactList(
                    //   contacts: state.previousContacts,
                    // );
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
                      child: AddContactDialog(),
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
