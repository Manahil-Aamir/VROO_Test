import '../repository/matching_repository.dart';

class SendJoinRequestUseCase {
  final MatchingRepository repository;

  SendJoinRequestUseCase(this.repository);

  Future<Map<String, dynamic>> execute(Map<String, String> requestData) {
    return repository.sendRequest(requestData);
  }
}
