import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/question.dart';

class PdfService {
  static Future<void> generateAndSharePdf(int questionCount) async {
    try {
      // Load questions from JSON
      final String response = await rootBundle.loadString('assets/biologia_molecular.json');
      final List<dynamic> jsonData = json.decode(response);
      
      // Extract all questions
      List<Question> questions = [];
      for (var topic in jsonData) {
        final List<dynamic> topicQuestions = topic['preguntas'];
        questions.addAll(topicQuestions.map((json) => Question.fromJson(json)));
      }
      
      // Shuffle and select questions
      questions.shuffle();
      questions = questions.take(questionCount).toList();

      // Load font
      final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
      final ttf = pw.Font.ttf(fontData);

      // Create PDF
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: ttf,
          ),
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Test de Biología Molecular',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  font: ttf,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            ...questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Pregunta ${index + 1}:',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      font: ttf,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    question.pregunta,
                    style: pw.TextStyle(
                      fontSize: 14,
                      font: ttf,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  ...question.opciones.map((option) => pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 20, bottom: 4),
                    child: pw.Text(
                      '• $option',
                      style: pw.TextStyle(
                        fontSize: 12,
                        font: ttf,
                      ),
                    ),
                  )),
                  pw.SizedBox(height: 16),
                ],
              );
            }).toList(),
            pw.SizedBox(height: 20),
            pw.Text(
              'Respuestas correctas:',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                font: ttf,
              ),
            ),
            pw.SizedBox(height: 8),
            ...questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              return pw.Text(
                '${index + 1}. ${question.respuestaCorrecta}',
                style: pw.TextStyle(
                  fontSize: 12,
                  font: ttf,
                ),
              );
            }).toList(),
          ],
        ),
      );

      // Save PDF to cache directory
      final cacheDir = await getTemporaryDirectory();
      final file = File('${cacheDir.path}/test_biologia_molecular.pdf');
      
      // Ensure the file doesn't exist
      if (await file.exists()) {
        await file.delete();
      }
      
      // Save the PDF
      final bytes = await pdf.save();
      await file.writeAsBytes(bytes);

      // Verify the file was created
      if (!await file.exists()) {
        throw Exception('Error al guardar el archivo PDF');
      }

      // Share PDF
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Test de Biología Molecular - $questionCount preguntas',
      );

      // Clean up the temporary file after sharing
      if (await file.exists()) {
        await file.delete();
      }

      if (result.status == ShareResultStatus.dismissed) {
        throw Exception('Compartir cancelado');
      }
    } catch (e) {
      throw Exception('Error al generar el PDF: ${e.toString()}');
    }
  }
} 