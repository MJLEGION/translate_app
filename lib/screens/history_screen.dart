import 'package:flutter/material.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryService historyService = HistoryService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation History'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: historyService.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load history'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No history available'));
          } else {
            final history = snapshot.data!;
            return ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history[index];
                return ListTile(
                  title: Text(entry['original']!),
                  subtitle: Text(entry['translated']!),
                );
              },
            );
          }
        },
      ),
    );
  }
}
