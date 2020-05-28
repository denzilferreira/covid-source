import 'dart:convert';
import 'package:http/http.dart' as http;

///Fetch async latest data from pomber repository
Future<Map<String, dynamic>> getLatestData() async {
  final response =
      await http.get('https://pomber.github.io/covid19/timeseries.json');
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else
    return null;
}