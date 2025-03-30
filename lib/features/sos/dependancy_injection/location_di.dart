import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vroo_test/core/services/bb.dart';

class LocationTrackingDependencyInjection {
  static List<SingleChildWidget> init() {
    return [
      Provider<LocationService>(create: (_) => LocationService()),
    ];
  }
}
