abstract class D2Repository {
  Future<void> saveCarPreferences(Map<String, dynamic> preferencesData);
  Future<Map<String, dynamic>?> loadCarPreferences();
  // Future<void> clearCarPreferences();
}