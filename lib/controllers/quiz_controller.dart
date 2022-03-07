import 'package:get/get.dart';
import 'package:quiz/models/quiz_data_model.dart';
import 'package:quiz/services/rest_data_services.dart';
import 'package:quiz/views/quiz_screen.dart';

class QuizController extends GetxController {
  var quizList = <QuizData>[].obs;
  var isLoading = false.obs;
  var pageNo = 0.obs;
  var selAnswers = <AnswerModel>[].obs;
  var corectAns = <bool>[].obs;
  var correctAnswers = 0.obs;

  @override
  void onInit() {
    getQuizData();
    super.onInit();
  }

  void pageChanged(int val) => pageNo.value = val;

  void answerSel(AnswerModel val, int index, QuizData quizData) {
    if (selAnswers.length - 1 < index) {
      selAnswers.insert(index, val);
      if (quizData.correctAnswer == val.key) {
        corectAns.insert(index, true);
        correctAnswers.value = correctAnswers.value + 1;
      } else {
        corectAns.insert(index, false);
      }
    }
  }

  void getQuizData() async {
    isLoading(true);
    List<QuizData>? quizData =
        quizDataFromJson(await RestDataServices().getDataCalls<QuizData>());
    if (quizData != null) {
      quizList.value = quizData;
    }
    isLoading(false);
  }
}
