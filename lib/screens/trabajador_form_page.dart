import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trabajador_model.dart';
import '../database/trabajador_db.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class TrabajadorFormPage extends StatefulWidget {
  final Trabajador? trabajador;
  final int? index;

  const TrabajadorFormPage({super.key, this.trabajador, this.index});

  @override
  State<TrabajadorFormPage> createState() => _TrabajadorFormPageState();
}

class _TrabajadorFormPageState extends State<TrabajadorFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombresCtrl;
  late TextEditingController apellidosCtrl;
  late TextEditingController sueldoCtrl;
  DateTime? fechaNacimiento;
  XFile? _imagen;

  @override
  void initState() {
    super.initState();
    final t = widget.trabajador;
    nombresCtrl = TextEditingController(text: t?.nombres ?? '');
    apellidosCtrl = TextEditingController(text: t?.apellidos ?? '');
    sueldoCtrl = TextEditingController(text: t?.sueldo.toString() ?? '');
    fechaNacimiento = t?.fechaNacimiento;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fechaNacimiento ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => fechaNacimiento = picked);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagen = picked;
      });
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate() && fechaNacimiento != null) {
      final trabajador = Trabajador(
        nombres: nombresCtrl.text.trim(),
        apellidos: apellidosCtrl.text.trim(),
        fechaNacimiento: fechaNacimiento!,
        sueldo: double.parse(sueldoCtrl.text),
        imagenPath: _imagen?.path ?? widget.trabajador?.imagenPath,
      );

      if (widget.index != null) {
        await TrabajadorDB.updateTrabajador(widget.index!, trabajador);
      } else {
        await TrabajadorDB.addTrabajador(trabajador);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd/MM/yyyy');

    final imageProvider = _imagen != null
        ? (kIsWeb
            ? NetworkImage(_imagen!.path)
            : FileImage(File(_imagen!.path)) as ImageProvider)
        : (widget.trabajador?.imagenPath != null
            ? (kIsWeb
                ? NetworkImage(widget.trabajador!.imagenPath!)
                : FileImage(File(widget.trabajador!.imagenPath!)) as ImageProvider)
            : null);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trabajador == null ? 'Nuevo Trabajador' : 'Editar Trabajador'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: Hero(
                      tag: 'avatar-${widget.trabajador?.key ?? UniqueKey()}',
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurple.shade200,
                        backgroundImage: imageProvider,
                        child: imageProvider == null
                            ? Text(
                                nombresCtrl.text.isNotEmpty
                                    ? nombresCtrl.text[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(fontSize: 22, color: Colors.white),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text("Seleccionar imagen"),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nombresCtrl,
                    decoration: const InputDecoration(labelText: 'Nombres'),
                    validator: (val) => val == null || val.isEmpty ? 'Ingrese nombres' : null,
                  ),
                  TextFormField(
                    controller: apellidosCtrl,
                    decoration: const InputDecoration(labelText: 'Apellidos'),
                    validator: (val) => val == null || val.isEmpty ? 'Ingrese apellidos' : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Fecha de nacimiento: ${fechaNacimiento != null ? f.format(fechaNacimiento!) : "No seleccionada"}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("Seleccionar fecha"),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: sueldoCtrl,
                    decoration: const InputDecoration(labelText: 'Sueldo'),
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                        val == null || double.tryParse(val) == null ? 'Ingrese un sueldo válido' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
