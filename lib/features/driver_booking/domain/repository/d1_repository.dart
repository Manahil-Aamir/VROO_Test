abstract class D1Repository {
  Future<void> saveSchedule(Map<String, dynamic> scheduleData);
  Future<Map<String, dynamic>?> loadSchedule();
  //Future<void> clearScheduleData();
}
