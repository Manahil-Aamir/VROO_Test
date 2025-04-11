import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../domain/entity/car.dart';
import '../bloc/event/car_event.dart';
import '../bloc/bloc/car_bloc.dart';

class UpdateMileageModal extends StatefulWidget {
  final CarEntity car;
  final CarBloc carBloc;

  const UpdateMileageModal({
    Key? key,
    required this.car,
    required this.carBloc,
  }) : super(key: key);

  @override
  _UpdateMileageModalState createState() => _UpdateMileageModalState();
}

class _UpdateMileageModalState extends State<UpdateMileageModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _mileageController;

  @override
  void initState() {
    super.initState();
    // Initialize with current mileage value
    _mileageController = TextEditingController(text: widget.car.mileage.toString());
  }

  @override
  void dispose() {
    _mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.w,
        right: 16.w,
        top: 16.w,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Update Mileage',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: ThemeColors.buttonTextColor,
                  ),
            ),
            SizedBox(height: 16.h),
            
            // Car info section
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: ThemeColors.primaryColorDark,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/car.png',
                    width: 40.r,
                    height: 40.r,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.car.company} ${widget.car.model}',
                          style: TextStyle(
                            color: ThemeColors.buttonTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          widget.car.numberPlate,
                          style: TextStyle(
                            color: ThemeColors.buttonTextColor.withOpacity(0.8),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Mileage field
            _buildMileageField(),
            
            SizedBox(height: 24.h),
            GradientButton(
              onTap: _handleSubmit,
              text: "Update Mileage",
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMileageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mileage (km/l)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ThemeColors.cardColor,
              ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _mileageController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ThemeColors.buttonTextColor,
              ),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(color: ThemeColors.buttonTextColor.withOpacity(0.5)),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: ThemeColors.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: ThemeColors.primaryColor,
                width: 2.0,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter mileage';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Create updated car with new mileage
      final updatedCar = CarEntity(
        carId: widget.car.carId,
        company: widget.car.company,
        model: widget.car.model,
        color: widget.car.color,
        numberPlate: widget.car.numberPlate,
        mileage: double.parse(_mileageController.text),
        isVerified: widget.car.isVerified,
      );

      // Add update event to bloc
      widget.carBloc.add(UpdateCar(
        updatedCar.carId, updatedCar.mileage,
      ));
      Navigator.pop(context);
    }
  }
}
