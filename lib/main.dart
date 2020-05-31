import 'services/covid_data.dart';
import 'ui/stats_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EncounterApp());
}

class EncounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encounter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: EncounterHome(title: 'Encounter'),
    );
  }
}

class EncounterHome extends StatefulWidget {
  EncounterHome({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EncounterHomeState createState() => _EncounterHomeState();
}

class _EncounterHomeState extends State<EncounterHome> {
  ///selected country by default
  String selectedCountry = "Finland";
  List<Country> countriesData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Hello there",
                        textAlign: TextAlign.left, textScaleFactor: 1.5),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                        "Encounter allows you to anonymously help health officials do pandemic tracking and cutting the chain of transmission.",
                        textAlign: TextAlign.justify),
                  ),

                  FutureBuilder<List<Country>>(
                    future: getLatestData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        countriesData = snapshot.data;

                        return DropdownButton<String>(
                          value: selectedCountry,
                          autofocus: true,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 0,
                            color: Colors.blue,
                          ),
                          onChanged: (String newCountry) {
                            setState(() {
                              selectedCountry = newCountry;
                              print(selectedCountry);
                            });
                          },
                          items: snapshot.data
                              .map<DropdownMenuItem<String>>((Country country) {
                            return DropdownMenuItem<String>(
                              child:
                                  Text(country.country, textScaleFactor: 1.2),
                              value: country.country,
                            );
                          }).toList(),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: getCovidChart(countriesData, selectedCountry),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height/1.8,
                          child: snapshot.data,
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
                ],
              ))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            title: Text('Stats'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline), title: Text('Encounters'))
        ],
      ),
    );
  }
}
