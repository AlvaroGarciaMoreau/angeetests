import 'dart:convert';
import 'dart:math';
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
    final Map<String, dynamic> jsonData = json.decode(response);
    final List<dynamic> preguntasData = jsonData['examen_biologia_molecular_y_citogenetica']['preguntas'];
    questions = preguntasData.map((json) => Question.fromJson(json)).toList();
    
    // Asegurarnos de que no haya preguntas duplicadas por ID
    questions = questions.toSet().toList();
    
    // Mezclar las preguntas
    questions.shuffle();
    
    // Seleccionar el número requerido de preguntas únicas
    selectedQuestions = questions.take(widget.questionCount).toList();
    
    // Verificar si tenemos suficientes preguntas únicas
    if (selectedQuestions.length < widget.questionCount) {
      // Si no hay suficientes preguntas únicas, mostrar un mensaje de error
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
        decoration: BoxDecoration(
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
                    children: currentQuestion.opciones.entries.map((option) {
                      final isSelected = selectedAnswer == option.key;
                      final isCorrect = option.key == currentQuestion.respuestaCorrecta;
                      
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
                          onPressed: () => checkAnswer(option.key),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            option.value,
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
                    child: ElevatedButton(
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
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 