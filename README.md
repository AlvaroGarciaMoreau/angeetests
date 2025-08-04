# 🧬 Test de Biología Molecular

Una aplicación Flutter completa para realizar tests de Biología Molecular con un extenso banco de preguntas, generación de PDFs y seguimiento de resultados.

<p align="center">
  <img src="assets/logo.jpg" alt="Logo" width="200"/>
</p>

## 📱 Características

- **🎯 Tests Personalizables**: Selecciona entre 20 y 465 preguntas
- **📚 Amplio Banco de Preguntas**: Más de 465 preguntas de Biología Molecular organizadas por temas
- **📊 Resultados Detallados**: Visualización completa de respuestas correctas e incorrectas
- **📄 Generación de PDFs**: Crea y comparte tests en formato PDF
- **🎨 Interfaz Moderna**: Diseño Material Design con tema personalizado
- **📱 Multiplataforma**: Compatible con Android, iOS, Web, Windows, macOS y Linux

## 🚀 Funcionalidades Principales

### Tests Interactivos
- Selección de número de preguntas (20, 50, 100, 150, 200, 250, 300, 350, 400, 465)
- Preguntas aleatorias para cada test
- Opciones de respuesta mezcladas aleatoriamente
- Indicadores visuales de respuestas correctas e incorrectas
- Navegación intuitiva entre preguntas

### Generación de PDFs
- Exporta tests a formato PDF
- Incluye preguntas y respuestas correctas
- Funcionalidad de compartir integrada
- Formato profesional y legible

### Análisis de Resultados
- Puntuación final con porcentaje
- Revisión detallada de todas las respuestas
- Identificación de preguntas correctas e incorrectas
- Posibilidad de repetir el test

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework principal de desarrollo
- **Dart**: Lenguaje de programación
- **Material Design**: Sistema de diseño de la interfaz
- **PDF Generation**: Librería para crear documentos PDF
- **JSON**: Almacenamiento de preguntas y datos
- **Path Provider**: Gestión de archivos del sistema
- **Share Plus**: Funcionalidad de compartir contenido

## 📋 Requisitos del Sistema

- Flutter SDK 3.2.3 o superior
- Dart SDK compatible
- Android Studio / VS Code (recomendado)
- Git

### Dependencias Principales
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  pdf: ^3.10.7
  path_provider: ^2.1.2
  share_plus: ^7.2.1
  permission_handler: ^11.2.0
```

## 🔧 Instalación y Configuración

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/AlvaroGarciaMoreau/angeetests.git
   cd angeetests
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/
│   └── question.dart         # Modelo de datos para preguntas
├── screens/
│   ├── splash_screen.dart    # Pantalla de inicio
│   ├── home_screen.dart      # Pantalla principal
│   ├── quiz_screen.dart      # Pantalla del test
│   └── results_screen.dart   # Pantalla de resultados
├── services/
│   └── pdf_service.dart      # Servicio de generación de PDFs
└── theme/
    └── app_theme.dart        # Configuración del tema visual

assets/
├── biologia_molecular.json  # Base de datos de preguntas
├── logo.jpg                 # Logo de la aplicación
└── fonts/
    └── Roboto-Regular.ttf    # Fuente personalizada
```

## 🎯 Uso de la Aplicación

### Realizar un Test
1. Abre la aplicación y espera a que cargue la pantalla principal
2. Selecciona el número de preguntas deseadas
3. Responde cada pregunta seleccionando una opción
4. Navega entre preguntas usando los botones
5. Finaliza el test para ver los resultados

### Generar PDF
1. En la pantalla principal, presiona "Generar PDF"
2. Introduce el número de preguntas deseadas
3. Espera a que se genere el documento
4. Comparte o guarda el PDF generado

## 🔄 Base de Datos de Preguntas

La aplicación incluye más de 465 preguntas organizadas por temas de Biología Molecular:
- El laboratorio de citogenética y cultivo celular
- Técnicas de biología molecular
- Análisis cromosómico
- PCR y técnicas de amplificación
- Y muchos más...

## 🏗️ Compilación para Producción

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

### Windows
```bash
flutter build windows --release
```

## 🤝 Contribución

Las contribuciones son bienvenidas. Para contribuir:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 👨‍💻 Autor

**Álvaro García Moreau**
- GitHub: [@AlvaroGarciaMoreau](https://github.com/AlvaroGarciaMoreau)

## 📞 Soporte

Si tienes preguntas o necesitas ayuda, no dudes en:
- Abrir un [issue](https://github.com/AlvaroGarciaMoreau/angeetests/issues)
- Contactar al desarrollador

---

⭐ ¡No olvides dar una estrella al proyecto si te ha sido útil!
