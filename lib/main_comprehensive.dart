import 'package:flutter/material.dart';
import 'dashboards/centre_dashboard.dart';
import 'dashboards/state_dashboard.dart';
import 'dashboards/agency_dashboard.dart';
import 'dashboards/public_dashboard.dart';

void main() {
  runApp(const PMAjayComprehensiveApp());
}

class PMAjayComprehensiveApp extends StatelessWidget {
  const PMAjayComprehensiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PM-AJAY - Comprehensive Digital Governance Platform',
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
      home: const ComprehensiveHomePage(),
    );
  }
}

class ComprehensiveHomePage extends StatelessWidget {
  const ComprehensiveHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PM-AJAY Digital Governance Platform'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageSelector(context),
            tooltip: 'Language / भाषा',
          ),
          IconButton(
            icon: const Icon(Icons.accessibility),
            onPressed: () => _showAccessibilityOptions(context),
            tooltip: 'Accessibility Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header with AI Assistant
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome to PM-AJAY',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3F51B5),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Pradhan Mantri Anusuchit Jaati Abhyuday Yojana',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Comprehensive Digital Governance Platform with AI-powered insights, real-time collaboration, and transparent fund tracking.',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3F51B5).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.psychology,
                              size: 32,
                              color: Color(0xFF3F51B5),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'AI Assistant',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3F51B5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            ElevatedButton(
                              onPressed: () => _showAIAssistant(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3F51B5),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              ),
                              child: const Text('Ask AI', style: TextStyle(fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Role-Based Dashboard Selection
            const Text(
              'Select Your Dashboard',
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
              childAspectRatio: 1.1,
              children: [
                _buildComprehensiveRoleCard(
                  context,
                  'Centre Admin',
                  Icons.account_balance,
                  const Color(0xFF3F51B5),
                  'Comprehensive Control Hub',
                  [
                    'Scheme Configuration & PFMS Integration',
                    'Holistic State Request Management',
                    'Agency Onboarding & Verification',
                    'Global Fund Transparency Panel',
                    'AI-Powered Analytics & Insights',
                    'Interactive State Performance Maps',
                  ],
                ),
                _buildComprehensiveRoleCard(
                  context,
                  'State Officer',
                  Icons.location_city,
                  const Color(0xFF1976D2),
                  'State Operations Command',
                  [
                    'Geo-fenced Public Request Management',
                    'Agency Review & Task Assignment',
                    'State Fund Release Console',
                    'District Analytics & Heatmaps',
                    'AI Predictive Tools & Forecasting',
                    'State-Agency Collaboration Hub',
                  ],
                ),
                _buildComprehensiveRoleCard(
                  context,
                  'Agency User',
                  Icons.business,
                  const Color(0xFF26A69A),
                  'Project Execution Hub',
                  [
                    'Work Order Management System',
                    'Kanban & Gantt Project Views',
                    'Geo-tagged Evidence Uploads',
                    'Capabilities & Coverage Editor',
                    'Registration & Readiness Tracker',
                    'Real-time Fund Transparency',
                  ],
                ),
                _buildComprehensiveRoleCard(
                  context,
                  'Auditor',
                  Icons.verified,
                  const Color(0xFF7B1FA2),
                  'Audit & Compliance Center',
                  [
                    'Blockchain-like Fund Transfer Ledger',
                    'Evidence Audit Workspace',
                    'Compliance Checks Console',
                    'Audit Reports Builder',
                    'AI Risk & Predictive Analytics',
                    'Multi-stakeholder Communication',
                  ],
                ),
                _buildComprehensiveRoleCard(
                  context,
                  'Public Portal',
                  Icons.public,
                  const Color(0xFF388E3C),
                  'Citizen Engagement Platform',
                  [
                    'Interactive Public Project Map',
                    'Transparency Stats & Metrics',
                    'Impact Stories & Testimonials',
                    'Public Request & Grievance System',
                    'Participatory Budgeting Tools',
                    'Open Data API Access',
                  ],
                ),
                _buildComprehensiveRoleCard(
                  context,
                  'Collaboration Hub',
                  Icons.forum,
                  const Color(0xFFFF5722),
                  'Real-time Communication',
                  [
                    'Multi-party Video Conferences',
                    'Document Sharing & Version Control',
                    'Live Collaborative Editing',
                    'Ticketing & Escalation System',
                    'Committee Meeting Scheduler',
                    'Cross-role Chat Rooms',
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Platform Statistics
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
                    'Platform Impact Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('2,450+', 'Active Projects'),
                      _buildStatItem('28', 'States Connected'),
                      _buildStatItem('450+', 'Verified Agencies'),
                      _buildStatItem('₹15,000 Cr', 'Total Investment'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('1.2M+', 'Beneficiaries'),
                      _buildStatItem('95%', 'Success Rate'),
                      _buildStatItem('24/7', 'AI Support'),
                      _buildStatItem('100%', 'Transparency'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Key Features Overview
            const Text(
              'Advanced Platform Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureGrid(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAIAssistant(context),
        backgroundColor: const Color(0xFF3F51B5),
        icon: const Icon(Icons.smart_toy, color: Colors.white),
        label: const Text('AI Assistant', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildComprehensiveRoleCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String subtitle,
    List<String> features,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showRoleDetails(context, title, subtitle, features),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${features.length} Advanced Features',
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 1.0,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3F51B5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {'title': 'AI-Powered Insights', 'icon': Icons.psychology, 'color': Colors.purple},
      {'title': 'Real-time Collaboration', 'icon': Icons.people, 'color': Colors.blue},
      {'title': 'Offline-First Architecture', 'icon': Icons.offline_bolt, 'color': Colors.green},
      {'title': 'Blockchain Audit Trail', 'icon': Icons.security, 'color': Colors.orange},
      {'title': 'Multi-language Support', 'icon': Icons.translate, 'color': Colors.red},
      {'title': 'WCAG Accessibility', 'icon': Icons.accessibility, 'color': Colors.indigo},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (feature['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                feature['icon'] as IconData,
                size: 24,
                color: feature['color'] as Color,
              ),
              const SizedBox(height: 8),
              Text(
                feature['title'] as String,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRoleDetails(BuildContext context, String role, String subtitle, List<String> features) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            role,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3F51B5),
                            ),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Comprehensive Features:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...features.map((feature) => Padding(
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
                          style: const TextStyle(fontSize: 14, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _launchDashboard(context, role);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F51B5),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Launch Dashboard'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _launchDashboard(BuildContext context, String role) {
    Widget dashboard;
    
    switch (role) {
      case 'Centre Admin':
        dashboard = const CentreDashboard();
        break;
      case 'State Officer':
        dashboard = const StateDashboard(stateName: 'Maharashtra');
        break;
      case 'Agency User':
        dashboard = const AgencyDashboard(agencyName: 'Infrastructure Development Agency');
        break;
      case 'Auditor':
        dashboard = const CentreDashboard(); // Using centre dashboard for auditor
        break;
      case 'Public Portal':
        dashboard = const PublicDashboard();
        break;
      case 'Collaboration Hub':
        dashboard = const CentreDashboard(); // Using centre dashboard for collaboration hub
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$role dashboard not implemented yet')),
        );
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => dashboard),
    );
  }

  void _showAIAssistant(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF3F51B5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.psychology, color: Colors.white),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'PM-AJAY AI Assistant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'नमस्ते! I\'m your PM-AJAY AI Assistant. I can help you with:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Scheme Eligibility',
                        'Fund Status',
                        'Project Guidance',
                        'Document Requirements',
                        'Compliance Checks',
                        'Performance Analytics',
                      ].map((topic) => Chip(
                        label: Text(topic),
                        backgroundColor: const Color(0xFF3F51B5).withOpacity(0.1),
                        onDeleted: () {},
                        deleteIcon: const Icon(Icons.chat, size: 16),
                      )).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Available in 12+ Indian languages with voice support!',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language / भाषा चुनें'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'English', 'हिंदी', 'বাংলা', 'தமிழ்', 'తెలుగు', 'ಕನ್ನಡ', 'മലയാളം', 'ગુજરાતી'
          ].map((lang) => ListTile(
            title: Text(lang),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Language changed to $lang')),
              );
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showAccessibilityOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accessibility Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.contrast),
              title: Text('High Contrast Mode'),
              trailing: Switch(value: false, onChanged: null),
            ),
            ListTile(
              leading: Icon(Icons.text_fields),
              title: Text('Large Text'),
              trailing: Switch(value: false, onChanged: null),
            ),
            ListTile(
              leading: Icon(Icons.record_voice_over),
              title: Text('Screen Reader Support'),
              trailing: Icon(Icons.check, color: Colors.green),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}


  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'Centre Admin':
        return Icons.account_balance;
      case 'State Officer':
        return Icons.location_city;
      case 'Agency User':
        return Icons.business;
      case 'Auditor':
        return Icons.verified;
      case 'Public Portal':
        return Icons.public;
      default:
        return Icons.dashboard;
    }
  }
}
