import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../widgets/india_map_widget.dart';
import '../../widgets/communication_hub_button.dart';
import '../../models/user_role.dart';

class CentreAdminDashboard extends StatefulWidget {
  const CentreAdminDashboard({Key? key}) : super(key: key);

  @override
  State<CentreAdminDashboard> createState() => _CentreAdminDashboardState();
}

class _CentreAdminDashboardState extends State<CentreAdminDashboard> {
  // Sample data for nationwide heatmap
  final List<MapMarker> _stateMarkers = [
    MapMarker(
      id: 'maharashtra',
      position: const LatLng(19.7515, 75.7139),
      color: Colors.green,
      icon: Icons.location_city,
      count: 125,
      title: 'Maharashtra',
    ),
    MapMarker(
      id: 'karnataka',
      position: const LatLng(15.3173, 75.7139),
      color: Colors.blue,
      icon: Icons.location_city,
      count: 98,
      title: 'Karnataka',
    ),
    MapMarker(
      id: 'tamil_nadu',
      position: const LatLng(11.1271, 78.6569),
      color: Colors.orange,
      icon: Icons.location_city,
      count: 87,
      title: 'Tamil Nadu',
    ),
    MapMarker(
      id: 'uttar_pradesh',
      position: const LatLng(26.8467, 80.9462),
      color: Colors.purple,
      icon: Icons.location_city,
      count: 156,
      title: 'Uttar Pradesh',
    ),
  ];

  final List<GeofencePolygon> _stateGeofences = [
    GeofencePolygon(
      points: [
        const LatLng(22.0, 72.0),
        const LatLng(22.0, 80.0),
        const LatLng(16.0, 80.0),
        const LatLng(16.0, 72.0),
      ],
      color: Colors.green,
      label: 'Maharashtra',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centre Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotificationsPanel(),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildHomeSection(),
          // Communication Hub Button
          const CommunicationHubButton(
            userRole: UserRole.centreAdmin,
            unreadCount: 12,
            hasUrgentNotifications: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildHeroCard(
                  'Total Budget Disbursed',
                  '₹2,450 Cr',
                  Icons.currency_rupee,
                  Colors.green,
                  '+12% vs last quarter',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildHeroCard(
                  'States Pending Review',
                  '8',
                  Icons.pending_actions,
                  Colors.orange,
                  '3 high priority',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildHeroCard(
                  'Active Projects Nationwide',
                  '538',
                  Icons.work,
                  Colors.blue,
                  'Across 28 states',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildHeroCard(
                  'Flagged Alerts',
                  '16',
                  Icons.warning_amber,
                  Colors.red,
                  'Requires attention',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fund Flow: Centre → States → Agencies',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_tree, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Sankey Chart Visualization',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Centre (₹2,450 Cr) → 28 States → 450+ Agencies',
                            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nationwide Project Heatmap',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          _buildLegendItem('High Activity', Colors.green),
                          const SizedBox(width: 16),
                          _buildLegendItem('Medium Activity', Colors.blue),
                          const SizedBox(width: 16),
                          _buildLegendItem('Low Activity', Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: IndiaMapWidget(
                    markers: _stateMarkers,
                    geofences: _stateGeofences,
                    onMarkerTap: _handleStateMarkerTap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    subtitle,
                    style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  void _handleStateMarkerTap(String stateId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('State: ${stateId.toUpperCase()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogRow('Total Projects', '125'),
            _buildDialogRow('Active', '98'),
            _buildDialogRow('Completed', '27'),
            _buildDialogRow('Budget', '₹450 Cr'),
            _buildDialogRow('Utilization', '78%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showChatRoomsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 800,
          height: 600,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Inter-Level Communication Channels',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildChatRoomCard(
                      'Policy Council',
                      'Centre-State Strategic Communication',
                      '28 State Officers',
                      '12 unread',
                      Colors.blue,
                      Icons.policy,
                    ),
                    _buildChatRoomCard(
                      'Audit Liaison',
                      'Centre-Auditor Coordination',
                      '5 Auditors',
                      '3 unread',
                      Colors.purple,
                      Icons.verified_user,
                    ),
                    _buildChatRoomCard(
                      'Fund Transfer Coordination',
                      'PFMS Integration Queries',
                      '28 States',
                      '45 unread',
                      Colors.green,
                      Icons.account_balance,
                    ),
                    _buildChatRoomCard(
                      'Agency Onboarding Support',
                      'Cross-State Agency Registration',
                      '450+ Agencies',
                      '89 unread',
                      Colors.orange,
                      Icons.business,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatRoomCard(String title, String description, String members, String unread, Color color, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              members,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                unread,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        onTap: () => _openChatRoom(title),
      ),
    );
  }

  void _openChatRoom(String roomName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $roomName chat room...')),
    );
  }

  void _showNotificationsPanel() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 600,
          height: 500,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications & Alerts',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildNotificationCard(
                      'State Request Approved',
                      'Maharashtra Adarsh Gram request REQ-2025-001 approved',
                      DateTime.now().subtract(const Duration(minutes: 5)),
                      Colors.green,
                      Icons.check_circle,
                    ),
                    _buildNotificationCard(
                      'Agency Onboarding Pending',
                      '3 new agencies awaiting verification',
                      DateTime.now().subtract(const Duration(hours: 2)),
                      Colors.orange,
                      Icons.pending_actions,
                    ),
                    _buildNotificationCard(
                      'Audit Flag Raised',
                      'Evidence mismatch in Project PJ-2025-10',
                      DateTime.now().subtract(const Duration(hours: 5)),
                      Colors.red,
                      Icons.flag,
                    ),
                    _buildNotificationCard(
                      'Fund Transfer Completed',
                      '₹120 Cr transferred to Karnataka',
                      DateTime.now().subtract(const Duration(days: 1)),
                      Colors.blue,
                      Icons.currency_rupee,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(String title, String message, DateTime timestamp, Color color, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(message),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}