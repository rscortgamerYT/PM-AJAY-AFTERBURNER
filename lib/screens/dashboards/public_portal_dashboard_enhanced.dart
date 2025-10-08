import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../widgets/india_map_widget.dart';

class PublicPortalDashboardEnhanced extends StatefulWidget {
  const PublicPortalDashboardEnhanced({Key? key}) : super(key: key);

  @override
  State<PublicPortalDashboardEnhanced> createState() => _PublicPortalDashboardEnhancedState();
}

class _PublicPortalDashboardEnhancedState extends State<PublicPortalDashboardEnhanced> {
  // Filter states
  bool _showProjects = true;
  bool _showFacilities = true;
  bool _showOngoing = true;
  bool _showCompleted = true;
  String _selectedState = 'all';
  String _selectedDistrict = 'all';
  
  // Pagination
  int _currentPage = 1;
  final int _itemsPerPage = 6;
  
  // Request tracking
  final TextEditingController _trackingIdController = TextEditingController();
  
  // Sample project markers with detailed data
  final List<Map<String, dynamic>> _projectsData = [
    {
      'id': 'PROJ001',
      'name': 'District Hospital Modernization',
      'location': 'Mumbai, Maharashtra',
      'position': const LatLng(19.0760, 72.8777),
      'status': 'In Progress',
      'budget': '₹45 Cr',
      'completion': 65,
      'type': 'Hospital',
      'beneficiaries': '5,000+',
      'description': '500+ beds, Modern ICU, Advanced diagnostic center',
      'icon': Icons.local_hospital,
      'color': Colors.green,
    },
    {
      'id': 'PROJ002',
      'name': 'Primary Health Center Network',
      'location': 'Pune District, Maharashtra',
      'position': const LatLng(18.5204, 73.8567),
      'status': 'Completed',
      'budget': '₹28 Cr',
      'completion': 100,
      'type': 'Health Center',
      'beneficiaries': '15,000+',
      'description': '50+ PHCs upgraded with modern facilities',
      'icon': Icons.health_and_safety,
      'color': Colors.blue,
    },
    {
      'id': 'PROJ003',
      'name': 'Rural Healthcare Initiative',
      'location': 'Nagpur, Maharashtra',
      'position': const LatLng(21.1458, 79.0882),
      'status': 'In Progress',
      'budget': '₹15 Cr',
      'completion': 30,
      'type': 'Medical Facility',
      'beneficiaries': '8,000+',
      'description': 'Mobile health units and telemedicine centers',
      'icon': Icons.medical_services,
      'color': Colors.purple,
    },
    {
      'id': 'PROJ004',
      'name': 'Urban Healthcare Complex',
      'location': 'Delhi',
      'position': const LatLng(28.6139, 77.2090),
      'status': 'Planning',
      'budget': '₹60 Cr',
      'completion': 10,
      'type': 'Hospital',
      'beneficiaries': '10,000+',
      'description': 'Multi-specialty hospital with research center',
      'icon': Icons.apartment,
      'color': Colors.orange,
    },
    {
      'id': 'PROJ005',
      'name': 'Community Health Program',
      'location': 'Bangalore, Karnataka',
      'position': const LatLng(12.9716, 77.5946),
      'status': 'Completed',
      'budget': '₹18 Cr',
      'completion': 100,
      'type': 'Health Center',
      'beneficiaries': '12,000+',
      'description': 'Wellness centers and preventive care facilities',
      'icon': Icons.health_and_safety,
      'color': Colors.blue,
    },
    {
      'id': 'PROJ006',
      'name': 'Tribal Area Health Services',
      'location': 'Ranchi, Jharkhand',
      'position': const LatLng(23.3441, 85.3096),
      'status': 'In Progress',
      'budget': '₹22 Cr',
      'completion': 45,
      'type': 'Medical Facility',
      'beneficiaries': '6,000+',
      'description': 'Healthcare access for tribal communities',
      'icon': Icons.medical_services,
      'color': Colors.purple,
    },
  ];

  // Sample impact stories
  final List<Map<String, dynamic>> _impactStories = [
    {
      'title': 'Life-Saving Emergency Care',
      'location': 'Mumbai District Hospital',
      'story': 'Modern ICU facilities saved 500+ critical patients in 6 months',
      'image': Icons.favorite,
      'color': Colors.red,
    },
    {
      'title': 'Rural Healthcare Transformation',
      'location': 'Pune PHC Network',
      'story': 'Reduced travel time for 15,000 villagers from 2 hours to 15 minutes',
      'image': Icons.directions_walk,
      'color': Colors.green,
    },
    {
      'title': 'Telemedicine Success',
      'location': 'Nagpur Initiative',
      'story': '8,000+ consultations provided to remote areas via telehealth',
      'image': Icons.video_call,
      'color': Colors.blue,
    },
  ];

