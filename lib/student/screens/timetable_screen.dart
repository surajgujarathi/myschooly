import 'package:flutter/material.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    return Scaffold(
      appBar: AppBar(title: const Text('Timetable')),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final isSelected = index == 0;
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Chip(
                    label: Text(days[index]),
                    backgroundColor: isSelected
                        ? Colors.blue
                        : Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.primaries[index % Colors.primaries.length]
                      .withOpacity(0.1),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(
                      '${9 + index}:00',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    title: Text('Subject ${index + 1}'),
                    subtitle: Text('Room ${100 + index} • Teacher Name'),
                    trailing: const Icon(Icons.more_vert),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
