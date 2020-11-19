import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

part 'covid_data.g.dart';

///Fetch async latest data from JSON repository
Future<bool> getLatestData() async {
  var countries = await Hive.openBox<Country>('countries');
  countries.clear();

  var reports = await Hive.openBox<Report>('reports');
  reports.clear();

  final response =
      await http.get('https://pomber.github.io/covid19/timeseries.json');
  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);

    for (String country in data.keys) {
      print("Processing: $country");

      var countryObj = Country(country: country);
      countryObj.reports = HiveList(reports);

      List<Report> reportsObs =
          List<Report>.from(data[country].map((item) => Report.fromJson(item)));
      
      for(int i=0; i<reportsObs.length; i++) {
        var dayReport = reportsObs.elementAt(i);
        reports.put(dayReport.date.toIso8601String(), dayReport);

        countryObj.reports.add(dayReport);
      }

      print("$country has ${countryObj.reports.length} reports");

      countries.put(country, countryObj);
    }
    return true;
  } else
    return false;
}

@HiveType(typeId: 0)
class Country extends HiveObject {
  @HiveField(0)
  String country;
  @HiveField(1)
  HiveList<Report> reports;

  Country({this.country, this.reports});
}

@HiveType(typeId: 1)
class Report extends HiveObject {
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  int deaths;
  @HiveField(2)
  int recovered;
  @HiveField(3)
  int confirmed;

  Report({this.date, this.confirmed, this.deaths, this.recovered});

  factory Report.fromJson(Map<String, dynamic> json) {
    List<String> tempDate = json['date'].toString().split("-");
    return Report(
        date: new DateTime(int.parse(tempDate[0]), int.parse(tempDate[1]),
            int.parse(tempDate[2])),
        confirmed: json['confirmed'],
        deaths: json['deaths'],
        recovered: json['recovered']);
  }
}
