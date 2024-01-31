// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobhourjourney/Components/appbar_component.dart';
import 'package:jobhourjourney/Models/Day_record.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class Payroll extends StatelessWidget {
  final List<DayRecord> records;

  const Payroll({Key? key, required this.records}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Scaffold(
        appBar: appBar(context),
        body: const Center(
          child: Text('No hay horas añadidas'),
        ),
      );
    }

    int totalHours = 0;
    int extraHours = 0;

    double totalSalary = 0.0;
    double totalSalaryOvertime = 0.0;

    for (var recordItem in records) {
      totalHours += recordItem.hours;
      extraHours += recordItem.overtimeHours ?? 0;

      totalSalary += recordItem.salary * recordItem.hours;

      if (recordItem.hasOvertime) {
        totalSalaryOvertime +=
            recordItem.overtimeRate! * (recordItem.overtimeHours ?? 0);
      }
    }

    double totalSalaryWithOvertime = totalSalary + totalSalaryOvertime;

    return Scaffold(
      appBar: appBar(context),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Horas Trabajadas'),
            _buildInfoRow('Total de horas trabajadas:', '$totalHours horas'),
            _buildInfoRow('Total de horas extras:', '$extraHours horas'),
            const SizedBox(height: 24.0),
            const Divider(), // Divisor entre secciones
            const SizedBox(height: 24.0),
            _buildSectionHeader('Salarios'),
            _buildSalaryRow('Horas normales:', totalSalary),
            _buildSalaryRow(
                'Horas extras:', totalSalaryOvertime),
                 _buildSalaryRow(
                'Salario total:', totalSalaryWithOvertime),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
      floatingActionButton: _buildDownloadButton(
        context,
        totalHours,
        extraHours,
        totalSalary,
        totalSalaryOvertime,
        totalSalaryWithOvertime,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16.0)),
        Text(value,
            style:
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSalaryRow(String label, double value) {
    return _buildInfoRow(
      label,
      '\$${value.toStringAsFixed(2)}',
    );
  }

  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDownloadButton(
      BuildContext context,
      int totalHours,
      int extraHours,
      double totalSalary,
      double totalSalaryOvertime,
      double totalSalaryWithOvertime) {
    return FloatingActionButton(
      onPressed: () async {
        await _generatePdf(context, totalHours, extraHours, totalSalary,
            totalSalaryOvertime, totalSalaryWithOvertime);
      },
      tooltip: 'Generar PDF',
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Icon(
        Icons.download,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _generatePdf(
      BuildContext context,
      int totalHours,
      int extraHours,
      double totalSalary,
      double totalSalaryOvertime,
      double totalSalaryWithOvertime) async {
    final pdf = pw.Document();

    // Añadir contenido al PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            children: [
              pw.Text(
                'JobJourney Resumen de Pago\n\n',
                style: pw.TextStyle(
                    fontSize: 20.0, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'Total de horas trabajadas: $totalHours horas\n'
                'Total de horas extras: $extraHours horas\n'
                'Salario total sin horas extras: \$${totalSalary.toStringAsFixed(2)}\n'
                'Salario total con horas extras: \$${totalSalaryWithOvertime.toStringAsFixed(2)}\n'
                'Salario solo de horas extras: \$${totalSalaryOvertime.toStringAsFixed(2)}\n',
                style: const pw.TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );

    // Obtener la ruta del directorio de descargas
    final String dir = (await getDownloadsDirectory())?.path ??
        (await getApplicationDocumentsDirectory()).path;

    // Asegurarse de que el directorio exista
    if (!Directory(dir).existsSync()) {
      Directory(dir).createSync(recursive: true);
    }

    // Combinar la ruta con el nombre del archivo
    final String filePath = '$dir/resumen_pago.pdf';
    final File file = File(filePath);

    // Guardar el PDF
    await file.writeAsBytes(await pdf.save());

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF generado con éxito en la ruta\n $filePath')),
    );
  }
}
