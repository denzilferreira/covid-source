import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    List<Series<Report, String>> series = [
      Series(
        data: widget.reports,
        id: "Confirmed",
        domainFn: (datum, index) => "${datum.date.month}",
        measureFn: (datum, index) => datum.confirmed,
        colorFn: (datum, index) => ColorUtil.fromDartColor(Colors.grey),
      ),
      Series(
        data: widget.reports,
        id: "Recovered",
        domainFn: (datum, index) => "${datum.date.month}",
        measureFn: (datum, index) => datum.recovered,
        colorFn: (datum, index) => ColorUtil.fromDartColor(Colors.green),
      ),
      Series(
        data: widget.reports,
        id: "Deaths",
        domainFn: (datum, index) => "${datum.date.month}",
        measureFn: (datum, index) => datum.deaths,
        colorFn: (datum, index) => ColorUtil.fromDartColor(Colors.red),
      ),
    ];

    return BarChart(
      series,
      animate: true,
      defaultInteractions: true,
      primaryMeasureAxis: NumericAxisSpec(
          tickFormatterSpec: BasicNumericTickFormatterSpec.fromNumberFormat(
              NumberFormat.compact())),
    );
  }
}
