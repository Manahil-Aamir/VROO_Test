import 'package:equatable/equatable.dart';

import '../../../domain/entity/review.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object> get props => [];
}

class ReviewInitialState extends ReviewState {}

class ReviewLoadingState extends ReviewState {}

class ReviewLoadedState extends ReviewState {
  final ReviewResponseEntity reviewResponse;

  const ReviewLoadedState({required this.reviewResponse});

  @override
  List<Object> get props => [reviewResponse];
}

class ReviewErrorState extends ReviewState {
  final String message;

  const ReviewErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
