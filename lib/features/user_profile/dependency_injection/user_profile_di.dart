import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;
import '../data/data_source/user_profile_remote_datasource.dart';
import '../data/repository/user_profile_repository_impl.dart';
import '../domain/repository/user_profile_repository.dart';
import '../domain/usecase/get_user_profile.dart';
import '../domain/usecase/update_user_profile.dart';
import '../presentation/bloc/bloc/user_profile_bloc.dart';

class UserProfileDi {
  static List<SingleChildWidget> init() {
    final httpClient = http.Client();
    final firebaseAuth = FirebaseAuth.instance; 
    final dataSource = UserProfileRemoteDataSourceImpl(client: httpClient);
    final repository = UserProfileRepositoryImpl(remoteDataSource: dataSource, firebaseAuth: firebaseAuth);
    final getUserProfile = GetUserProfile(repository);
    final updateUserProfile = UpdateUserProfile(repository);

    return [
      Provider<UserProfileRemoteDataSource>(create: (_) => dataSource),
      Provider<UserProfileRepository>(create: (_) => repository),
      Provider<GetUserProfile>(create: (_) => getUserProfile),
      BlocProvider<UserProfileBloc>(
        create: (_) => UserProfileBloc(getUserProfile: getUserProfile, updateUserProfile: updateUserProfile),
      ),
    ];
  }
}
