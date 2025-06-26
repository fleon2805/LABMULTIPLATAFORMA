import 'package:hive/hive.dart';

part 'trabajador_model.g.dart'; // se generará automáticamente

@HiveType(typeId: 0)
class Trabajador extends HiveObject {
  @HiveField(0)
  String nombres;

  @HiveField(1)
  String apellidos;

  @HiveField(2)
  DateTime fechaNacimiento;

  @HiveField(3)
  double sueldo;

  @HiveField(4)
  String? imagenPath; 

  Trabajador({
    required this.nombres,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.sueldo,
    this.imagenPath,
  });
}
