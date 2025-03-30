import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../../../core/services/aa.dart';
import '../../../core/services/bb.dart';
import '../data/data_source/location_data_source.dart';
import '../data/repository/location_repository_impl.dart';
import '../domain/repository/location_repository.dart';
import '../domain/usecases/track_location.dart';
import '../presentation/bloc/bloc/location_bloc.dart';

class LocationTrackingDependencyInjection {
  static List<SingleChildWidget> init() {
    
    return [
      
    ];
  }
}
