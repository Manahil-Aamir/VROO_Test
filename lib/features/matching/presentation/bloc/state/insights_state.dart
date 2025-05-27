abstract class DriverInsightsState {}

class DriverInsightsInitial extends DriverInsightsState {}

class DriverInsightsLoading extends DriverInsightsState {}

class DriverInsightsLoaded extends DriverInsightsState {
  final String insights;

  DriverInsightsLoaded(this.insights);
}

class DriverInsightsError extends DriverInsightsState {
  final String message;

  DriverInsightsError(this.message);
}
