import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/controllers/quiz_controller.dart';

class QuizScreen extends StatelessWidget {
  QuizScreen({Key? key}) : super(key: key);

  QuizController quizController = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo[900]!, Colors.deepPurple])),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo[900],
            leading: const Icon(Icons.menu),
          ),
          backgroundColor: Colors.transparent,
          body: GetX<QuizController>(builder: (controller) {
            if (controller.isLoading.value) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            }
            return SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: ListView.builder(
                      itemCount: controller.quizList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          return Container(
                            height: 30,
                            width: 30,
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: quizController.pageNo.value == index
                                    ? Colors.white
                                    : Colors.transparent,
                                border: Border.all(color: Colors.white)),
                            child: quizController.corectAns.length < index + 1
                                ? Center(
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                          color: quizController.pageNo.value ==
                                                  index
                                              ? primaryColor
                                              : Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Center(
                                    child: Icon(
                                        quizController.corectAns[index]
                                            ? Icons.done
                                            : Icons.close,
                                        color: Colors.white),
                                  ),
                          );
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                        itemCount: controller.quizList.length,
                        controller: PageController(viewportFraction: 0.8),
                        itemBuilder: (context, index) {
                          List<AnswerModel>? answers = quizController
                              .quizList[index].answers
                              .toJson()
                              .entries
                              .map((e) => AnswerModel(e.key, e.value))
                              .toList();
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Question " +
                                        (index + 1).toString() +
                                        "/" +
                                        controller.quizList.length.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Text(
                                      controller.quizList[index].question,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: answers.length,
                                      itemBuilder: (context, ansIndex) {
                                        return Visibility(
                                            visible:
                                                answers[ansIndex].value != null,
                                            child: GestureDetector(
                                              onTap: () {
                                                quizController.answerSel(
                                                    answers[ansIndex],
                                                    index,
                                                    quizController
                                                        .quizList[index]);
                                              },
                                              child: Obx(() {
                                                bool chosenAnswer =
                                                    selectedAnswer(
                                                        quizController,
                                                        answers[ansIndex]
                                                            .value!,
                                                        index);
                                                return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                        color: chosenAnswer
                                                            ? primaryColor
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                            color:
                                                                primaryColor)),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          String.fromCharCode(
                                                                  ansIndex +
                                                                      65) +
                                                              ". ",
                                                          style: TextStyle(
                                                              color: chosenAnswer
                                                                  ? Colors.white
                                                                  : primaryColor),
                                                        ),
                                                        Expanded(
                                                            child: Text(
                                                                answers[ansIndex]
                                                                        .value ??
                                                                    "",
                                                                style: TextStyle(
                                                                    color: chosenAnswer
                                                                        ? Colors
                                                                            .white
                                                                        : primaryColor)))
                                                      ],
                                                    ));
                                              }),
                                            ));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        onPageChanged: (value) {
                          controller.pageChanged(value);
                        }),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Wrap(
                                  children: [
                                    Center(
                                      child: Text(
                                        quizController.correctAnswers
                                                .toString() +
                                            ' out of ' +
                                            quizController.quizList.length
                                                .toString(),
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 18),
                        )),
                  )
                ],
              ),
            );
          })),
    );
  }
}

class AnswerModel {
  final String? key;
  final String? value;

  AnswerModel(this.key, this.value);
}

bool selectedAnswer(QuizController controller, String answer, int quesIndex) {
  try {
    if (controller.selAnswers.isEmpty) {
      return false;
    } else if (controller.selAnswers[quesIndex].value == answer) {
      return true;
    }
  } catch (e) {
    return false;
  }
  return false;
}
