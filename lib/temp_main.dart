import 'package:flutter/material.dart';
import 'models/user_role.dart';

void main() {
  // Set a default role for testing
  runApp(const PMAjayApp(initialRole: UserRoleType.publicViewer));
}

class PMAjayApp extends StatelessWidget {
  final UserRoleType initialRole;
  
  const PMAjayApp({
    super.key,
    required this.initialRole,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PM-AJAY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('PM-AJAY Dashboard'),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
                Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
                Tab(icon: Icon(Icons.settings), text: 'Settings'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text('Dashboard for ${initialRole.toString().split('.').last}')),
              const Center(child: Text('Analytics')),
              const Center(child: Text('Settings')),
            ],
          ),
        ),
      ),
    );
  }
}
