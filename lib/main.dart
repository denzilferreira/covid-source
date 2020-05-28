import 'services/covid_data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encounter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Encounter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ///selected country by default
  String selectedCountry = "Finland";

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
                    child: Text("Hello there", textAlign: TextAlign.left,
                        textScaleFactor: 1.5),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                        "Encounter allows you to anonymously help health officials do pandemic tracking and cutting the chain of transmission.",
                        textAlign: TextAlign.justify),
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: getLatestData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {

                        return DropdownButton<String>(
                          value: selectedCountry,
                          autofocus: true,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Colors.blue,
                          ),
                          onChanged: (String newCountry) {
                            setState(() {
                              selectedCountry = newCountry;
                            });
                          },
                          items: snapshot.data.keys.map<DropdownMenuItem<String>>((String country) {
                            return DropdownMenuItem<String>(
                              value: country,
                              child: Text(country),
                            );
                          }).toList(),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                ],
              )
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            title: Text('Stats'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              title: Text('Encounters')
          )
        ],
      ),
    );
  }
}
