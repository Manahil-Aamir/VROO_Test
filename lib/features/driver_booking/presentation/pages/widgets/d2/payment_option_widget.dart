import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/color/color_theme.dart';
import '../../../../../../core/theme/font/font_theme.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String selectedPaymentMethod;
  final ValueChanged<String> onPaymentSelected;

  const PaymentMethodWidget(
      {super.key,
      required this.selectedPaymentMethod,
      required this.onPaymentSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ThemeColors.backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.w)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.payment, color: ThemeColors.primaryColor, size: 24.w),
              SizedBox(width: 8.w),
              Text('Payment Method',
                  style: AppFonts.bodyTextStyle.copyWith(
                      fontSize: AppFonts.body1TextSize,
                      color: ThemeColors.headlinesTextColor,
                      fontWeight: FontWeight.w500)),
            ]),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                    child: PaymentOptionWidget(
                        title: 'Cash',
                        isSelected: selectedPaymentMethod == 'cash',
                        onTap: () => onPaymentSelected('cash'))),
                SizedBox(width: 16.w),
                Expanded(
                    child: PaymentOptionWidget(
                        title: 'Free',
                        isSelected: selectedPaymentMethod == 'free',
                        onTap: () => onPaymentSelected('free'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentOptionWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentOptionWidget(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeColors.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.w),
          border: Border.all(
              color: isSelected
                  ? ThemeColors.primaryColor
                  : ThemeColors.primaryColorLight.withOpacity(0.3),
              width: 1.5),
        ),
        child: Center(
            child: Text(title,
                style: AppFonts.bodyTextStyle.copyWith(
                    color: ThemeColors.headlinesTextColor,
                    fontWeight: FontWeight.w600))),
      ),
    );
  }
}
