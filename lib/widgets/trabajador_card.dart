import 'package:flutter/material.dart';
import '../models/trabajador_model.dart';
import '../utils/date_utils.dart';

class TrabajadorCard extends StatelessWidget {
  final Trabajador trabajador;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TrabajadorCard({
    super.key,
    required this.trabajador,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final edad = DateUtilsCustom.calcularEdad(trabajador.fechaNacimiento);

    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue.shade200,
          child: Text(
            trabajador.nombres[0].toUpperCase(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          '${trabajador.nombres} ${trabajador.apellidos}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          'Edad: $edad años\nSueldo: S/. ${trabajador.sueldo.toStringAsFixed(2)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
