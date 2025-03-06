import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/sos/presentation/bloc/bloc/sos_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/color/color_theme.dart';
import '../bloc/event/sos_event.dart';
import 'contact_page.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Emergency SOS",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: ThemeColors.headlinesTextColor,
            ),
          ),
          bottom: TabBar(
            indicatorColor: ThemeColors.primaryColor,
            tabs: [
              Tab(icon: Icon(LucideIcons.alertTriangle), text: "SOS"),
              Tab(icon: Icon(LucideIcons.contact), text: "Contacts"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSosTab(context),
            ContactScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildSosTab(BuildContext context) {
    return Center(
      child: InkResponse(
        onTap: () => context.read<SosBloc>().add(SendSos()),
        borderRadius: BorderRadius.circular(90),
        splashColor: Colors.red.withOpacity(0.3),
        highlightColor: Colors.red.withOpacity(0.2), // Press effect
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 180.w,
          height: 180.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.redAccent, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 5,
              )
            ],
          ),
          child: Center(
            child: Text(
              "SOS",
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
