import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/custom_dialog.dart';
import '../../domain/entity/car.dart';
import '../bloc/bloc/car_bloc.dart';
import '../bloc/event/car_event.dart';

class DeleteCarWidget extends StatelessWidget {
  final CarEntity car;

  const DeleteCarWidget({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(Icons.delete, color: theme.indicatorColor),
      onPressed: () => _showDeleteConfirmation(context),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => CustomDialog(
        title: 'Delete Car',
        message:
            'Are you sure you want to delete ${car.company} ${car.model} car?',
        confirmText: 'Delete',
        cancelText: 'Cancel',
        confirmColor: theme.indicatorColor,
        cancelColor: theme.primaryColorDark,
        onConfirm: () {
          Navigator.pop(dialogContext);
          _deleteCar(context);
        },
        onCancel: () {
          Navigator.pop(dialogContext);
        },
      ),
    );
  }

  void _deleteCar(BuildContext context) {
    final carBloc = BlocProvider.of<CarBloc>(context);
    carBloc.add(DeleteCar(car.carId));

    // Show a progress indicator while the car is being deleted
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted ${car.company} ${car.model}'),
        backgroundColor: ThemeColors.accentColor,
      ),
    );
  }
}
