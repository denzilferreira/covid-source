import 'package:charts_flutter/flutter.dart' as charts;
import 'package:encounter/services/covid_data.dart';
import 'package:flutter/material.dart';

class CovidStats extends StatelessWidget {

  List<Report> countryReports;

  CovidStats(this.countryReports);

  @override
  Widget build(BuildContext context) {
    final List<charts.Series> seriesList = _generatePlot();
    return new charts.TimeSeriesChart(seriesList, animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory());
  }

  List<charts.Series<Report, DateTime>> _generatePlot() {
    return [
      new charts.Series<Report, DateTime>(
        id: 'Cases',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Report report, _) => report.date,
        measureFn: (Report report, _) => report.confirmed,
        data: countryReports)
    ];
  }
}

Future<CovidStats> getCovidChart(List<Country> countriesData, String countrySelected) async {
  return CovidStats(countriesData.firstWhere((element) => element.country.compareTo(countrySelected)==0).reports);
}

