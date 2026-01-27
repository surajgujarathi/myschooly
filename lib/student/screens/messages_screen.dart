import 'package:flutter/material.dart';
import 'package:myschooly/src/utils/appconstants.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(backgroundColor: white, title: const Text('Messages')),
      body: ListView.separated(
        itemCount: 10,
        separatorBuilder: (c, i) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=${index + 20}',
              ),
            ),
            title: Text('Teacher ${index + 1}'),
            subtitle: const Text('Please submit your assignment by tomorrow.'),
            trailing: Text('10:${index}0 AM'),
          );
        },
      ),
    );
  }
}
