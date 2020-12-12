import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'database/covid_data.dart';

import 'package:charts_flutter/flutter.dart' as charts;

///Given a country, return the weekly reports
class CovidWeek extends StatelessWidget {
  
  final String country;
  const CovidWeek({Key key, @required this.country}) : super(key: key);

  Future<List<charts.Series>> loadData() async {

    var db = await Hive.openBox<Country>('countries');
    var countryData = db.get(this.country);

    return [
      charts.Series<Report, String>(
        id: "New",
        domainFn: (Report report, _) => report.date.toIso8601String(),
        measureFn: (Report report, _) => report.confirmed,
        data: countryData.reports
      )
    ];    
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      loadData(),
      animate: true,
      barGroupingType: charts.BarGroupingType.stacked,
    );
  }
}