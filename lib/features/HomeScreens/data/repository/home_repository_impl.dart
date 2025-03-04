import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data_source/home_data_source.dart';
import '../../domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;

  HomeRepositoryImpl(this.dataSource);

  @override
  Future<LatLng> getCurrentLocation() => dataSource.getCurrentLocation();

  @override
  Future<void> clearSharedPreferences() => dataSource.clearSharedPreferences();

  @override
  Future<void> logout() => dataSource.logout();
}