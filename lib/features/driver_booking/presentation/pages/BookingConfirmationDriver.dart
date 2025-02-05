import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';

import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/zigzag.dart';

class BookingConfirmationDriverScreen extends StatelessWidget {
  const BookingConfirmationDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ZigZagIconWidget(),
            SizedBox(height: 20.h),
            Text(
              "Booking Confirmed",
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.primaryColorDark,
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GradientButton(
                onTap: () {
                  context.read<Navigation>().navigateTo('/driver_home');
                },
                text: "Go to Home",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