  List<MapMarker> get _filteredMarkers {
    return _projectsData
        .where((project) {
          if (!_showOngoing && project['status'] == 'In Progress') return false;
          if (!_showCompleted && project['status'] == 'Completed') return false;
          if (!_showProjects && project['type'] == 'Hospital') return false;
          if (!_showFacilities && project['type'] != 'Hospital') return false;
          return true;
        })
        .map((project) => MapMarker(
              id: project['id'],
              position: project['position'],
              color: project['color'],
              icon: project['icon'],
              count: null,
              title: project['name'],
            ))
        .toList();
  }

  List<Map<String, dynamic>> get _paginatedProjects {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _projectsData.sublist(
      startIndex,
      endIndex > _projectsData.length ? _projectsData.length : endIndex,
    );
  }

  int get _totalPages => (_projectsData.length / _itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PM-AJAY Public Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(),
          ),
        ],
      ),
      body: _buildInteractiveMapSection(),
    );
  }

  // Section 1: Full-Screen Interactive Leaflet Map
  Widget _buildInteractiveMapSection() {
    return Column(
      children: [
        // Stats Banner
        Container(
          color: Colors.blue[50],
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatChip('Total Projects', '538', Icons.work),
              _buildStatChip('States Covered', '28', Icons.location_city),
              _buildStatChip('Beneficiaries', '12.5M', Icons.people),
              _buildStatChip('Investment', '₹2,450 Cr', Icons.currency_rupee),
            ],
          ),
        ),
        
        // Full-Screen Map
        Expanded(
          child: IndiaMapWidget(
            markers: _filteredMarkers,
            geofences: const [],
            onMarkerTap: _handleMarkerTap,
          ),
        ),
        
        // Map Controls
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Hospitals', Colors.green),
              const SizedBox(width: 24),
              _buildLegendItem('Health Centers', Colors.blue),
              const SizedBox(width: 24),
              _buildLegendItem('Facilities', Colors.purple),
              const SizedBox(width: 24),
              _buildLegendItem('Planning', Colors.orange),
            ],
          ),
        ),
      ],
    );
  }

  // Section 2: Paginated Project List
  Widget _buildProjectListSection() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(24),
          color: Colors.grey[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Healthcare Projects Across India',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Explore ${_projectsData.length} ongoing and completed healthcare infrastructure projects',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        
        // Project Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _paginatedProjects.length,
            itemBuilder: (context, index) {
              final project = _paginatedProjects[index];
              return _buildProjectCard(project);
            },
          ),
        ),
        
        // Pagination
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(top: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _currentPage > 1
                    ? () => setState(() => _currentPage--)
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                'Page $_currentPage of $_totalPages',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _currentPage < _totalPages
                    ? () => setState(() => _currentPage++)
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Section 3: Impact Stories Carousel
  Widget _buildImpactStoriesSection() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Impact Stories',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Real stories of how PM-AJAY is transforming healthcare across India',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 32),
        
        // Featured Story
        Card(
          elevation: 4,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[600]!, Colors.blue[800]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.yellow[700], size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Featured Success Story',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '500+ Lives Saved: How Modern ICU Facilities Transformed Emergency Care in Mumbai',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Impact Story Cards
        ..._impactStories.map((story) => _buildImpactStoryCard(story)),
        
        const SizedBox(height: 24),
        
        // Testimonials Section
        const Text(
          'Patient Testimonials',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildTestimonialCard(
          'Rajesh Kumar',
          'Mumbai',
          'The new ICU facility saved my father\'s life. The doctors and equipment are world-class.',
          5,
        ),
        _buildTestimonialCard(
          'Priya Sharma',
          'Pune',
          'Having a PHC just 15 minutes away has made healthcare so much more accessible for our village.',
          5,
        ),
      ],
    );
  }

  // Section 4: Public Request Submission Form
  Widget _buildRequestSubmissionSection() {
    final formKey = GlobalKey<FormState>();
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Submit a Request',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Share your healthcare needs or report issues',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 32),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Request Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Your Name *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Phone Number *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Request Type *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'facility', child: Text('New Facility Request')),
                      DropdownMenuItem(value: 'equipment', child: Text('Equipment/Resources')),
                      DropdownMenuItem(value: 'complaint', child: Text('Complaint/Issue')),
                      DropdownMenuItem(value: 'feedback', child: Text('Feedback/Suggestion')),
                    ],
                    onChanged: (value) {},
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'State *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'maharashtra', child: Text('Maharashtra')),
                      DropdownMenuItem(value: 'karnataka', child: Text('Karnataka')),
                      DropdownMenuItem(value: 'delhi', child: Text('Delhi')),
                    ],
                    onChanged: (value) {},
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'District *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Village/Area',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.place),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Description *',
                      border: OutlineInputBorder(),
                      hintText: 'Describe your request in detail...',
                    ),
                    maxLines: 5,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  OutlinedButton.icon(
                    onPressed: () {
                      // File upload logic
                    },
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Attach Supporting Documents'),
                  ),
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              _showSuccessDialog();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Text('Submit Request'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Section 5: Request Tracker
  Widget _buildRequestTrackerSection() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Track Your Request',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your tracking ID to check request status',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 32),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _trackingIdController,
                        decoration: const InputDecoration(
                          labelText: 'Tracking ID',
                          hintText: 'e.g., REQ2024001234',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => _trackRequest(),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text('Track'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Sample tracking result
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green[700]),
                          const SizedBox(width: 8),
                          const Text(
                            'Request Status: Under Review',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTrackingRow('Request ID', 'REQ2024001234'),
                      _buildTrackingRow('Submitted On', '15 Jan 2024'),
                      _buildTrackingRow('Type', 'New Facility Request'),
                      _buildTrackingRow('Location', 'Pune, Maharashtra'),
                      _buildTrackingRow('Assigned To', 'State Health Officer'),
                      const SizedBox(height: 16),
                      
                      // Timeline
                      const Text(
                        'Request Timeline',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _buildTimelineItem('Request Submitted', '15 Jan 2024, 10:30 AM', true),
                      _buildTimelineItem('Initial Review', '16 Jan 2024, 02:15 PM', true),
                      _buildTimelineItem('Assigned to State Officer', '17 Jan 2024, 09:00 AM', true),
                      _buildTimelineItem('Site Survey Scheduled', 'Pending', false),
                      _buildTimelineItem('Final Approval', 'Pending', false),
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

  // Section 6: About PM-AJAY
  Widget _buildAboutSection() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'About PM-AJAY',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Pradhan Mantri Ayushman Jeevan Aarogya Yojana',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
        const SizedBox(height: 32),
        
        _buildInfoCard(
          'Mission',
          'To provide accessible, affordable, and quality healthcare infrastructure to all citizens of India, ensuring no one is left behind in the journey towards universal health coverage.',
          Icons.flag,
          Colors.blue,
        ),
        
        _buildInfoCard(
          'Vision',
          'A healthy India where every citizen, regardless of their location or economic status, has access to modern healthcare facilities and services.',
          Icons.visibility,
          Colors.green,
        ),
        
        _buildInfoCard(
          'Key Objectives',
          '• Strengthen healthcare infrastructure across urban and rural areas\n'
          '• Improve accessibility and affordability of healthcare services\n'
          '• Modernize existing facilities with state-of-the-art equipment\n'
          '• Enhance quality of healthcare delivery through technology\n'
          '• Focus on preventive and primary healthcare',
          Icons.checklist,
          Colors.purple,
        ),
        
        const SizedBox(height: 24),
        
        // Scheme Components
        const Text(
          'Scheme Components',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        _buildComponentCard('Infrastructure Development', 'Construction and modernization of hospitals, health centers, and medical facilities', Icons.business),
        _buildComponentCard('Equipment Procurement', 'Provision of modern medical equipment and diagnostic tools', Icons.medical_services),
        _buildComponentCard('Human Resources', 'Recruitment and training of healthcare professionals', Icons.people),
        _buildComponentCard('Technology Integration', 'Implementation of telemedicine and digital health solutions', Icons.computer),
      ],
    );
  }

  // Section 7: Footer with Contact and Help
  Widget _buildContactSection() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Contact & Help',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        
        // Contact Cards
        Row(
          children: [
            Expanded(
              child: _buildContactCard(
                'National Helpline',
                '1800-XXX-XXXX',
                'Toll-free, 24/7 support',
                Icons.phone,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildContactCard(
                'Email Support',
                'support@pmajay.gov.in',
                'Response within 24 hours',
                Icons.email,
                Colors.green,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        _buildContactCard(
          'Head Office',
          'Ministry of Health and Family Welfare\nNirman Bhavan, Maulana Azad Road\nNew Delhi - 110011',
          'Monday to Friday, 9:00 AM - 5:30 PM',
          Icons.location_on,
          Colors.orange,
        ),
        
        const SizedBox(height: 32),
        
        // FAQ Section
        const Text(
          'Frequently Asked Questions',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        _buildFaqItem(
          'How do I submit a request for a new healthcare facility?',
          'Navigate to the "Submit Request" section, fill out the form with required details, and submit. You will receive a tracking ID for follow-up.',
        ),
        _buildFaqItem(
          'How long does it take to process a request?',
          'Request processing typically takes 15-30 days depending on the complexity and verification requirements.',
        ),
        _buildFaqItem(
          'Can I track multiple requests?',
          'Yes, you can track any number of requests using their unique tracking IDs in the "Track Request" section.',
        ),
        _buildFaqItem(
          'Who can benefit from PM-AJAY?',
          'PM-AJAY aims to benefit all citizens of India, with special focus on underserved rural and tribal areas.',
        ),
        
        const SizedBox(height: 32),
        
        // Glossary
        const Text(
          'Glossary',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        _buildGlossaryItem('PHC', 'Primary Health Center - First contact point for healthcare services'),
        _buildGlossaryItem('CHC', 'Community Health Center - Secondary level healthcare facility'),
        _buildGlossaryItem('PFMS', 'Public Financial Management System - Fund tracking platform'),
        _buildGlossaryItem('GIS', 'Geographic Information System - Mapping and location services'),
        
        const SizedBox(height: 32),
        
        // Useful Links
        const Text(
          'Useful Links',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildLinkChip('Ministry of Health', Icons.public),
            _buildLinkChip('Ayushman Bharat', Icons.favorite),
            _buildLinkChip('National Health Mission', Icons.health_and_safety),
            _buildLinkChip('PFMS Portal', Icons.account_balance),
            _buildLinkChip('State Health Departments', Icons.location_city),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Footer
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              const Text(
                '© 2024 PM-AJAY | Government of India',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Last Updated: ${DateTime.now().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper Widgets
  Widget _buildStatChip(String label, String value, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(project['icon'], color: project['color'], size: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: project['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    project['status'],
                    style: TextStyle(
                      color: project['color'],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              project['name'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    project['location'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: project['completion'] / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(project['color']),
            ),
            const SizedBox(height: 4),
            Text(
              '${project['completion']}% Complete',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () => _showProjectDetails(project),
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactStoryCard(Map<String, dynamic> story) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: story['color'].withOpacity(0.2),
          child: Icon(story['image'], color: story['color']),
        ),
        title: Text(story['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(story['location'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 4),
            Text(story['story']),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildTestimonialCard(String name, String location, String testimonial, int rating) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                rating,
                (index) => Icon(Icons.star, color: Colors.amber[700], size: 20),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '"$testimonial"',
              style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  child: Text(name[0]),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(location, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(content, style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildContactCard(String title, String content, String subtitle, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(answer, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  Widget _buildGlossaryItem(String term, String definition) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(term, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(definition),
      ),
    );
  }

  Widget _buildLinkChip(String label, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () {
        // Navigate to external link
      },
    );
  }

  Widget _buildTrackingRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String date, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(date, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMarkerTap(String projectId) {
    final project = _projectsData.firstWhere((p) => p['id'] == projectId);
    _showProjectDetails(project);
  }

  void _showProjectDetails(Map<String, dynamic> project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(project['name']),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDialogRow('Project ID', project['id']),
              _buildDialogRow('Location', project['location']),
              _buildDialogRow('Status', project['status']),
              _buildDialogRow('Budget', project['budget']),
              _buildDialogRow('Completion', '${project['completion']}%'),
              _buildDialogRow('Beneficiaries', project['beneficiaries']),
              const SizedBox(height: 12),
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(project['description']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('View All Projects'),
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

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Projects'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter project name or location...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            // Implement search
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need assistance? Contact us:'),
            SizedBox(height: 12),
            Text('📞 Helpline: 1800-XXX-XXXX'),
            Text('📧 Email: support@pmajay.gov.in'),
            SizedBox(height: 12),
            Text('Available 24/7 for your queries.'),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 12),
            Text('Request Submitted'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your request has been successfully submitted.'),
            SizedBox(height: 12),
            Text('Tracking ID: REQ2024001235', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('You will receive updates via SMS and email.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Track Request'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _trackRequest() {
    // Simulate request tracking
    if (_trackingIdController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tracking request: ${_trackingIdController.text}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _trackingIdController.dispose();
    super.dispose();
  }
}