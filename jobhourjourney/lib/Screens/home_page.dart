// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jobhourjourney/Components/alertdialog_component.dart';
import 'package:jobhourjourney/Components/appbar_component.dart';
import 'package:jobhourjourney/Components/button_component.dart';
import 'package:jobhourjourney/Components/record_card.dart';
import 'package:jobhourjourney/Components/search_field_component.dart';
import 'package:jobhourjourney/Models/Day_record.dart';
import 'package:jobhourjourney/Screens/payroll_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Controladores de texto
  TextEditingController hoursController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController overtimeRateController = TextEditingController();
  TextEditingController overtimeHoursController = TextEditingController();
  TextEditingController jobController = TextEditingController();

  // Indica al usuario si ha hecho horas extras
  bool isOvertime = false;

  // Crea una lista vacia, donde se almacenarán las horas del usuario
  List<DayRecord> records = [];

  @override
  void initState() {
    super.initState();
    // Recuperar los registros almacenados al inciar la aplicación.
    LoadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: appBar(context),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 40.0, 12.0, 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  searchField(
                      context,
                      jobController,
                      '¿De qué estás trabajando actualmente?',
                      './images/tools.png',
                      TextInputType.text,
                      false),
                  searchField(
                      context,
                      rateController,
                      '¿Cuánto cobras la hora normal?',
                      './images/dollar.png',
                      TextInputType.number,
                      true),
                  searchField(
                      context,
                      hoursController,
                      '¿Cuántas horas trabajas al día?',
                      './images/hourglass.png',
                      TextInputType.number,
                      true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Horas extras',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Checkbox(
                          checkColor: Theme.of(context).colorScheme.secondary,
                          value: isOvertime,
                          onChanged: (value) {
                            setState(() {
                              isOvertime = value ?? false;
                            });
                          }),
                    ],
                  ),
                  if (isOvertime)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        searchField(
                            context,
                            overtimeRateController,
                            '¿Cuánto cobras la hora extra?',
                            './images/time-twenty-four.png',
                            TextInputType.number,
                            true),
                        searchField(
                            context,
                            overtimeHoursController,
                            '¿Cuántas horas extras has hecho hoy?',
                            './images/money-check-edit.png',
                            TextInputType.number,
                            true)
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CustomButton(
                          text: 'Ver mis nominas',
                          leadingIcon: './images/registration-paper.png',
                          onPressed: () {
                            navigateToPayrollPage();
                          }),
                      const SizedBox(
                        width: 12,
                      ),
                      CustomButton(
                          text: 'Añadir horas',
                          leadingIcon: './images/hourglass.png',
                          onPressed: () {
                            AddRecords();
                          }),
                    ],
                  ),
                  if (records.isEmpty)
                    Container(
                      margin: const EdgeInsets.all(90.0),
                      child: const Text(
                        'No has agregado Horas',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                  if (records.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Column(
                        children: List.generate(records.length, (index) {
                          return recordCard(
                              context, records[index], index, _deleteRecord);
                        }),
                      ),
                    ),
                ],
              )),
        ));
  }

  // Si el usuario se equivoca puede borrar las tarjetas
  void _deleteRecord(int index) {
    setState(() {
      records.removeAt(index);
    });
    SaveRecords();
  }

  Future<void> AddRecords() async {
    String hourText = hoursController.text;
    String rateText = rateController.text;
    String jobText = jobController.text;

    String overtimeRateText = overtimeRateController.text;
    String overtimeHourText = overtimeHoursController.text;

    if (hourText.isEmpty || rateText.isEmpty || jobText.isEmpty) {
      await ShowAlertDialog(context, 'JobJourney', 'Rellena todos los campos!');
      return;
    }

    if (isOvertime == true &&
        (overtimeHourText.isEmpty || overtimeRateText.isEmpty)) {
      await ShowAlertDialog(
          context, 'JobJourney', 'No te olvides de marcar las horas extras!');
      return;
    }

    int hours = int.tryParse(hourText) ?? 0;
    double salary = double.tryParse(rateText) ?? 0.0;

    DateTime currentDate = DateTime.now();
    String fullDate = '${currentDate.day}/${currentDate.month}';

    bool hasOvertime = isOvertime;
    int? overtimeHours = int.tryParse(overtimeHourText);
    double? overtimeRate = double.tryParse(overtimeRateText);

    DayRecord dayRecord = DayRecord(
        date: fullDate,
        hours: hours,
        salary: salary,
        job: jobText,
        hasOvertime: hasOvertime,
        overtimeHours: overtimeHours,
        overtimeRate: overtimeRate);

    setState(() {
      records.add(dayRecord);
      hoursController.clear();
      overtimeHoursController.clear();
    });

    if (records.length >= 30) {
      // Mandar al usuario directo a la pagina de payroll
      // porque su jornada ha terminado
      navigateToPayrollPage();
    }

    SaveRecords();
  }

  // Metodo para guardar las horas del usuario
  Future<void> SaveRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson =
        records.map((record) => jsonEncode(record.toJson())).toList();

    await prefs.setStringList('records', recordsJson);
  }

  // Metodo para cargar los datos guardados y mostrarlos al usuario
  Future<void> LoadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList('records');

    if (recordsJson != null) {
      setState(() {
        records = recordsJson
            .map((json) => DayRecord.fromJson(jsonDecode(json)))
            .toList();
      });
    }
  }

  void navigateToPayrollPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Payroll(records: records)));
  }
}
