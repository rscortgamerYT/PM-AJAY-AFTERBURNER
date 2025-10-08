import 'package:flutter/material.dart';
import '../../widgets/communication_hub_button.dart';
import '../../models/user_role.dart';

class CommunicationHubDemo extends StatefulWidget {
  const CommunicationHubDemo({super.key});

  @override
  State<CommunicationHubDemo> createState() => _CommunicationHubDemoState();
}

class _CommunicationHubDemoState extends State<CommunicationHubDemo> {
  UserRole _selectedRole = UserRole.centreAdmin;
  int _unreadCount = 5;
  bool _hasUrgentNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communication Hub Demo'),
        backgroundColor: _getRoleColor(_selectedRole),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Communication Hub Controls',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Role Selection
                        const Text('Select User Role:'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: UserRole.values.where((role) => role != UserRole.publicViewer).map((role) {
                            return FilterChip(
                              label: Text(_getRoleLabel(role)),
                              selected: _selectedRole == role,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedRole = role;
                                  });
                                }
                              },
                              selectedColor: _getRoleColor(role).withOpacity(0.2),
                            );
                          }).toList(),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Unread Count
                        Row(
                          children: [
                            const Text('Unread Count:'),
                            const SizedBox(width: 16),
                            Slider(
                              value: _unreadCount.toDouble(),
                              min: 0,
                              max: 99,
                              divisions: 99,
                              label: _unreadCount.toString(),
                              onChanged: (value) {
                                setState(() {
                                  _unreadCount = value.round();
                                });
                              },
                            ),
                            Text(_unreadCount.toString()),
                          ],
                        ),
                        
                        // Urgent Notifications Toggle
                        SwitchListTile(
                          title: const Text('Has Urgent Notifications'),
                          subtitle: const Text('Shows pulsing red indicator'),
                          value: _hasUrgentNotifications,
                          onChanged: (value) {
                            setState(() {
                              _hasUrgentNotifications = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Role Information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _getRoleColor(_selectedRole),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${_getRoleLabel(_selectedRole)} Hub',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        const Text(
                          'Available Communication Channels:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        ..._getAvailableChannels(_selectedRole).map((channel) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.radio_button_checked,
                                size: 12,
                                color: _getRoleColor(_selectedRole),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                channel,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        )),
                        
                        const SizedBox(height: 16),
                        
                        const Text(
                          'Hub Features:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        ..._getHubFeatures().map((feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 12,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                feature,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Instructions
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue[700],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'How to Use',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text('• Tap the floating Hub button to open the Communication Hub'),
                        const Text('• Long press the Hub button to see quick access menu'),
                        const Text('• The button shows unread count and urgent indicators'),
                        const Text('• Each role has different colored themes and available channels'),
                        const Text('• The Hub provides secure inter-level communication'),
                      ],
                    ),
                  ),
                ),
                
                // Add some bottom padding to avoid overlap with the floating button
                const SizedBox(height: 100),
              ],
            ),
          ),
          
          // Communication Hub Button
          CommunicationHubButton(
            userRole: _selectedRole,
            unreadCount: _unreadCount,
            hasUrgentNotifications: _hasUrgentNotifications,
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.centreAdmin:
        return const Color(0xFF3F51B5); // Indigo
      case UserRole.stateOfficer:
        return const Color(0xFF1976D2); // Blue
      case UserRole.agencyUser:
        return const Color(0xFF26A69A); // Teal
      case UserRole.auditor:
        return const Color(0xFF7B1FA2); // Purple
      case UserRole.publicViewer:
        return const Color(0xFF388E3C); // Green
    }
  }

  String _getRoleLabel(UserRole role) {
    switch (role) {
      case UserRole.centreAdmin:
        return 'Centre Admin';
      case UserRole.stateOfficer:
        return 'State Officer';
      case UserRole.agencyUser:
        return 'Agency User';
      case UserRole.auditor:
        return 'Auditor';
      case UserRole.publicViewer:
        return 'Public Viewer';
    }
  }

  List<String> _getAvailableChannels(UserRole role) {
    switch (role) {
      case UserRole.centreAdmin:
        return [
          'Centre ↔ All States',
          'Centre ↔ Auditors',
          'Policy Discussions',
          'Emergency Alerts'
        ];
      case UserRole.stateOfficer:
        return [
          'State ↔ Centre',
          'State ↔ Agencies',
          'Inter-State Coordination',
          'Regional Updates'
        ];
      case UserRole.agencyUser:
        return [
          'Agency ↔ State',
          'Agency ↔ Auditors',
          'Field Operations',
          'Project Updates'
        ];
      case UserRole.auditor:
        return [
          'Auditor ↔ Centre',
          'Auditor ↔ States',
          'Auditor ↔ Agencies',
          'Compliance Alerts'
        ];
      case UserRole.publicViewer:
        return ['Public Forum'];
    }
  }

  List<String> _getHubFeatures() {
    return [
      'Real-time Messaging',
      'Ticket Management',
      'Document Sharing',
      'Meeting Scheduler',
      'Smart Notifications',
      'Audit Trail',
      'Role-based Access',
      'File Attachments',
      'Search & Filter',
      'Mobile Responsive'
    ];
  }
}
