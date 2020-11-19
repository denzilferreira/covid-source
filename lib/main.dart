import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'services/covid_data.dart';
import 'ui/stats_chart.dart';

void main() {
  runApp(EncounterApp());
}

class EncounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Encounter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: EncounterHome(),
    );
  }
}

class EncounterHome extends StatefulWidget {
  @override
  _EncounterHomeState createState() => _EncounterHomeState();
}

class _EncounterHomeState extends State<EncounterHome> {

  void initialiseDatabase() async {
    Hive.registerAdapter(CountryAdapter());
    Hive.registerAdapter(ReportAdapter());

    await Hive.initFlutter();
    await getLatestData();
  }

  @override
  void initState() {
    initialiseDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Encounter"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Hello")
          ],
        ),
      ),
    );
  }
}
