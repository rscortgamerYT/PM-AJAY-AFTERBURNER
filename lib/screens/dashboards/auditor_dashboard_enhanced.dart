import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../widgets/india_map_widget.dart';
import '../../widgets/communication_hub_button.dart';
import '../../models/user_role.dart';

class AuditorDashboardEnhanced extends StatefulWidget {
  const AuditorDashboardEnhanced({Key? key}) : super(key: key);

  @override
  State<AuditorDashboardEnhanced> createState() => _AuditorDashboardEnhancedState();
}

class _AuditorDashboardEnhancedState extends State<AuditorDashboardEnhanced> {
  // Sample audit location markers
  final List<MapMarker> _auditMarkers = [
    MapMarker(
      id: 'audit_1',
      position: const LatLng(19.0760, 72.8777),
      color: Colors.green,
      icon: Icons.check_circle,
      count: null,
      title: 'CHC Mumbai - Verified',
    ),
    MapMarker(
      id: 'audit_2',
      position: const LatLng(18.5204, 73.8567),
      color: Colors.orange,
      icon: Icons.pending,
      count: null,
      title: 'PHC Pune - Pending',
    ),
    MapMarker(
      id: 'audit_3',
      position: const LatLng(21.1458, 79.0882),
      color: Colors.red,
      icon: Icons.warning,
      count: null,
      title: 'RHC Nagpur - Issues Found',
    ),
  ];

