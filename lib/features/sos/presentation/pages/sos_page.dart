import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:vroo_test/features/sos/presentation/widgets/sos_tab.dart';
import 'package:vroo_test/shared/widgets/appbar.dart';
import 'contact_page.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user ID (DI already provides SosBloc on navigation)
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar(heading: "Emergency SOS"),
        body: Column(
          children: [
            TabBar(
              indicatorColor: theme.primaryColor,
              labelColor: theme.primaryColor,
              unselectedLabelColor: theme.primaryColorDark,
              overlayColor:
                  WidgetStateProperty.all(theme.primaryColor.withOpacity(0.1)),
              tabs: [
                Tab(
                  icon: Icon(
                    LucideIcons.alertTriangle,
                  ),
                  child: Text(
                    "SOS",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.primaryColorDark,
                    ),
                  ),
                ),
                Tab(
                  icon: Icon(
                    LucideIcons.contact,
                  ),
                  child: Text(
                    "Contacts",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.primaryColorDark,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SosTab(uid: uid),
                  ContactScreen(userId: uid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
