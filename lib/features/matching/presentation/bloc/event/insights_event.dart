abstract class DriverInsightsEvent {}

class LoadDriverInsights extends DriverInsightsEvent {
  final String driverId;

  LoadDriverInsights(this.driverId);
}
