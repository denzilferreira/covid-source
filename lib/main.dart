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
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'database/covid_data.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(CountryAdapter());
  Hive.registerAdapter(ReportAdapter());

  await Hive.openBox<Country>('countries');
  await Hive.openBox<Report>('reports');

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
  String _newCases = "";
  String _recovered = "";
  String _newRecovered = "";
  String _died = "";
  String _newDied = "";

  List<DropdownMenuItem> _countries;
  List<Report> _reports;

  final cardsController = PageController(initialPage: 1, viewportFraction: .8);

  void initialiseDatabase() async {
    List<Country> dbCountries = await getCountries();
    List<DropdownMenuItem> countries = [];
    // Create dropdown options
    for (Country country in dbCountries) {
      var dropDown = DropdownMenuItem(
        value: country.country,
        child: Text(
          country.country,
          style: GoogleFonts.roboto(
              color: Colors.black, letterSpacing: 1.5, fontSize: 14),
        ),
      );
      countries.add(dropDown);
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
      _reports = countryData;
      _cases = _reports.last.confirmed.toString();
      _newCases = (_reports.elementAt(_reports.length-1).confirmed -
              _reports.elementAt(_reports.length-2).confirmed)
          .toString();
      _recovered = _reports.last.recovered.toString();
      _newRecovered = (_reports.elementAt(_reports.length-1).recovered -
          _reports.elementAt(_reports.length-2).recovered)
          .toString();
      _died = _reports.last.deaths.toString();
      _newDied = (_reports.elementAt(_reports.length-1).deaths -
          _reports.elementAt(_reports.length-2).deaths)
          .toString();
    });
  }

  void loadPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    var defaultCountry = prefs.getString("defaultCountry");
    if (defaultCountry != null) {
      var defaultCountryData = await getCountryReports(defaultCountry);
      setState(() {
        _country = defaultCountry;
        _reports = defaultCountryData;
        _cases = _reports.last.confirmed.toString();
        _newCases = (_reports.elementAt(_reports.length-1).confirmed -
            _reports.elementAt(_reports.length-2).confirmed)
            .toString();
        _recovered = _reports.last.recovered.toString();
        _newRecovered = (_reports.elementAt(_reports.length-1).recovered -
            _reports.elementAt(_reports.length-2).recovered)
            .toString();
        _died = _reports.last.deaths.toString();
        _newDied = (_reports.elementAt(_reports.length-1).deaths -
            _reports.elementAt(_reports.length-2).deaths)
            .toString();
      });
    }
  }

  void syncData() async {
    await getLatestData();
  }

  @override
  void initState() {
    initialiseDatabase();
    loadPreferences();
    syncData();
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
                    padding: const EdgeInsets.all(16),
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
                        _country = selectedCountry;
                        setDefault(selectedCountry);
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text("Totals",
                    style: GoogleFonts.roboto(
                        fontSize: 24, fontWeight: FontWeight.bold)),
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
                                    color: Colors.black,
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
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text("Trends",
                    style: GoogleFonts.roboto(
                        fontSize: 24, fontWeight: FontWeight.bold)),
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
                            Text(
                              _newCases,
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20),
                            ),
                            Text("New Cases".toUpperCase(),
                                style: GoogleFonts.roboto(
                                    letterSpacing: 1.5, fontSize: 10)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(_newRecovered,
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 20)),
                            Text("New Recovered".toUpperCase(),
                                style: GoogleFonts.roboto(
                                    letterSpacing: 1.5, fontSize: 10)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(_newDied,
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 20)),
                            Text("New Died".toUpperCase(),
                                style: GoogleFonts.roboto(
                                    letterSpacing: 1.5, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                child: Text("Recommendations",
                    style: GoogleFonts.roboto(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              Container(
                height: 180,
                child: PageView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: WashHands(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: WearMask(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HandGel(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SymptomsAware(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SocialDistancing(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OfficialInfo(),
                    )
                  ],
                  onPageChanged: (value) {},
                  controller: cardsController,
                ),
              ),
              Container(
                alignment: Alignment.center,
                child:
                    SmoothPageIndicator(controller: cardsController, count: 6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
