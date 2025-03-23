import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/bloc/sos_bloc.dart';
import '../bloc/event/sos_event.dart';

class SosTab extends StatelessWidget {
  final String uid;

  const SosTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: InkResponse(
        onTap: () => BlocProvider.of<SosBloc>(context).add(TriggerSos(uid)),
        borderRadius: BorderRadius.circular(90),
        splashColor: theme.indicatorColor.withOpacity(0.3),
        highlightColor: theme.indicatorColor.withOpacity(0.2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 180.w,
          height: 180.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.indicatorColor,
                theme.indicatorColor.withOpacity(0.5)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.indicatorColor.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 5,
              )
            ],
          ),
          child: Center(
            child: Text(
              "SOS",
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
