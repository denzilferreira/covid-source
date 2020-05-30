import 'dart:convert';
import 'package:http/http.dart' as http;

///Fetch async latest data from pomber repository
Future<List<Country>> getLatestData() async {
  final response = await http.get('https://pomber.github.io/covid19/timeseries.json');
  if (response.statusCode == 200) {
    List<Country> countriesData = new List();
    Map<String, dynamic> data = jsonDecode(response.body);
    for(String country in data.keys) {
      List<Report> reports =
      List<Report>.from(data[country].map((item) => Report.fromJson(item)));
      countriesData.add(new Country(country: country, reports: reports));
    }
    return countriesData;
  } else
    return null;
}

class Country {
  String country;
  List<Report> reports;
  Country({this.country, this.reports});
}

class Report {
  DateTime date;
  int deaths;
  int recovered;
  int confirmed;

  Report({this.date, this.confirmed, this.deaths, this.recovered});

  factory Report.fromJson(Map<String, dynamic> json) {
    List<String> tempDate = json['date'].toString().split("-");
    return Report(
        date: new DateTime(int.parse(tempDate[0]), int.parse(tempDate[1]), int.parse(tempDate[2])),
        confirmed: json['confirmed'],
        deaths: json['deaths'],
        recovered: json['recovered']
    );
  }
}