class Question {
  final String pregunta;
  final List<String> opciones;
  final String respuestaCorrecta;

  Question({
    required this.pregunta,
    required this.opciones,
    required this.respuestaCorrecta,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      pregunta: json['pregunta'],
      opciones: List<String>.from(json['opciones']),
      respuestaCorrecta: json['respuesta_correcta'],
    );
  }
} 