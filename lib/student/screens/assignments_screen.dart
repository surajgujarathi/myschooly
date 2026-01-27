import 'package:flutter/material.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Assignments'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Submitted'),
              Tab(text: 'Graded'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAssignmentList(status: 'Pending'),
            _buildAssignmentList(status: 'Submitted'),
            _buildAssignmentList(status: 'Graded'),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentList({required String status}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: const Icon(Icons.assignment, color: Colors.blue),
            ),
            title: Text('$status Assignment ${index + 1}'),
            subtitle: const Text('Mathematics • Due Tomorrow'),
            trailing: status == 'Pending' 
              ? const Chip(label: Text('Submit'), backgroundColor: Colors.blue, labelStyle: TextStyle(color: Colors.white))
              : Text(status == 'Graded' ? 'A' : 'Done'),
          ),
        );
      },
    );
  }
}
