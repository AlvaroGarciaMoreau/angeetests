class Question {
  final int id;
  final String pregunta;
  final Map<String, String> opciones;
  final String respuestaCorrecta;

  Question({
    required this.id,
    required this.pregunta,
    required this.opciones,
    required this.respuestaCorrecta,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      pregunta: json['pregunta'],
      opciones: Map<String, String>.from(json['opciones']),
      respuestaCorrecta: json['respuesta_correcta'],
    );
  }
} 