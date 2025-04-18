import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import '../presentation/bloc/user_bloc.dart';

class UserDi {
  static List<SingleChildWidget> init() {
    return [
      // user bloc provider
      BlocProvider<UserBloc>(
        create: (_) => UserBloc(
        ),
      ),
    ];
  }
}
