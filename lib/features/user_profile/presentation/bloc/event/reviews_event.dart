import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class LoadReviewsEvent extends ReviewEvent {

  const LoadReviewsEvent();

  @override
  List<Object> get props => [];
}
