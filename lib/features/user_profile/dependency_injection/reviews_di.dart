import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;
import '../data/data_source/review_data_source.dart';
import '../data/repository/review_repository_impl.dart';
import '../domain/repository/review_repository.dart';
import '../domain/usecase/get_reviews.dart';
import '../presentation/bloc/bloc/reviews_bloc.dart';

class ReviewDependencyInjection {
  static List<SingleChildWidget> init() {
    final client = http.Client();
    final firebaseAuth = FirebaseAuth.instance;

    final reviewRemoteDataSource = ReviewRemoteDataSourceImpl(client: client);
    final reviewRepository = ReviewRepositoryImpl(
      remoteDataSource: reviewRemoteDataSource,
      firebaseAuth: firebaseAuth,
    );
    final getReviewsUseCase = GetReviewsUseCase(repository: reviewRepository);

    return [
      Provider<ReviewRemoteDataSource>(create: (_) => reviewRemoteDataSource),
      Provider<ReviewRepository>(create: (_) => reviewRepository),
      Provider<GetReviewsUseCase>(create: (_) => getReviewsUseCase),
      BlocProvider<ReviewBloc>(
        create: (context) => ReviewBloc(
          getReviewsUseCase: context.read<GetReviewsUseCase>(),
        ),
      ),
    ];
  }
}