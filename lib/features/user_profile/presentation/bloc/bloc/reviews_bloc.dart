import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/get_reviews.dart';
import '../event/reviews_event.dart';
import '../state/reviews_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final GetReviewsUseCase getReviewsUseCase;

  ReviewBloc({required this.getReviewsUseCase}) : super(ReviewInitialState()) {
    on<LoadReviewsEvent>(_onLoadReviews);
  }

  Future<void> _onLoadReviews(
    LoadReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoadingState());
    try {
      final reviewResponse = await getReviewsUseCase();
      emit(ReviewLoadedState(reviewResponse: reviewResponse));
    } catch (e) {
      emit(ReviewErrorState(message: e.toString()));
    }
  }
}
