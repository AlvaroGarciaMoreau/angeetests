import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import 'results_screen.dart';

class QuizScreen extends StatefulWidget {
  final int questionCount;

  const QuizScreen({Key? key, required this.questionCount}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [];
  List<Question> selectedQuestions = [];
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  bool hasAnswered = false;
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final String response = await rootBundle.loadString('assets/biologia_molecular.json');
    final List<dynamic> jsonData = json.decode(response);
    
    // Extract all questions from all topics
    questions = [];
    for (var topic in jsonData) {
      final List<dynamic> topicQuestions = topic['preguntas'];
      questions.addAll(topicQuestions.map((json) => Question.fromJson(json)));
    }
    
    // Shuffle the questions
    questions.shuffle();
    
    // Select the required number of questions
    selectedQuestions = questions.take(widget.questionCount).toList();
    
    // Shuffle options for each question while maintaining correct answer reference
    for (var question in selectedQuestions) {
      final correctAnswer = question.respuestaCorrecta;
      question.opciones.shuffle();
      // Ensure the correct answer is still referenced correctly
      question.respuestaCorrecta = correctAnswer;
    }
    
    // Verify if we have enough unique questions
    if (selectedQuestions.length < widget.questionCount) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No hay suficientes preguntas únicas disponibles. Se mostrarán ${selectedQuestions.length} preguntas.',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
    
    setState(() {});
  }

  void checkAnswer(String answer) {
    if (hasAnswered) return;

    setState(() {
      selectedAnswer = answer;
      hasAnswered = true;
      if (answer == selectedQuestions[currentQuestionIndex].respuestaCorrecta) {
        correctAnswers++;
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < selectedQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        hasAnswered = false;
        selectedAnswer = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            correctAnswers: correctAnswers,
            totalQuestions: selectedQuestions.length,
          ),
        ),
      );
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        hasAnswered = false;
        selectedAnswer = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedQuestions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentQuestion = selectedQuestions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Pregunta ${currentQuestionIndex + 1}/${selectedQuestions.length}'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundColor,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      currentQuestion.pregunta,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: currentQuestion.opciones.map((option) {
                      final isSelected = selectedAnswer == option;
                      final isCorrect = option == currentQuestion.respuestaCorrecta;
                      
                      Color buttonColor = AppTheme.primaryColor;
                      if (hasAnswered) {
                        if (isCorrect) {
                          buttonColor = AppTheme.successColor;
                        } else if (isSelected) {
                          buttonColor = AppTheme.errorColor;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () => checkAnswer(option),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (hasAnswered)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: currentQuestionIndex > 0 ? previousQuestion : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: currentQuestionIndex > 0 ? AppTheme.accentColor : Colors.grey,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentColor,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            currentQuestionIndex < selectedQuestions.length - 1
                                ? 'Siguiente pregunta'
                                : 'Ver resultados',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 