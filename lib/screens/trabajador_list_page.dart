import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/theme_controller.dart';
import 'package:flutter_application_1/utils/animations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pdf/pdf.dart';
import '../database/trabajador_db.dart';
import '../models/trabajador_model.dart';
import '../utils/date_utils.dart';
import 'trabajador_form_page.dart';
import 'package:printing/printing.dart';
import '../utils/pdf_generator.dart';

class TrabajadorListPage extends StatefulWidget {
  const TrabajadorListPage({super.key});

  @override
  State<TrabajadorListPage> createState() => _TrabajadorListPageState();
}

class _TrabajadorListPageState extends State<TrabajadorListPage> {
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Trabajador>(TrabajadorDB.boxName);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Trabajadores'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode),
              Switch(
                value: ThemeController.isDark,
                onChanged: (val) => ThemeController.toggleTheme(val),
              ),
              const Icon(Icons.dark_mode),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.picture_as_pdf),
                tooltip: 'Exportar PDF',
                onPressed: () async {
                  final trabajadores = box.values.toList();
                  if (trabajadores.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No hay trabajadores para exportar')),
                    );
                    return;
                  }

                  final pdf = await PDFGenerator.generarTrabajadoresPDF(trabajadores);
                  await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => pdf.save(),
                  );
                },
              ),
              const SizedBox(width: 6),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o apellido...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.deepPurple.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, Box<Trabajador> box, _) {
                  List<Trabajador> trabajadores = box.values.toList();

                  if (searchText.isNotEmpty) {
                    trabajadores = trabajadores.where((t) {
                      final nombre = t.nombres.toLowerCase();
                      final apellido = t.apellidos.toLowerCase();
                      return nombre.contains(searchText) || apellido.contains(searchText);
                    }).toList();
                  }

                  if (trabajadores.isEmpty) {
                    return const Center(child: Text("No hay trabajadores registrados"));
                  }

                  return ListView.builder(
                    itemCount: trabajadores.length,
                    itemBuilder: (context, index) {
                      final trabajador = trabajadores[index];
                      final edad = DateUtilsCustom.calcularEdad(trabajador.fechaNacimiento);

                      final imageProvider = trabajador.imagenPath != null
                          ? (kIsWeb
                              ? NetworkImage(trabajador.imagenPath!)
                              : FileImage(File(trabajador.imagenPath!)) as ImageProvider)
                          : null;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        child: SlideFadeIn(
                          delay: Duration(milliseconds: index * 100),
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            elevation: 6,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Hero(
                                tag: 'avatar-${trabajador.key}',
                                child: CircleAvatar(
                                  backgroundColor: Colors.deepPurple.shade200,
                                  backgroundImage: imageProvider,
                                  child: imageProvider == null
                                      ? Text(
                                          trabajador.nombres[0].toUpperCase(),
                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        )
                                      : null,
                                ),
                              ),
                              title: Text(
                                '${trabajador.nombres} ${trabajador.apellidos}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Text('Edad: $edad años\nSueldo: S/. ${trabajador.sueldo.toStringAsFixed(2)}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => TrabajadorFormPage(trabajador: trabajador, index: index),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      TrabajadorDB.deleteTrabajador(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TrabajadorFormPage()),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
