import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../widgets/india_map_widget.dart';
import '../../widgets/communication_hub_button.dart';
import '../../models/user_role.dart';

class AgencyDashboardEnhanced extends StatefulWidget {
  final String agencyId;
  final UserRole userRole;

  const AgencyDashboardEnhanced({
    Key? key,
    required this.agencyId,
  }) : super(key: key);

  @override
  State<AgencyDashboardEnhanced> createState() => _AgencyDashboardEnhancedState();
}

class _AgencyDashboardEnhancedState extends State<AgencyDashboardEnhanced> {
  // Sample data
  final List<MapMarker> _serviceMarkers = [
    MapMarker(
      id: 'hospital_1',
      position: const LatLng(19.0760, 72.8777),
      color: Colors.green,
      icon: Icons.local_hospital,
      count: null,
      title: 'General Hospital - Active',
    ),
    MapMarker(
      id: 'phc_1',
      position: const LatLng(19.1000, 72.9000),
      color: Colors.blue,
      icon: Icons.health_and_safety,
      count: null,
      title: 'PHC - Operational',
    ),
    MapMarker(
      id: 'construction_1',
      position: const LatLng(19.0500, 72.8500),
      color: Colors.orange,
      icon: Icons.construction,
      count: null,
      title: 'CHC - Under Construction',
    ),
  ];

