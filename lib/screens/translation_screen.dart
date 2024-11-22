import 'package:flutter/material.dart';
import '../services/translation_service.dart';
import '../services/history_service.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({Key? key}) : super(key: key);

  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _controller = TextEditingController();
  late final TranslationService _translationService;
  late final HistoryService _historyService;
  String _translatedText = '';
  String _selectedSourceLanguage = 'en';
  String _selectedTargetLanguage = 'es';

  static const List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
  ];

  @override
  void initState() {
    super.initState();
    _translationService = TranslationService('YOUR_API_KEY');
    _historyService = HistoryService();
  }

  void _translate() async {
    final text = _controller.text;
    if (text.isNotEmpty) {
      try {
        final translated = await _translationService.translateText(text, _selectedSourceLanguage, _selectedTargetLanguage);
        setState(() {
          _translatedText = translated;
        });
        await _historyService.addTranslation(text, translated);
      } catch (e) {
        setState(() {
          _translatedText = 'Translation failed: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translate Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _selectedSourceLanguage,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSourceLanguage = newValue!;
                    });
                  },
                  items: _languages.map<DropdownMenuItem<String>>((Map<String, String> language) {
                    return DropdownMenuItem<String>(
                      value: language['code'],
                      child: Text(language['name']!),
                    );
                  }).toList(),
                ),
                const Icon(Icons.swap_horiz),
                DropdownButton<String>(
                  value: _selectedTargetLanguage,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTargetLanguage = newValue!;
                    });
                  },
                  items: _languages.map<DropdownMenuItem<String>>((Map<String, String> language) {
                    return DropdownMenuItem<String>(
                      value: language['code'],
                      child: Text(language['name']!),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter text to translate',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _translate,
              child: const Text('Translate'),
            ),
            const SizedBox(height: 20),
            Text(_translatedText),
          ],
        ),
      ),
    );
  }
}
