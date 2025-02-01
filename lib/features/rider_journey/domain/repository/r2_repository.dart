abstract class R2Repository {
  Future<void> savePreference(Map<String, dynamic> preferenceData);
  Future<Map<String, dynamic>?> loadPreference();
}
