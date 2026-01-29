import 'package:flutter/material.dart';
import 'package:myschooly/src/utils/colorsconstants.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        title: const Text('Reports & Stats'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(child: Text('Attendance Chart Placeholder')),
            ),
            const SizedBox(height: 24),
            const ListTile(
              title: Text('Academic Achievement'),
              subtitle: Text('Best Performer in Mathematics'),
              leading: Icon(Icons.emoji_events, color: Colors.amber, size: 32),
            ),
            const Divider(),
            ListTile(
              title: const Text('Download Report Card'),
              leading: const Icon(
                Icons.download_for_offline,
                color: Colors.blue,
                size: 32,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
