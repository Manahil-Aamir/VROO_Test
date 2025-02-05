import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../core/router/navigation.dart';

class BookingConfirmDependencyInjection {
  static List<SingleChildWidget> init() {
    final navigationProvider = Navigation();
    return [
      Provider<Navigation>(create: (_) => navigationProvider),
    ];
  }
}