  final List<GeofencePolygon> _auditRegions = [
    GeofencePolygon(
      points: [
        const LatLng(19.3, 72.5),
        const LatLng(19.3, 73.2),
        const LatLng(18.8, 73.2),
        const LatLng(18.8, 72.5),
      ],
      color: Colors.green,
      label: 'Mumbai Zone - Compliant',
    ),
    GeofencePolygon(
      points: [
        const LatLng(18.8, 73.5),
        const LatLng(18.8, 74.2),
        const LatLng(18.2, 74.2),
        const LatLng(18.2, 73.5),
      ],
      color: Colors.orange,
      label: 'Pune Zone - Under Review',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auditor Portal - PM-AJAY'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: _showNotificationsPanel,
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildAuditDashboard(),
          // Communication Hub Button
          const CommunicationHubButton(
            userRole: UserRole.auditor,
            unreadCount: 3,
            hasUrgentNotifications: true,
          ),
        ],
      ),
    );
  }

  // Section 1: Audit Dashboard with Queue
  Widget _buildAuditDashboard() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Audit Dashboard',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        
        // Hero Cards
        Row(
          children: [
            Expanded(
              child: _buildHeroCard(
                'Pending Audits',
                '24',
                Icons.pending_actions,
                Colors.orange,
                '8 high priority',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildHeroCard(
                'In Progress',
                '12',
                Icons.pending,
                Colors.blue,
                '5 due this week',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildHeroCard(
                'Completed',
                '156',
                Icons.check_circle,
                Colors.green,
                '98% compliant',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildHeroCard(
                'Issues Found',
                '16',
                Icons.warning,
                Colors.red,
                'Requires attention',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Audit Queue Table
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Audit Queue',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          label: const Text('High Priority'),
                          selected: false,
                          onSelected: (value) {},
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('Overdue'),
                          selected: false,
                          onSelected: (value) {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Project ID', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Project Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Agency', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Audit Type', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Priority', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Due Date', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: [
                    _buildAuditQueueRow(
                      'PRJ-2025-001',
                      'CHC Construction - Mumbai',
                      'MH Healthcare Builders',
                      'Financial',
                      'High',
                      '20-Mar-2025',
                      'Pending',
                      Colors.orange,
                    ),
                    _buildAuditQueueRow(
                      'PRJ-2025-002',
                      'Equipment Installation - Pune',
                      'Tech Medical Solutions',
                      'Physical',
                      'Medium',
                      '25-Mar-2025',
                      'In Progress',
                      Colors.blue,
                    ),
                    _buildAuditQueueRow(
                      'PRJ-2024-098',
                      'PHC Renovation - Nagpur',
                      'Infrastructure Corp',
                      'Compliance',
                      'Low',
                      '30-Mar-2025',
                      'Scheduled',
                      Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Quick Actions
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Schedule New Audit'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload Evidence'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.flag),
                      label: const Text('Raise Issue'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download),
                      label: const Text('Export Queue'),
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

  // Section 2: Fund Transfer Ledger with Immutable Logs
  Widget _buildFundTransferLedger() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Fund Transfer Ledger',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.lock, size: 16, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              'Blockchain-secured immutable transaction logs',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Summary Cards
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Transfers',
                '₹850 Cr',
                Icons.currency_rupee,
                Colors.blue,
                '124 transactions',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                'Pending Verification',
                '₹45 Cr',
                Icons.pending,
                Colors.orange,
                '8 pending',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                'Flagged Transactions',
                '₹12 Cr',
                Icons.flag,
                Colors.red,
                '3 flagged',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Filter Bar
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by Transaction ID, Project, or Agency',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: 'all',
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All States')),
                    DropdownMenuItem(value: 'mh', child: Text('Maharashtra')),
                    DropdownMenuItem(value: 'gj', child: Text('Gujarat')),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: 'all_dates',
                  items: const [
                    DropdownMenuItem(value: 'all_dates', child: Text('All Dates')),
                    DropdownMenuItem(value: 'this_month', child: Text('This Month')),
                    DropdownMenuItem(value: 'last_quarter', child: Text('Last Quarter')),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Transaction Ledger Table
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Txn ID', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('From', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('To', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Purpose', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Hash', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: [
                _buildLedgerRow(
                  'TXN-2025-00124',
                  '15-Mar-2025 14:30',
                  'Centre → Maharashtra',
                  'MH State Treasury',
                  '₹25 Cr',
                  'CHC Construction Phase 2',
                  'Verified',
                  '0x8f3a2...',
                  Colors.green,
                ),
                _buildLedgerRow(
                  'TXN-2025-00123',
                  '14-Mar-2025 11:15',
                  'Maharashtra → Agency',
                  'MH Healthcare Builders',
                  '₹12 Cr',
                  'Milestone Payment',
                  'Pending',
                  '0x7d2b1...',
                  Colors.orange,
                ),
                _buildLedgerRow(
                  'TXN-2025-00122',
                  '13-Mar-2025 09:45',
                  'Centre → Gujarat',
                  'GJ State Treasury',
                  '₹18 Cr',
                  'Equipment Installation',
                  'Flagged',
                  '0x6c1a0...',
                  Colors.red,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Section 3: Evidence Audit with Geo-tagged Photos
  Widget _buildEvidenceAudit() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Evidence Audit',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        
        // Evidence Summary
        Row(
          children: [
            Expanded(
              child: _buildEvidenceCard(
                'Total Evidence',
                '1,248',
                Icons.photo_library,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildEvidenceCard(
                'Geo-tagged Photos',
                '856',
                Icons.location_on,
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildEvidenceCard(
                'Documents',
                '342',
                Icons.description,
                Colors.purple,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildEvidenceCard(
                'Pending Review',
                '50',
                Icons.pending,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Map View with Evidence Markers
        SizedBox(
          height: 400,
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Evidence Locations Map',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          _buildMapLegend('Verified', Colors.green),
                          const SizedBox(width: 16),
                          _buildMapLegend('Pending', Colors.orange),
                          const SizedBox(width: 16),
                          _buildMapLegend('Issues', Colors.red),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: IndiaMapWidget(
                    markers: _auditMarkers,
                    geofences: _auditRegions,
                    onMarkerTap: _handleMarkerTap,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Evidence Gallery
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Evidence Submissions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.grid_view),
                      label: const Text('View Gallery'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _buildEvidencePhoto(
                      'Foundation Work',
                      '19.0760°N, 72.8777°E',
                      '15-Mar-2025',
                      Colors.green,
                    ),
                    _buildEvidencePhoto(
                      'Structural Progress',
                      '19.0765°N, 72.8780°E',
                      '14-Mar-2025',
                      Colors.green,
                    ),
                    _buildEvidencePhoto(
                      'Equipment Setup',
                      '18.5204°N, 73.8567°E',
                      '13-Mar-2025',
                      Colors.orange,
                    ),
                    _buildEvidencePhoto(
                      'Quality Check',
                      '21.1458°N, 79.0882°E',
                      '12-Mar-2025',
                      Colors.red,
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

  // Section 4: Compliance Checks with Milestone Checklist
  Widget _buildComplianceChecks() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Compliance Checks',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        
        // Compliance Overview
        Row(
          children: [
            Expanded(
              child: _buildComplianceScoreCard(
                'Overall Compliance',
                '87%',
                Colors.green,
                Icons.trending_up,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildComplianceScoreCard(
                'Financial Compliance',
                '92%',
                Colors.green,
                Icons.account_balance,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildComplianceScoreCard(
                'Technical Standards',
                '85%',
                Colors.orange,
                Icons.engineering,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildComplianceScoreCard(
                'Timeline Adherence',
                '75%',
                Colors.orange,
                Icons.schedule,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Project Compliance Table
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Project Compliance Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Project', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Financial', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Technical', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Timeline', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Documentation', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Overall', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: [
                    _buildComplianceRow(
                      'CHC Construction - Mumbai',
                      '95%',
                      '90%',
                      '85%',
                      '92%',
                      '90%',
                      Colors.green,
                    ),
                    _buildComplianceRow(
                      'Equipment Installation - Pune',
                      '88%',
                      '80%',
                      '70%',
                      '85%',
                      '81%',
                      Colors.orange,
                    ),
                    _buildComplianceRow(
                      'PHC Renovation - Nagpur',
                      '75%',
                      '70%',
                      '65%',
                      '72%',
                      '71%',
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Milestone Checklist
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Milestone Verification Checklist',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Project: CHC Construction - Mumbai (PRJ-2025-001)',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _buildChecklistItem('Foundation Work Completed', true, 'Verified on 15-Jan-2025'),
                _buildChecklistItem('Structural Framework Inspection', true, 'Verified on 28-Feb-2025'),
                _buildChecklistItem('Geo-tagged Progress Photos', true, '24 photos verified'),
                _buildChecklistItem('Financial Expenditure Report', true, '₹15 Cr verified'),
                _buildChecklistItem('Quality Test Certificates', false, 'Pending submission'),
                _buildChecklistItem('Safety Compliance Certificate', false, 'In review'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Export Checklist'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Submit Audit Report'),
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

  // Section 5: Reports & Exports
  Widget _buildReportsExports() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Reports & Exports',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        
        // Report Generator
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Generate Custom Report',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Report Type',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'audit', child: Text('Audit Summary')),
                          DropdownMenuItem(value: 'compliance', child: Text('Compliance Report')),
                          DropdownMenuItem(value: 'financial', child: Text('Financial Audit')),
                          DropdownMenuItem(value: 'evidence', child: Text('Evidence Report')),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Time Period',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'month', child: Text('This Month')),
                          DropdownMenuItem(value: 'quarter', child: Text('This Quarter')),
                          DropdownMenuItem(value: 'year', child: Text('This Year')),
                          DropdownMenuItem(value: 'custom', child: Text('Custom Range')),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Format',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                          DropdownMenuItem(value: 'excel', child: Text('Excel')),
                          DropdownMenuItem(value: 'csv', child: Text('CSV')),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download),
                      label: const Text('Generate Report'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Recent Reports
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Recent Reports',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildReportListItem(
                'Q4 2024 Compliance Audit Report',
                'Generated on 28-Feb-2025',
                'PDF • 2.4 MB',
                Icons.assessment,
                Colors.blue,
              ),
              _buildReportListItem(
                'Financial Audit - Maharashtra State',
                'Generated on 25-Feb-2025',
                'Excel • 1.8 MB',
                Icons.account_balance,
                Colors.green,
              ),
              _buildReportListItem(
                'Evidence Verification Report',
                'Generated on 20-Feb-2025',
                'PDF • 5.2 MB',
                Icons.photo_library,
                Colors.purple,
              ),
              _buildReportListItem(
                'Risk Assessment Report',
                'Generated on 15-Feb-2025',
                'PDF • 1.5 MB',
                Icons.warning,
                Colors.orange,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Scheduled Reports
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Scheduled Reports',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Add Schedule'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildScheduledReportItem(
                  'Monthly Compliance Report',
                  'Every 1st of month',
                  'PDF',
                  true,
                ),
                _buildScheduledReportItem(
                  'Weekly Audit Summary',
                  'Every Monday',
                  'Excel',
                  true,
                ),
                _buildScheduledReportItem(
                  'Quarterly Risk Assessment',
                  'End of quarter',
                  'PDF',
                  false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Section 6: Notifications & Escalations
  Widget _buildNotificationsEscalations() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Notifications & Escalations',
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
                FilterChip(
                  label: const Text('Escalations'),
                  selected: false,
                  onSelected: (value) {},
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Critical Escalations
        Card(
          color: Colors.red.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text(
                      'Critical Escalations',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildEscalationItem(
                  'Suspicious Transaction Alert',
                  'Transaction TXN-2025-00122 flagged for unusual amount. Requires immediate review.',
                  '2 hours ago',
                  Icons.flag,
                  Colors.red,
                ),
                _buildEscalationItem(
                  'Compliance Violation',
                  'Project PRJ-2024-098 has failed to meet 3 consecutive milestones. Escalation required.',
                  '5 hours ago',
                  Icons.error,
                  Colors.red,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Recent Notifications
        _buildNotificationItem(
          'New Audit Assigned',
          'You have been assigned to audit CHC Construction - Mumbai Phase 2',
          '1 day ago',
          Icons.assignment,
          Colors.blue,
          true,
        ),
        _buildNotificationItem(
          'Evidence Submitted',
          'Agency MH Healthcare Builders has submitted 12 new geo-tagged photos for review',
          '1 day ago',
          Icons.photo_library,
          Colors.green,
          true,
        ),
        _buildNotificationItem(
          'Milestone Due Soon',
          'Audit deadline for Project PRJ-2025-001 is approaching (Due: 20-Mar-2025)',
          '2 days ago',
          Icons.schedule,
          Colors.orange,
          false,
        ),
        _buildNotificationItem(
          'Compliance Report Ready',
          'Q4 2024 Compliance Report has been generated and is ready for download',
          '3 days ago',
          Icons.assessment,
          Colors.purple,
          false,
        ),
        _buildNotificationItem(
          'Payment Verified',
          'Fund transfer TXN-2025-00124 has been verified and logged in blockchain',
          '4 days ago',
          Icons.check_circle,
          Colors.green,
          false,
        ),
      ],
    );
  }

  // Section 7: Settings
  Widget _buildSettings() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        
        // Profile Settings
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
                      'Auditor Profile',
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
                          _buildProfileField('Name', 'Dr. Rajesh Kumar'),
                          _buildProfileField('Auditor ID', 'AUD-MH-2024-001'),
                          _buildProfileField('Designation', 'Senior Auditor'),
                          _buildProfileField('Department', 'Financial & Technical Audit'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileField('Email', 'rajesh.kumar@pmajay.gov.in'),
                          _buildProfileField('Phone', '+91 98765 43210'),
                          _buildProfileField('Region', 'Maharashtra'),
                          _buildProfileField('Experience', '15+ years'),
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
        
        // Audit Preferences
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Audit Preferences',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Auto-assign Audits'),
                  subtitle: const Text('Automatically assign new audits based on workload'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Receive audit updates via email'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: const Text('SMS Alerts'),
                  subtitle: const Text('Critical escalations via SMS'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: const Text('Evidence Auto-verification'),
                  subtitle: const Text('Auto-verify geo-tagged photos with valid coordinates'),
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Report Settings
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Report Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: const Text('Default Report Format'),
                  subtitle: const Text('PDF'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.cloud_upload),
                  title: const Text('Report Storage'),
                  subtitle: const Text('Cloud Storage (PFMS Server)'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Digital Signature'),
                  subtitle: const Text('Enabled - Valid until 15-Jan-2026'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
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
                  leading: const Icon(Icons.history),
                  title: const Text('Login History'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // System Actions
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.help, color: Colors.blue),
                  title: const Text('Help & Documentation'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.purple),
                  title: const Text('About PM-AJAY Portal'),
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

  DataRow _buildAuditQueueRow(
    String id,
    String project,
    String agency,
    String type,
    String priority,
    String dueDate,
    String status,
    Color statusColor,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(SizedBox(width: 200, child: Text(project))),
        DataCell(SizedBox(width: 150, child: Text(agency))),
        DataCell(Text(type)),
        DataCell(
          Chip(
            label: Text(priority),
            backgroundColor: priority == 'High' ? Colors.red.withOpacity(0.2) : 
                           priority == 'Medium' ? Colors.orange.withOpacity(0.2) : 
                           Colors.green.withOpacity(0.2),
            labelStyle: TextStyle(
              color: priority == 'High' ? Colors.red : 
                     priority == 'Medium' ? Colors.orange : 
                     Colors.green,
            ),
          ),
        ),
        DataCell(Text(dueDate)),
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
                icon: const Icon(Icons.play_arrow, size: 18),
                onPressed: () {},
                tooltip: 'Start Audit',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 28),
                Text(
                  value,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildLedgerRow(
    String txnId,
    String dateTime,
    String from,
    String to,
    String amount,
    String purpose,
    String status,
    String hash,
    Color statusColor,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(txnId, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(dateTime)),
        DataCell(SizedBox(width: 150, child: Text(from))),
        DataCell(SizedBox(width: 150, child: Text(to))),
        DataCell(Text(amount, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(SizedBox(width: 180, child: Text(purpose))),
        DataCell(
          Chip(
            label: Text(status),
            backgroundColor: statusColor.withOpacity(0.2),
            labelStyle: TextStyle(color: statusColor),
          ),
        ),
        DataCell(
          Row(
            children: [
              Text(hash, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
              IconButton(
                icon: const Icon(Icons.copy, size: 16),
                onPressed: () {},
                tooltip: 'Copy Hash',
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, size: 18),
                onPressed: () {},
                tooltip: 'View Details',
              ),
              IconButton(
                icon: const Icon(Icons.verified_user, size: 18),
                onPressed: () {},
                tooltip: 'Verify on Blockchain',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEvidenceCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
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

  Widget _buildEvidencePhoto(String title, String location, String date, Color statusColor) {
    return Container(
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
              padding: const EdgeInsets.all(8),
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
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    location,
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    date,
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
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
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.location_on, size: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceScoreCard(String title, String score, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              score,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildComplianceRow(
    String project,
    String financial,
    String technical,
    String timeline,
    String documentation,
    String overall,
    Color color,
  ) {
    return DataRow(
      cells: [
        DataCell(SizedBox(width: 200, child: Text(project))),
        DataCell(Text(financial, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(technical, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(timeline, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(documentation, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(
          Chip(
            label: Text(overall),
            backgroundColor: color.withOpacity(0.2),
            labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.arrow_forward, size: 18),
            onPressed: () {},
            tooltip: 'View Details',
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistItem(String item, bool checked, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.radio_button_unchecked,
            color: checked ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item,
                  style: TextStyle(
                    fontWeight: checked ? FontWeight.w500 : FontWeight.normal,
                    decoration: checked ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  detail,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportListItem(String title, String date, String size, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Row(
        children: [
          Text(date),
          const SizedBox(width: 16),
          Text(size, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {},
            tooltip: 'Download',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
            tooltip: 'Share',
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledReportItem(String title, String frequency, String format, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  '$frequency • $format',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: (value) {},
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildEscalationItem(String title, String message, String time, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
          ),
          child: const Text('Take Action'),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
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

  void _handleMarkerTap(String auditId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Audit Site: ${auditId.toUpperCase()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogRow('Project', 'CHC Construction'),
            _buildDialogRow('Status', 'Verified'),
            _buildDialogRow('Last Audit', '15-Mar-2025'),
            _buildDialogRow('Compliance', '95%'),
            _buildDialogRow('Evidence', '24 photos, 18 docs'),
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
            child: const Text('View Audit Details'),
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
                      'Audit Coordination - Centre',
                      'Direct communication with Central PM-AJAY office',
                      '2 new messages',
                      Icons.account_balance,
                      Colors.blue,
                      true,
                    ),
                    _buildChatRoomCard(
                      'State Liaison - Maharashtra',
                      'Coordination with State Officers',
                      'Last activity: 1 hour ago',
                      Icons.location_city,
                      Colors.green,
                      false,
                    ),
                    _buildChatRoomCard(
                      'Compliance Review Council',
                      'Inter-auditor compliance discussions',
                      '5 new messages',
                      Icons.gavel,
                      Colors.orange,
                      true,
                    ),
                    _buildChatRoomCard(
                      'Technical Support',
                      'Platform and system assistance',
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
                      'New Audit Assigned',
                      'You have been assigned to audit CHC Construction - Mumbai Phase 2',
                      _formatTimestamp(DateTime.now().subtract(const Duration(hours: 2))),
                      Icons.assignment,
                      Colors.blue,
                      true,
                    ),
                    _buildNotificationCard(
                      'Critical Escalation',
                      'Transaction TXN-2025-00122 flagged for unusual amount. Requires immediate review.',
                      _formatTimestamp(DateTime.now().subtract(const Duration(hours: 4))),
                      Icons.flag,
                      Colors.red,
                      true,
                    ),
                    _buildNotificationCard(
                      'Evidence Submitted',
                      'Agency MH Healthcare Builders has submitted 12 new geo-tagged photos for review',
                      _formatTimestamp(DateTime.now().subtract(const Duration(days: 1))),
                      Icons.photo_library,
                      Colors.green,
                      false,
                    ),
                    _buildNotificationCard(
                      'Milestone Due Soon',
                      'Audit deadline for Project PRJ-2025-001 is approaching (Due: 20-Mar-2025)',
                      _formatTimestamp(DateTime.now().subtract(const Duration(days: 2))),
                      Icons.schedule,
                      Colors.orange,
                      false,
                    ),
                    _buildNotificationCard(
                      'Compliance Report Ready',
                      'Q4 2024 Compliance Report has been generated and is ready for download',
                      _formatTimestamp(DateTime.now().subtract(const Duration(days: 3))),
                      Icons.assessment,
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