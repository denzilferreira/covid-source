import 'package:encounter/covid_month_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/covid_data.dart';

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
  String _country;
  String _cases = "";
  String _recovered = "";
  String _died = "";

  var _countries = <DropdownMenuItem>[];
  var _reports = <Report>[];

  void initialiseDatabase() async {
    Hive.registerAdapter(CountryAdapter());
    Hive.registerAdapter(ReportAdapter());
    await Hive.initFlutter();
    await getLatestData();

    var dbCountries = await getCountries();
    var countries = <DropdownMenuItem>[];

    for (Country country in dbCountries) {
      var dropDown = DropdownMenuItem(
        value: country.country,
        child: Text(
          country.country,
          style: GoogleFonts.roboto(
              color: Colors.black, letterSpacing: 1.5, fontSize: 16),
        ),
      );
      countries.add(dropDown);
    }

    var prefs = await SharedPreferences.getInstance();
    var defaultCountry = prefs.getString("defaultCountry");
    var defaultCountryData = await getCountryReports(defaultCountry);

    setState(() {
      _countries = countries;

      if (defaultCountry != null) {
        _country = defaultCountry;
        _reports = defaultCountryData;
      }
    });
  }

  void setDefault(String defaultCountry) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("defaultCountry", defaultCountry);

    var countryData = await getCountryReports(defaultCountry);

    setState(() {
      _country = defaultCountry;
      _reports = countryData;
    });
  }

  @override
  void initState() {
    initialiseDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
              child: SafeArea(
          minimum: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text("Statistics",
                    style: GoogleFonts.roboto(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: DropdownButton(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.blue,
                      ),
                      isExpanded: true,
                      style: GoogleFonts.roboto(fontSize: 14),
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      hint: Text(
                        "Pick a country",
                        style: GoogleFonts.roboto(
                            letterSpacing: 1.5, fontSize: 16),
                      ),
                      value: _country,
                      items: _countries,
                      onChanged: (selectedCountry) {
                        setDefault(selectedCountry);
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white),
                  padding: EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(_cases),
                            Text("Cases"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(_recovered),
                            Text("Recovered"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(_died),
                            Text("Died"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CovidMonthView(
                      country: _country,
                      reports: _reports,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
