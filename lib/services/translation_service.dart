import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String _apiUrl = 'https://translation.googleapis.com/language/translate/v2';

  final String apiKey;

  TranslationService(this.apiKey);

  Future<String> translateText(String text, String sourceLanguage, String targetLanguage) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'q': text,
          'source': sourceLanguage,
          'target': targetLanguage,
          'format': 'text',
        }),
      );

      print('Request URL: ${response.request!.url}');
      print('Request Headers: ${response.request!.headers}');
      print('Request Body: ${response.request!.body}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['translations'][0]['translatedText'];
      } else {
        print('Failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to translate text: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to translate text: $e');
    }
  }
}

extension on http.BaseRequest {
  get body => null;
}
