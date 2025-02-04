import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vroo_test/core/router/navigation.dart';
import 'package:vroo_test/features/rider_journey/presentation/bloc/bloc/booking_confirmation_bloc.dart';

class BookingConfirmDependencyInjection {
  static List<SingleChildWidget> init() {
    final navigationProvider = Navigation();

    // Return the list of providers
    return [
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<BookingConfirmationBloc>(
          create: (_) => BookingConfirmationBloc()),
    ];
  }
}
