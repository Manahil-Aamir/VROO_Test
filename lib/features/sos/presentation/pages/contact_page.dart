import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../bloc/bloc/sos_bloc.dart';
import '../bloc/event/sos_event.dart';
import '../bloc/state/sos_state.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Emergency Contacts",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: ThemeColors.headlinesTextColor,
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: BlocBuilder<SosBloc, SosState>(
                builder: (context, state) {
                  if (state is SosLoaded) {
                    return ListView.builder(
                      itemCount: state.contacts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: ThemeColors.primaryColor,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(
                              state.contacts[index].name,
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(state.contacts[index].number),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                final updatedContacts = List.of(state.contacts)
                                  ..removeAt(index);
                                context
                                    .read<SosBloc>()
                                    .add(SaveContacts(updatedContacts));
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Center(child: Text("No contacts added yet."));
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => context.read<SosBloc>().add(PickContact()),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Center(
                child: Text(
                  "Add Contact",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
