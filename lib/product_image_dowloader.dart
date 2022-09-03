import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

Future<String> getImage(String code) async {
  final url = Uri.https(
    'krukam.pl',
    'search.php',
    {
      'xmlType': 'typeahead',
      'getProductXML': 'true',
      'json': 'true',
      'text': code,
      'limit': '6',
    },
  );

  final headers = {
    "Accept": "application/json",
    "Access-Control_Allow_Origin": "*",
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final jsonResponse = convert.jsonDecode(response.body);
    String url = "https://krukam.pl${jsonResponse['products'][0]['icon_src']}";
    return url;
  } else {
    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}
