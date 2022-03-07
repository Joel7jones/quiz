import 'package:quiz/models/quiz_data_model.dart';
import 'package:quiz/services/network_util.dart';

class RestDataServices {
  final NetworkUtil _networkUtil = NetworkUtil();
  static const String _baseUrl = 'https://quizapi.io';
  static const String _apiKey = 'miKa0AK6KcwHjHIFwG6AVZd4fmyOM05lenRRO78f';
  static const String _quizPath =
      '/api/v1/questions?apiKey=$_apiKey&category=linux&difficulty=Hard&limit=20';

  dynamic getDataCalls<T>() async {
    dynamic responseData;
    switch (T) {
      case QuizData:
        responseData = await _networkUtil.get(_baseUrl + _quizPath);
        break;
      default:
    }
    return responseData;
  }
}
