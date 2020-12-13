import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'database/covid_data.dart';

///Given a country, return the weekly reports
class CovidMonthView extends StatefulWidget {
  final String country;
  final List<Report> reports;
  const CovidMonthView(
      {Key key, @required this.country, @required this.reports})
      : super(key: key);

  @override
  _CovidMonthViewState createState() => _CovidMonthViewState();
}

class _CovidMonthViewState extends State<CovidMonthView> {
  @override
  Widget build(BuildContext context) {
    List<charts.Series<Report, String>> series = [
      charts.Series(
        data: widget.reports,
        id: "Confirmed",
        domainFn: (datum, index) => "${datum.date.month}",
        measureFn: (datum, index) => datum.confirmed,
        colorFn: (datum, index) => charts.ColorUtil.fromDartColor(Colors.grey),
      ),
      charts.Series(
        data: widget.reports,
        id: "Recovered",
        domainFn: (datum, index) => "${datum.date.month}",
        measureFn: (datum, index) => datum.recovered,
        colorFn: (datum, index) => charts.ColorUtil.fromDartColor(Colors.green),
      ),
      charts.Series(
        data: widget.reports,
        id: "Deaths",
        domainFn: (datum, index) => "${datum.date.month}",
        measureFn: (datum, index) => datum.deaths,
        colorFn: (datum, index) => charts.ColorUtil.fromDartColor(Colors.red),
      ),
    ];

    return charts.BarChart(
      series,
      animate: true,
    );
  }
}