  final List<GeofencePolygon> _serviceAreas = [
    GeofencePolygon(
      points: [
        const LatLng(19.15, 72.75),
        const LatLng(19.15, 73.00),
        const LatLng(19.00, 73.00),
        const LatLng(19.00, 72.75),
      ],
      color: Colors.green,
      label: 'Primary Service Zone',
    ),
    GeofencePolygon(
      points: [
        const LatLng(19.00, 72.75),
        const LatLng(19.00, 73.00),
        const LatLng(18.85, 73.00),
        const LatLng(18.85, 72.75),
      ],
      color: Colors.blue,
      label: 'Secondary Service Zone',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.agencyId.toUpperCase()} - Agency Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showNotificationsPanel(),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildDashboardHome(),
          // Communication Hub Button
          const CommunicationHubButton(
            userRole: UserRole.agencyUser,
            unreadCount: 5,
            hasUrgentNotifications: false,
          ),
        ],
      ),
    );
  }

  // Section 1: Dashboard Home with Coverage Map
  Widget _buildDashboardHome() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Dashboard Home',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        
        // Hero Cards
        Row(
          children: [
            Expanded(
              child: _buildHeroCard(
                'Active Projects',
                '8',
                Icons.work,
                Colors.blue,
                '2 due this week',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildHeroCard(
                'Pending Milestones',
                '12',
                Icons.track_changes,
                Colors.orange,
                '3 overdue',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildHeroCard(
                'Service Coverage',
                '42 sq km',
                Icons.map,
                Colors.green,
                '3 zones',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildHeroCard(
                'Budget Utilized',
                '₹65 Cr',
                Icons.currency_rupee,
                Colors.purple,
                '76% of allocated',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Coverage Map
        SizedBox(
          height: 500,
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Service Area Coverage Map',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          _buildMapLegend('Active', Colors.green),
                          const SizedBox(width: 16),
                          _buildMapLegend('In Progress', Colors.orange),
                          const SizedBox(width: 16),
                          _buildMapLegend('Operational', Colors.blue),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: IndiaMapWidget(
                    markers: _serviceMarkers,
                    geofences: _serviceAreas,
                    onMarkerTap: _handleMarkerTap,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Quick Stats
        Row(
          children: [
            Expanded(
              child: _buildStatCard('On Schedule', '75%', Colors.green),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard('Delayed', '20%', Colors.orange),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard('At Risk', '5%', Colors.red),
            ),
          ],
        ),
      ],
    );
  }

  // Section 2: Work Order Inbox with Digital Signature Panel
  Widget _buildWorkOrderInbox() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Work Order Inbox',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: true,
                  onSelected: (value) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Pending Signature'),
                  selected: false,
                  onSelected: (value) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Signed'),
                  selected: false,
                  onSelected: (value) {},
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Work Orders Table
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Work Order ID', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Project Name', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Value', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Issue Date', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: [
                _buildWorkOrderRow(
                  'WO-2025-001',
                  'CHC Construction - Phase 2',
                  'Construction',
                  '₹25 Cr',
                  '15-Jan-2025',
                  'Pending Signature',
                  Colors.orange,
                ),
                _buildWorkOrderRow(
                  'WO-2025-002',
                  'Medical Equipment Installation',
                  'Procurement',
                  '₹12 Cr',
                  '20-Jan-2025',
                  'Signed',
                  Colors.green,
                ),
                _buildWorkOrderRow(
                  'WO-2025-003',
                  'PHC Renovation',
                  'Renovation',
                  '₹8 Cr',
                  '25-Jan-2025',
                  'Pending Signature',
                  Colors.orange,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Digital Signature Panel
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Digital Signature Panel',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Selected Work Order: WO-2025-001'),
                          const SizedBox(height: 8),
                          const Text('Project: CHC Construction - Phase 2'),
                          const SizedBox(height: 8),
                          const Text('Value: ₹25 Cr'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.verified_user, color: Colors.green),
                              const SizedBox(width: 8),
                              const Text('Digital Signature Certificate: Valid'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Signature Pad\n(Click to Sign)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check),
                      label: const Text('Sign & Accept'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Section 3: Execution & Reporting with Geo-tagged Photo Upload
  Widget _buildExecutionReporting() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Execution & Reporting',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        
        // Active Projects
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Active Projects',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildProjectProgressCard(
                  'CHC Construction - Phase 2',
                  'WO-2025-001',
                  60,
                  'Foundation complete, structural work ongoing',
                  Colors.blue,
                ),
                _buildProjectProgressCard(
                  'Medical Equipment Installation',
                  'WO-2025-002',
                  35,
                  'Procurement in progress',
                  Colors.orange,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Milestone Update Form
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Milestone Update Submission',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Project',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'wo1', child: Text('CHC Construction - Phase 2')),
                    DropdownMenuItem(value: 'wo2', child: Text('Medical Equipment Installation')),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Milestone',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'm1', child: Text('Foundation Work')),
                    DropdownMenuItem(value: 'm2', child: Text('Structural Framework')),
                    DropdownMenuItem(value: 'm3', child: Text('Roofing')),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Progress Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                
                // Geo-tagged Photo Upload
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Geo-tagged Photo Upload',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Upload photos with GPS coordinates and timestamp',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Capture Photo'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Upload from Gallery'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildPhotoThumbnail('photo1.jpg', '19.0760°N, 72.8777°E', '15-Mar-2025'),
                          _buildPhotoThumbnail('photo2.jpg', '19.0765°N, 72.8780°E', '15-Mar-2025'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.send),
                      label: const Text('Submit Milestone Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Section 4: Capabilities Management with Service Area Editor
  Widget _buildCapabilitiesManagement() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Capabilities Management',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        
        // Capabilities Overview
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Technical Capabilities',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildCapabilityItem('Civil Construction', true),
                      _buildCapabilityItem('Medical Equipment Installation', true),
                      _buildCapabilityItem('HVAC Systems', true),
                      _buildCapabilityItem('Fire Safety Systems', false),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('Add Capability'),
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
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resources',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildResourceItem('Workforce', '250+ skilled workers'),
                      _buildResourceItem('Equipment', '45 machinery units'),
                      _buildResourceItem('Licenses', '12 active certifications'),
                      _buildResourceItem('Experience', '15+ years in healthcare'),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        label: const Text('Update Resources'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Service Area Editor
        SizedBox(
          height: 500,
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Service Area Editor',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.draw),
                            label: const Text('Draw Zone'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.save),
                            label: const Text('Save Changes'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: IndiaMapWidget(
                    markers: _serviceMarkers,
                    geofences: _serviceAreas,
                    onMarkerTap: _handleMarkerTap,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'Click on map to define service zone boundaries. Maximum 3 zones allowed.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Section 5: Registration Status Tracker
  Widget _buildRegistrationStatus() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Registration Status',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        
        // Status Overview Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registration Status',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildStatusBadge('APPROVED', Colors.green),
                      const SizedBox(height: 16),
                      const Text('Agency ID: AG-MH-2024-001'),
                      const Text('Approved Date: 15-Jan-2025'),
                      const Text('Valid Until: 14-Jan-2026'),
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 3),
                    shape: BoxShape.circle,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified, color: Colors.green, size: 48),
                      Text(
                        'VERIFIED',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Registration Timeline
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Registration Timeline',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _buildTimelineItem(
                  'Application Submitted',
                  '10-Dec-2024',
                  true,
                  Colors.green,
                ),
                _buildTimelineItem(
                  'Document Verification',
                  '15-Dec-2024',
                  true,
                  Colors.green,
                ),
                _buildTimelineItem(
                  'Technical Assessment',
                  '22-Dec-2024',
                  true,
                  Colors.green,
                ),
                _buildTimelineItem(
                  'Final Approval',
                  '15-Jan-2025',
                  true,
                  Colors.green,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Required Documents
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Submitted Documents',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildDocumentItem('Company Registration Certificate', 'Verified', true),
                _buildDocumentItem('Technical Capability Statement', 'Verified', true),
                _buildDocumentItem('Financial Statements (3 years)', 'Verified', true),
                _buildDocumentItem('ISO 9001:2015 Certificate', 'Verified', true),
                _buildDocumentItem('GST Registration', 'Verified', true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Section 6: Notifications Panel
  Widget _buildNotifications() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: true,
                  onSelected: (value) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Unread'),
                  selected: false,
                  onSelected: (value) {},
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.done_all),
                  label: const Text('Mark all as read'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        _buildNotificationCard(
          'New Work Order Assigned',
          'WO-2025-004 for PHC Equipment Installation has been assigned to your agency.',
          '2 hours ago',
          Icons.inbox,
          Colors.blue,
          true,
        ),
        _buildNotificationCard(
          'Milestone Deadline Approaching',
          'Structural Framework milestone for WO-2025-001 is due in 3 days.',
          '5 hours ago',
          Icons.warning,
          Colors.orange,
          true,
        ),
        _buildNotificationCard(
          'Payment Released',
          'Milestone payment of ₹5 Cr has been released for WO-2024-045.',
          '1 day ago',
          Icons.currency_rupee,
          Colors.green,
          false,
        ),
        _buildNotificationCard(
          'Document Upload Required',
          'Please upload completion certificate for WO-2024-042.',
          '2 days ago',
          Icons.upload_file,
          Colors.red,
          false,
        ),
        _buildNotificationCard(
          'Registration Renewal',
          'Your agency registration will expire in 30 days. Please initiate renewal process.',
          '3 days ago',
          Icons.event,
          Colors.purple,
          false,
        ),
      ],
    );
  }

  // Section 7: Profile & Settings
  Widget _buildSettings() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Profile & Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        
        // Profile Information
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Agency Profile',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileField('Agency Name', 'Maharashtra Healthcare Builders'),
                          _buildProfileField('Registration Number', 'AG-MH-2024-001'),
                          _buildProfileField('Registration Date', '15-Jan-2025'),
                          _buildProfileField('Valid Until', '14-Jan-2026'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileField('Contact Person', 'Mr. Rajesh Kumar'),
                          _buildProfileField('Email', 'contact@mhcb.com'),
                          _buildProfileField('Phone', '+91 98765 43210'),
                          _buildProfileField('GST Number', '27AABCU9603R1ZX'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Notification Preferences
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notification Preferences',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Receive updates via email'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: const Text('SMS Notifications'),
                  subtitle: const Text('Receive important alerts via SMS'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: const Text('Work Order Alerts'),
                  subtitle: const Text('New work order assignments'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: const Text('Milestone Reminders'),
                  subtitle: const Text('Upcoming deadline notifications'),
                  value: true,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Security Settings
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Security Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.password),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Two-Factor Authentication'),
                  subtitle: const Text('Enabled'),
                  trailing: Switch(value: true, onChanged: (value) {}),
                ),
                ListTile(
                  leading: const Icon(Icons.vpn_key),
                  title: const Text('Digital Signature Certificate'),
                  subtitle: const Text('Valid until: 14-Jan-2026'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Account Actions
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.download, color: Colors.blue),
                  title: const Text('Download Agency Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.refresh, color: Colors.green),
                  title: const Text('Renew Registration'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.help, color: Colors.orange),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper Widgets
  Widget _buildHeroCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapLegend(String label, Color color) {
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
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildWorkOrderRow(
    String id,
    String project,
    String type,
    String value,
    String date,
    String status,
    Color statusColor,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(SizedBox(width: 250, child: Text(project))),
        DataCell(Text(type)),
        DataCell(Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(date)),
        DataCell(
          Chip(
            label: Text(status),
            backgroundColor: statusColor.withOpacity(0.2),
            labelStyle: TextStyle(color: statusColor),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, size: 18),
                onPressed: () {},
                tooltip: 'View',
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () {},
                tooltip: 'Sign',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectProgressCard(
    String title,
    String woId,
    int progress,
    String description,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Chip(
                  label: Text(woId),
                  backgroundColor: color.withOpacity(0.2),
                  labelStyle: TextStyle(color: color),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const SizedBox(width: 16),
                Text('$progress%', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoThumbnail(String filename, String location, String date) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.image, size: 48, color: Colors.grey),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    filename,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    location,
                    style: const TextStyle(color: Colors.white70, fontSize: 8),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.location_on, size: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilityItem(String capability, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            color: enabled ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            capability,
            style: TextStyle(
              color: enabled ? Colors.black : Colors.grey,
              fontWeight: enabled ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String date, bool completed, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: completed ? color : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              completed ? Icons.check : Icons.circle,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String document, String status, bool verified) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            verified ? Icons.verified : Icons.pending,
            color: verified ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(document),
          ),
          Chip(
            label: Text(status),
            backgroundColor: verified ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
            labelStyle: TextStyle(color: verified ? Colors.green : Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    String title,
    String message,
    String time,
    IconData icon,
    Color color,
    bool unread,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: unread ? Colors.blue.shade50 : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: unread ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(message),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: unread
            ? const Icon(Icons.circle, color: Colors.blue, size: 12)
            : null,
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _handleMarkerTap(String facilityId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Facility: ${facilityId.toUpperCase()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogRow('Type', 'Community Health Center'),
            _buildDialogRow('Status', 'Under Construction'),
            _buildDialogRow('Progress', '60%'),
            _buildDialogRow('Work Order', 'WO-2025-001'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
// Communication Methods
  void _showChatRoomsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 600,
          height: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Communication Channels',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildChatRoomCard(
                      'Project Team - WO-2025-001',
                      'Internal team coordination for CHC construction',
                      '3 new messages',
                      Icons.groups,
                      Colors.blue,
                      true,
                    ),
                    _buildChatRoomCard(
                      'Project Team - WO-2024-045',
                      'PHC Equipment Installation team',
                      'Last activity: 2 hours ago',
                      Icons.groups,
                      Colors.green,
                      false,
                    ),
                    _buildChatRoomCard(
                      'State Officer Liaison',
                      'Direct communication with State PM-AJAY office',
                      '1 new message',
                      Icons.account_balance,
                      Colors.orange,
                      true,
                    ),
                    _buildChatRoomCard(
                      'Technical Support',
                      'Platform technical assistance',
                      'Last activity: Yesterday',
                      Icons.support_agent,
                      Colors.purple,
                      false,
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

  void _showNotificationsPanel() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 500,
          height: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.done_all, size: 16),
                        label: const Text('Mark all read'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildNotificationCard(
                      'New Work Order Assigned',
                      'WO-2025-004 for PHC Equipment Installation has been assigned to your agency.',
                      _formatTimestamp(DateTime.now().subtract(const Duration(hours: 2))),
                      Icons.inbox,
                      Colors.blue,
                      true,
                    ),
                    _buildNotificationCard(
                      'Evidence Approval Required',
                      'Milestone evidence for WO-2025-001 awaiting State Officer review.',
                      _formatTimestamp(DateTime.now().subtract(const Duration(hours: 4))),
                      Icons.approval,
                      Colors.orange,
                      true,
                    ),
                    _buildNotificationCard(
                      'Payment Released',
                      'Milestone payment of ₹5 Cr has been credited to your account.',
                      _formatTimestamp(DateTime.now().subtract(const Duration(days: 1))),
                      Icons.currency_rupee,
                      Colors.green,
                      false,
                    ),
                    _buildNotificationCard(
                      'Document Upload Required',
                      'Please upload completion certificate for WO-2024-042 within 48 hours.',
                      _formatTimestamp(DateTime.now().subtract(const Duration(days: 2))),
                      Icons.upload_file,
                      Colors.red,
                      false,
                    ),
                    _buildNotificationCard(
                      'Registration Renewal Reminder',
                      'Your agency registration expires in 30 days. Please initiate renewal.',
                      _formatTimestamp(DateTime.now().subtract(const Duration(days: 3))),
                      Icons.event,
                      Colors.purple,
                      false,
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

  Widget _buildChatRoomCard(
    String title,
    String description,
    String status,
    IconData icon,
    Color color,
    bool hasUnread,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(description),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: hasUnread ? color : Colors.grey[600],
                fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        trailing: hasUnread
            ? Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.circle, color: Colors.white, size: 8),
              )
            : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _openChatRoom(title),
      ),
    );
  }

  void _openChatRoom(String roomName) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening chat room: $roomName')),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}