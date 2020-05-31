import 'package:charts_flutter/flutter.dart' as charts;
import 'package:encounter/services/covid_data.dart';
import 'package:flutter/material.dart';

class CovidStats extends StatelessWidget {
  List<Report> countryReports;

  CovidStats(this.countryReports);

  @override
  Widget build(BuildContext context) {
    final List<charts.Series> seriesList = _generatePlot();
    return new charts.TimeSeriesChart(
      seriesList,
      animate: true,
      animationDuration: Duration(seconds: 2),
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      behaviors: [new charts.SeriesLegend(position: charts.BehaviorPosition.bottom)],
    );
  }

  List<charts.Series<Report, DateTime>> _generatePlot() {
    return [
      new charts.Series<Report, DateTime>(
          id: 'country_chart_confirmed',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (Report report, _) => report.date,
          measureFn: (Report report, _) => report.confirmed,
          data: countryReports,
          displayName: "Confirmed"),
      new charts.Series<Report, DateTime>(
          id: 'country_chart_recovered',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (Report report, _) => report.date,
          measureFn: (Report report, _) => report.recovered,
          data: countryReports,
          displayName: "Recovered"),
      new charts.Series<Report, DateTime>(
          id: 'country_chart_deaths',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (Report report, _) => report.date,
          measureFn: (Report report, _) => report.deaths,
          data: countryReports,
          displayName: "Deaths")
    ];
  }
}

Future<CovidStats> getCovidChart(
    List<Country> countriesData, String countrySelected) async {
  return CovidStats(countriesData
      .firstWhere((element) => element.country.compareTo(countrySelected) == 0)
      .reports);
}
