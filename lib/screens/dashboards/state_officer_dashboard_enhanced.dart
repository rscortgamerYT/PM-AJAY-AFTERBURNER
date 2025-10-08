import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../widgets/india_map_widget.dart';
import '../../widgets/communication_hub_button.dart';
import '../../models/user_role.dart';

class StateOfficerDashboardEnhanced extends StatefulWidget {
  final String stateId;
  final UserRole userRole;

  const StateOfficerDashboardEnhanced({
    Key? key,
    required this.stateId,
  }) : super(key: key);

  @override
  State<StateOfficerDashboardEnhanced> createState() => _StateOfficerDashboardEnhancedState();
}

class _StateOfficerDashboardEnhancedState extends State<StateOfficerDashboardEnhanced> {
  String _selectedDistrict = 'all';
  
  final List<MapMarker> _districtMarkers = [
    MapMarker(
      id: 'mumbai',
      position: const LatLng(19.0760, 72.8777),
      color: Colors.green,
      icon: Icons.location_on,
      count: 42,
      title: 'Mumbai',
    ),
    MapMarker(
      id: 'pune',
      position: const LatLng(18.5204, 73.8567),
      color: Colors.blue,
      icon: Icons.location_on,
      count: 38,
      title: 'Pune',
    ),
    MapMarker(
      id: 'nagpur',
      position: const LatLng(21.1458, 79.0882),
      color: Colors.orange,
      icon: Icons.location_on,
      count: 25,
      title: 'Nagpur',
    ),
  ];

