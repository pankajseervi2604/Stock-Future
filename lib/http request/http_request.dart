import 'dart:convert';
import 'package:http/http.dart' as http;

Future<double> fetchStockPrediction(List<double> features) async {
  final response = await http.post(
    Uri.parse('http://<YOUR_FLASK_API_URL>/predict'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'features': features,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['prediction'];
  } else {
    throw Exception('Failed to load prediction');
  }
}