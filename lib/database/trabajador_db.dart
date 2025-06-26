import 'package:hive/hive.dart';
import '../models/trabajador_model.dart';

class TrabajadorDB {
  static const String boxName = 'trabajadores_box';

  static Future<void> addTrabajador(Trabajador trabajador) async {
    final box = Hive.box<Trabajador>(boxName);
    await box.add(trabajador);
  }

  static List<Trabajador> getTrabajadores() {
    final box = Hive.box<Trabajador>(boxName);
    return box.values.toList();
  }

  static Future<void> updateTrabajador(int index, Trabajador trabajador) async {
    final box = Hive.box<Trabajador>(boxName);
    await box.putAt(index, trabajador);
  }

  static Future<void> deleteTrabajador(int index) async {
    final box = Hive.box<Trabajador>(boxName);
    await box.deleteAt(index);
  }
}
