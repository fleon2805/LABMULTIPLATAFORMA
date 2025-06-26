# 📱 CRUD de Trabajadores en Flutter

Aplicación Flutter moderna y multiplataforma que permite registrar, editar, eliminar, buscar y exportar trabajadores con un diseño profesional.

---

## ✨ Características principales

✅ CRUD completo con Hive (sin conexión a internet)  
✅ Soporte para Web, Android, Windows, macOS y Linux  
✅ Foto de perfil para cada trabajador  
✅ Animaciones suaves de entrada y transiciones `Hero`  
✅ Búsqueda en tiempo real por nombre o apellido  
✅ Cambio de tema claro/oscuro  
✅ Exportación a PDF lista para impresión o descarga  
✅ Código limpio, modular y reutilizable  

---

## 🚀 Tecnologías usadas

- Flutter 3.x
- Hive (almacenamiento local)
- image_picker (para la foto)
- printing y pdf (exportación)
- `flutter_hooks` + `ValueListenableBuilder`
- Soporte completo para `ThemeMode`

---

## 📦 Instalación y ejecución

```bash
git clone https://github.com/tu_usuario/flutter-crud-trabajadores.git
cd flutter-crud-trabajadores
flutter pub get
flutter run -d chrome # o android, windows, etc.



🖨 Exportación a PDF
Pulsa el ícono de PDF en la barra superior para generar un archivo con los datos actuales de la lista de trabajadores. Se abre automáticamente para imprimir, guardar o compartir.



📁 Estructura del proyecto
lib/
├── models/
├── screens/
├── database/
├── utils/
├── widgets/
├── theme/
└── main.dart