  final List<GeofencePolygon> _districtGeofences = [
    GeofencePolygon(
      points: [
        const LatLng(19.3, 72.5),
        const LatLng(19.3, 73.2),
        const LatLng(18.8, 73.2),
        const LatLng(18.8, 72.5),
      ],
      color: Colors.green,
      label: 'Mumbai',
    ),
    GeofencePolygon(
      points: [
        const LatLng(18.8, 73.5),
        const LatLng(18.8, 74.2),
        const LatLng(18.2, 74.2),
        const LatLng(18.2, 73.5),
      ],
      color: Colors.blue,
      label: 'Pune',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.stateId.toUpperCase()} - State Officer Dashboard'),
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
            userRole: UserRole.stateOfficer,
            unreadCount: 8,
            hasUrgentNotifications: false,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
      ),
    );
  }

  // Section 1: Dashboard Home with District Heatmap
  Widget _buildHomeSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // State Hero Cards
          Row(
            children: [
              Expanded(
                child: _buildHeroCard('Fund Balance', '₹450 Cr', Icons.account_balance, Colors.green, '78% utilized'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildHeroCard('Pending Public Requests', '24', Icons.pending_actions, Colors.orange, 'From 12 villages'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildHeroCard('Active Agencies', '42', Icons.business, Colors.blue, 'Across 36 districts'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildHeroCard('Compliance Score', '87%', Icons.verified, Colors.purple, '+5% this month'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // District Heatmap
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'District-wise Project Heatmap',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _selectedDistrict == 'all' ? 'All Districts' : _selectedDistrict.toUpperCase(),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          DropdownButton<String>(
                            value: _selectedDistrict,
                            items: ['all', 'mumbai', 'pune', 'nagpur']
                                .map((d) => DropdownMenuItem(value: d, child: Text(d.toUpperCase())))
                                .toList(),
                            onChanged: (value) => setState(() => _selectedDistrict = value!),
                          ),
                          const SizedBox(width: 16),
                          _buildLegendItem('High Activity', Colors.green),
                          const SizedBox(width: 12),
                          _buildLegendItem('Medium Activity', Colors.blue),
                          const SizedBox(width: 12),
                          _buildLegendItem('Low Activity', Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: IndiaMapWidget(
                    markers: _getFilteredMarkers(),
                    geofences: _districtGeofences,
                    onMarkerTap: _handleDistrictMarkerTap,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Recent Notifications
          const Text('Recent Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...List.generate(3, (i) => _buildNotificationCard(
            'Centre Approval Received',
            'Request REQ-2025-00${i + 1} has been approved for ₹${120 + i * 10} Cr',
            DateTime.now().subtract(Duration(hours: i + 1)),
            Colors.green,
          )),
        ],
      ),
    );
  }

  // Section 2: Public Request Review
  Widget _buildPublicRequestsSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'District',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['All Districts', 'Mumbai', 'Pune', 'Nagpur']
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (_) {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['All Types', 'Adarsh Gram', 'Hostel', 'GIA']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (_) {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['All', 'High', 'Medium', 'Low']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (_) {},
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Village')),
                  DataColumn(label: Text('Requestor')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Map')),
                  DataColumn(label: Text('Action')),
                ],
                rows: [
                  _buildPublicRequestRow('Shirpur', 'Sarpanch Ram Kumar', 'Adarsh Gram', '₹2.5 Cr', 'Pending'),
                  _buildPublicRequestRow('Kalamb', 'ZP Officer Priya Sharma', 'Hostel', '₹1.8 Cr', 'Under Review'),
                  _buildPublicRequestRow('Wardha', 'NGO Representative', 'GIA', '₹3.2 Cr', 'Pending'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Section 3: Agency Registration Review
  Widget _buildAgencyRegistrationSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pending Agency Registrations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Onboard New Agency'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(4, (i) => _buildAgencyReviewCard(
            'Construction Agency ${i + 1}',
            'Infrastructure Development',
            'Documents Verified',
            'Coverage: ${i + 5} districts',
          )),
        ],
      ),
    );
  }

  // Section 4: Project Allocation
  Widget _buildProjectAllocationSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Approved Projects for Allocation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildProjectAllocationCard('PJ-2025-001', 'District Hospital Upgrade', '₹45 Cr', 'Adarsh Gram'),
                    _buildProjectAllocationCard('PJ-2025-002', 'PHC Network Expansion', '₹28 Cr', 'Hostel'),
                    _buildProjectAllocationCard('PJ-2025-003', 'Medical Equipment', '₹15 Cr', 'GIA'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Agency Capacity Chart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildCapacityBar('Agency A', 0.75, Colors.green),
                        _buildCapacityBar('Agency B', 0.60, Colors.blue),
                        _buildCapacityBar('Agency C', 0.40, Colors.orange),
                        const SizedBox(height: 24),
                        const Text('Drag & Drop Assignment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Drop project here to assign', style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section 5: Fund Release
  Widget _buildFundReleaseSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pending Fund Transfers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.send),
                label: const Text('Initiate Transfer'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DataTable(
            columns: const [
              DataColumn(label: Text('Transfer ID')),
              DataColumn(label: Text('Agency')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Project')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Action')),
            ],
            rows: [
              _buildTransferRow('TRF-2025-001', 'Agency A', '₹12 Cr', 'Hospital Upgrade', 'Pending'),
              _buildTransferRow('TRF-2025-002', 'Agency B', '₹8 Cr', 'PHC Expansion', 'Approved'),
              _buildTransferRow('TRF-2025-003', 'Agency C', '₹5 Cr', 'Equipment', 'Pending'),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Receipt Confirmation Panel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text('Last Confirmed: TRF-2025-002 - ₹8 Cr to Agency B', style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Text('Status: Funds transferred successfully', style: TextStyle(color: Colors.green[700])),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section 6: Analytics
  Widget _buildAnalyticsSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('State Performance Analytics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text('District Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Center(child: Text('Bar Chart: District-wise completion %')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text('Fund vs Physical Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Center(child: Text('Line Graph: Budget vs Progress')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Bottleneck Heatmap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 300,
                  child: IndiaMapWidget(
                    markers: _districtMarkers,
                    geofences: _districtGeofences,
                    onMarkerTap: _handleDistrictMarkerTap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section 7: Settings
  Widget _buildSettingsSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('State Configuration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildSettingsCard('Compliance Templates', 'Configure state-specific compliance requirements', Icons.description),
          _buildSettingsCard('Notification Preferences', 'Manage alert and notification settings', Icons.notifications),
          _buildSettingsCard('GIS Boundaries Upload', 'Update district and village boundary GeoJSON files', Icons.map),
          const SizedBox(height: 24),
          const Text('Integration Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildSettingsCard('State Database Sync', 'Configure synchronization with state systems', Icons.sync),
          _buildSettingsCard('PFMS Integration', 'State-level payment gateway settings', Icons.payment),
        ],
      ),
    );
  }

  // Helper Widgets
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
                  child: Text(subtitle, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildNotificationCard(String title, String message, DateTime timestamp, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.notifications, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(message),
            const SizedBox(height: 4),
            Text(
              '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildPublicRequestRow(String village, String requestor, String type, String amount, String status) {
    return DataRow(
      cells: [
        DataCell(Text(village)),
        DataCell(Text(requestor)),
        DataCell(Text(type)),
        DataCell(Text(amount)),
        DataCell(Chip(
          label: Text(status, style: const TextStyle(fontSize: 12)),
          backgroundColor: status == 'Pending' ? Colors.orange[100] : Colors.blue[100],
        )),
        DataCell(IconButton(
          icon: const Icon(Icons.map, color: Colors.blue),
          onPressed: () {},
          tooltip: 'View on Map',
        )),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () {}),
            IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () {}),
          ],
        )),
      ],
    );
  }

  Widget _buildAgencyReviewCard(String name, String type, String status, String coverage) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.business, color: Colors.white),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type),
            Text(coverage, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(label: Text(status, style: const TextStyle(fontSize: 12)), backgroundColor: Colors.green[100]),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () {}, child: const Text('Approve')),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectAllocationCard(String id, String name, String budget, String component) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.work)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$id • $component • $budget'),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildCapacityBar(String agency, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(agency),
              Text('${(value * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  DataRow _buildTransferRow(String id, String agency, String amount, String project, String status) {
    return DataRow(
      cells: [
        DataCell(Text(id)),
        DataCell(Text(agency)),
        DataCell(Text(amount)),
        DataCell(Text(project)),
        DataCell(Chip(
          label: Text(status, style: const TextStyle(fontSize: 12)),
          backgroundColor: status == 'Pending' ? Colors.orange[100] : Colors.green[100],
        )),
        DataCell(ElevatedButton(
          onPressed: () {},
          child: const Text('Process'),
        )),
      ],
    );
  }

  Widget _buildSettingsCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {},
      ),
    );
  }

  List<MapMarker> _getFilteredMarkers() {
    if (_selectedDistrict == 'all') return _districtMarkers;
    return _districtMarkers.where((m) => m.id == _selectedDistrict).toList();
  }

  void _handleDistrictMarkerTap(String districtId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('District: ${districtId.toUpperCase()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogRow('Active Projects', '42'),
            _buildDialogRow('Budget Allocated', '₹85 Cr'),
            _buildDialogRow('Utilization', '73%'),
            _buildDialogRow('Agencies', '12'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Details')),
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
// Inter-Level Communication - Chat Rooms
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
                      'Centre-State Policy Council',
                      'Strategic Communication with Centre',
                      'Centre Admin & 28 States',
                      '5 unread',
                      Colors.blue,
                      Icons.policy,
                    ),
                    _buildChatRoomCard(
                      'Agency Coordination',
                      'Project Allocation & Execution',
                      '42 Active Agencies',
                      '18 unread',
                      Colors.orange,
                      Icons.business,
                    ),
                    _buildChatRoomCard(
                      'Public Grievance Channel',
                      'Citizen Request Support',
                      '24 Pending Requests',
                      '12 unread',
                      Colors.green,
                      Icons.people,
                    ),
                    _buildChatRoomCard(
                      'Fund Transfer Queries',
                      'PFMS & Budget Clarifications',
                      'Centre Financial Team',
                      '3 unread',
                      Colors.purple,
                      Icons.account_balance,
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

  // Notifications Panel
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
                      'Centre Approval Received',
                      'Request REQ-2025-001 approved for ₹120 Cr',
                      DateTime.now().subtract(const Duration(minutes: 15)),
                      Colors.green,
                    ),
                    _buildNotificationCard(
                      'New Public Request',
                      'Village Shirpur submitted Adarsh Gram request',
                      DateTime.now().subtract(const Duration(hours: 1)),
                      Colors.blue,
                    ),
                    _buildNotificationCard(
                      'Agency Registration',
                      'New agency awaiting verification',
                      DateTime.now().subtract(const Duration(hours: 3)),
                      Colors.orange,
                    ),
                    _buildNotificationCard(
                      'Fund Transfer Alert',
                      'PFMS transfer TRF-2025-001 requires signature',
                      DateTime.now().subtract(const Duration(hours: 6)),
                      Colors.red,
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