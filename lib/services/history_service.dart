import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryService {
  static const _historyKey = 'translation_history';

  Future<List<Map<String, String>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString(_historyKey);
    if (historyString != null) {
      final List history = json.decode(historyString);
      return history.map((item) => Map<String, String>.from(item)).toList();
    }
    return [];
  }

  Future<void> addTranslation(String originalText, String translatedText) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, String>> history = await getHistory();
    history.add({
      'original': originalText,
      'translated': translatedText,
    });
    await prefs.setString(_historyKey, json.encode(history));
  }
}
