import 'package:flutter/material.dart';
import 'dashboards/centre_dashboard.dart';
import 'dashboards/state_dashboard.dart';
import 'dashboards/agency_dashboard.dart';
import 'dashboards/auditor_dashboard.dart';
import 'dashboards/public_dashboard.dart';
import 'models/user_role.dart';

void main() {
  runApp(const PMAjayApp());
}

class PMAjayApp extends StatelessWidget {
  const PMAjayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PM-AJAY - Pradhan Mantri Anusuchit Jaati Abhyuday Yojana',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        primaryColor: const Color(0xFF3F51B5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F51B5),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3F51B5),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PM-AJAY Portal'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF3F51B5).withOpacity(0.1),
                    const Color(0xFF3F51B5).withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to PM-AJAY',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F51B5),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Pradhan Mantri Anusuchit Jaati Abhyuday Yojana',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'A comprehensive platform for managing and monitoring development projects across India.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Role Selection
            const Text(
              'Select Your Role',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildRoleCard(
                  context,
                  'Centre Admin',
                  Icons.account_balance,
                  const Color(0xFF3F51B5),
                  'Manage nationwide operations',
                ),
                _buildRoleCard(
                  context,
                  'State Officer',
                  Icons.location_city,
                  const Color(0xFF1976D2),
                  'State-level coordination',
                ),
                _buildRoleCard(
                  context,
                  'Agency User',
                  Icons.business,
                  const Color(0xFF26A69A),
                  'Project implementation',
                ),
                _buildRoleCard(
                  context,
                  'Auditor',
                  Icons.verified,
                  const Color(0xFF7B1FA2),
                  'Compliance & verification',
                ),
                _buildRoleCard(
                  context,
                  'Public Portal',
                  Icons.public,
                  const Color(0xFF388E3C),
                  'Citizen services',
                ),
                _buildRoleCard(
                  context,
                  'Communication Hub',
                  Icons.forum,
                  const Color(0xFFFF5722),
                  'Inter-level messaging',
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Features Overview
            const Text(
              'Key Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureList(),
            
            const SizedBox(height: 32),
            
            // Statistics
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Platform Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('2,450+', 'Projects'),
                      _buildStatItem('28', 'States'),
                      _buildStatItem('450+', 'Agencies'),
                      _buildStatItem('₹15,000 Cr', 'Investment'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, String title, IconData icon, Color color, String description) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToRole(context, title),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      'Real-time project tracking and monitoring',
      'Inter-level communication and collaboration',
      'Fund allocation and transparency',
      'Compliance verification and auditing',
      'Public request submission and tracking',
      'Interactive maps and data visualization',
      'Document management and version control',
      'Automated notifications and alerts',
    ];

    return Column(
      children: features.map((feature) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF3F51B5),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                feature,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3F51B5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _navigateToRole(BuildContext context, String role) {
    Widget destination;

    switch (role) {
      case 'Centre Admin':
        destination = const CentreDashboard();
        break;
      
      case 'State Officer':
        destination = const StateDashboard(stateName: 'Maharashtra');
        break;
      
      case 'Agency User':
        destination = const AgencyDashboard(agencyName: 'Infrastructure Development Agency');
        break;
      
      case 'Auditor':
        destination = const AuditorDashboard(auditorName: 'Dr. Audit Sharma');
        break;
      
      case 'Public Portal':
        destination = const PublicDashboard();
        break;
      
      case 'Communication Hub':
        destination = const CentreDashboard(); // Using centre dashboard for communication hub
        break;
      
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$role - Feature not implemented')),
        );
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
