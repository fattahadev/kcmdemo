import 'package:kcmdemo/models/question.dart';
import 'package:kcmdemo/services/kcm_service.dart';

class KcmRepositoryImpl implements KcmRepository {

  KcmService service = KcmService();

  @override
  Stream<List<Question>> fetchData() {
    return service.getListOfQuestion();
  }

}

abstract class KcmRepository {
  Stream<List<Question>> fetchData();
}