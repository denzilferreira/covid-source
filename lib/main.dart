import 'package:encounter/covid_month_view.dart';
import 'package:encounter/recommendations/hand_gel.dart';
import 'package:encounter/recommendations/official_info.dart';
import 'package:encounter/recommendations/social_distancing.dart';
import 'package:encounter/recommendations/symptoms_aware.dart';
import 'package:encounter/recommendations/wash_hands.dart';
import 'package:encounter/recommendations/wear_mask.dart';
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
  String _country = "";
  String _cases = "";
  String _recovered = "";
  String _died = "";

  final cardsController = PageController(initialPage: 1, viewportFraction: .8);

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
    if (defaultCountry != null) {
      var defaultCountryData = await getCountryReports(defaultCountry);
      setState(() {
        _country = defaultCountry;
        _reports = defaultCountryData;
        _cases = _reports.last.confirmed.toString();
        _recovered = _reports.last.recovered.toString();
        _died = _reports.last.deaths.toString();
      });
    }

    setState(() {
      _countries = countries;
    });
  }

  void setDefault(String defaultCountry) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("defaultCountry", defaultCountry);

    var countryData = await getCountryReports(defaultCountry);

    setState(() {
      _country = defaultCountry;
      _reports = countryData;
      _cases = _reports.last.confirmed.toString();
      _recovered = _reports.last.recovered.toString();
      _died = _reports.last.deaths.toString();
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
                        Icons.arrow_drop_down_sharp,
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
              Visibility(
                child: Padding(
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
                              Text(
                                _cases,
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 20),
                              ),
                              Text("Cases".toUpperCase(),
                                  style: GoogleFonts.roboto(
                                      letterSpacing: 1.5, fontSize: 10)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(_recovered,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 20)),
                              Text("Recovered".toUpperCase(),
                                  style: GoogleFonts.roboto(
                                      letterSpacing: 1.5, fontSize: 10)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(_died,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 20)),
                              Text("Died".toUpperCase(),
                                  style: GoogleFonts.roboto(
                                      letterSpacing: 1.5, fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                visible: (_cases.length > 0),
              ),
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    height: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: CovidMonthView(
                        country: _country,
                        reports: _reports,
                      ),
                    ),
                  ),
                ),
                visible: (_country.length > 0),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24, top: 16),
                child: Text("WHO Recommendations",
                    style: GoogleFonts.roboto(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              Container(
                height: 120,
                child: PageView(
                  children: [
                    WashHands(),
                    WearMask(),
                    HandGel(),
                    SymptomsAware(),
                    SocialDistancing(),
                    OfficialInfo()
                  ],
                  onPageChanged: (value) {},
                  controller: cardsController,
                  allowImplicitScrolling: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
