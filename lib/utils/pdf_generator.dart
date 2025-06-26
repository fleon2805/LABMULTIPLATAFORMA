import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/trabajador_model.dart';

class PDFGenerator {
  static Future<pw.Document> generarTrabajadoresPDF(List<Trabajador> trabajadores) async {
    final pdf = pw.Document();
    final f = DateFormat('dd/MM/yyyy');

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Text('Lista de Trabajadores',
                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['Nombre completo', 'F. Nacimiento', 'Edad', 'Sueldo'],
            data: trabajadores.map((t) {
              final edad = DateTime.now().year - t.fechaNacimiento.year;
              return [
                '${t.nombres} ${t.apellidos}',
                f.format(t.fechaNacimiento),
                '$edad',
                'S/. ${t.sueldo.toStringAsFixed(2)}',
              ];
            }).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellPadding: const pw.EdgeInsets.all(5),
          ),
        ],
      ),
    );

    return pdf;
  }
}
