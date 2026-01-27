// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myschooly/src/utils/appconstants.dart' as AppColor;

class StudentLayout extends StatefulWidget {
  final Widget child;
  const StudentLayout({super.key, required this.child});

  @override
  State<StudentLayout> createState() => _StudentLayoutState();
}

class _StudentLayoutState extends State<StudentLayout> {
  int _selectedIndex = 0;

  final List<String> _routes = [
    '/student',
    '/student/timetable',
    '/student/assignments',
    '/student/messages',
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
    context.go(_routes[index]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/student/messages')) {
      _selectedIndex = 3;
    } else if (location.startsWith('/student/assignments'))
      _selectedIndex = 2;
    else if (location.startsWith('/student/timetable'))
      _selectedIndex = 1;
    else
      _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,

      // ✅ FULL-WIDTH STICKY BOTTOM NAV
      bottomNavigationBar: NavigationBar(
        height: 68,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: Colors.white,
        indicatorColor: AppColor.primaryLight,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.dashboard, color: AppColor.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.calendar_today, color: AppColor.primary),
            label: 'Timetable',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.assignment, color: AppColor.primary),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.chat_bubble, color: AppColor.primary),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
