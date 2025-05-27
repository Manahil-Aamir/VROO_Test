import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entity/review.dart';
import '../../domain/repository/review_repository.dart';
import '../data_source/review_data_source.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;
  final FirebaseAuth firebaseAuth;

  ReviewRepositoryImpl({required this.remoteDataSource, required this.firebaseAuth});

  Future<String> getToken() async {
    final user = firebaseAuth.currentUser!;
    final token = await user.getIdToken();
    return token!;
  }


  @override
  Future<ReviewResponseEntity> getReviews() async {
    try {
      final result = await remoteDataSource.getReviews(await getToken());
      return result;
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}