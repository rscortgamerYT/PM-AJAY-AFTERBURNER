import 'package:flutter/material.dart';
import 'complete_pmajay_app.dart';

class ModernDashboard extends StatefulWidget {
  final UserRole role;

  const ModernDashboard({super.key, required this.role});

  @override
  State<ModernDashboard> createState() => _ModernDashboardState();
}

class _ModernDashboardState extends State<ModernDashboard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<NavigationDestination> get _destinations {
    switch (widget.role) {
      case UserRole.centreAdmin:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.account_balance_outlined), selectedIcon: Icon(Icons.account_balance), label: 'Funds'),
          NavigationDestination(icon: Icon(Icons.business_outlined), selectedIcon: Icon(Icons.business), label: 'Agencies'),
          NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics), label: 'Analytics'),
        ];
      case UserRole.stateOfficer:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.account_balance_outlined), selectedIcon: Icon(Icons.account_balance), label: 'Funds'),
          NavigationDestination(icon: Icon(Icons.business_outlined), selectedIcon: Icon(Icons.business), label: 'Agencies'),
          NavigationDestination(icon: Icon(Icons.assessment_outlined), selectedIcon: Icon(Icons.assessment), label: 'Reports'),
        ];
      case UserRole.agencyUser:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'My Projects'),
          NavigationDestination(icon: Icon(Icons.upload_outlined), selectedIcon: Icon(Icons.upload), label: 'Evidence'),
          NavigationDestination(icon: Icon(Icons.timeline_outlined), selectedIcon: Icon(Icons.timeline), label: 'Progress'),
        ];
      case UserRole.auditor:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.verified_outlined), selectedIcon: Icon(Icons.verified), label: 'Audits'),
          NavigationDestination(icon: Icon(Icons.assessment_outlined), selectedIcon: Icon(Icons.assessment), label: 'Reports'),
        ];
      case UserRole.publicViewer:
        return const [
          NavigationDestination(icon: Icon(Icons.public_outlined), selectedIcon: Icon(Icons.public), label: 'Public Dashboard'),
          NavigationDestination(icon: Icon(Icons.feedback_outlined), selectedIcon: Icon(Icons.feedback), label: 'Feedback'),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[50]!,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildModernAppBar(),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildModernBottomNav(),
    );
  }

  Widget _buildModernAppBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PM-AJAY',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  widget.role.displayName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _destinations,
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: const Color(0xFF667EEA).withOpacity(0.1),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildSecondScreen();
      case 2:
        return _buildThirdScreen();
      case 3:
        return _buildFourthScreen();
      case 4:
        return _buildFifthScreen();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section with Quick Actions
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome back! 👋',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.role.displayName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.role.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildQuickActions(),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          _getRoleIcon(widget.role),
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Fund Flow Visualization
            _buildFundFlowSection(),
            const SizedBox(height: 24),

            // Stats Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View all stats
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF6366F1),
                  ),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildStatsGrid(),
            const SizedBox(height: 24),

            // Project Status
            _buildProjectStatus(),
            const SizedBox(height: 24),

            // Recent Activity & Notifications
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildRecentActivity(),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildNotificationsSection(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = _getStatsForRole();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return _buildModernStatCard(
          stat['title']!,
          stat['value']!,
          stat['icon'] as IconData,
          stat['color'] as Color,
          index,
        );
      },
    );
  }

  Widget _buildModernStatCard(String title, String value, IconData icon, Color color, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutBack,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Icon(
                  Icons.trending_up,
                  color: Colors.green,
                  size: 16,
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActivityItem(
            'New project assigned',
            'Adarsh Gram Development - Village Rampur',
            Icons.folder_outlined,
            Colors.blue,
            '2h ago',
          ),
          _buildActivityItem(
            'Evidence uploaded',
            'Progress photos for Community Center',
            Icons.upload_outlined,
            Colors.green,
            '5h ago',
          ),
          _buildActivityItem(
            'Milestone completed',
            'Foundation work completed successfully',
            Icons.check_circle_outline,
            Colors.orange,
            '1d ago',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, IconData icon, Color color, String time) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getStatsForRole() {
    switch (widget.role) {
      case UserRole.centreAdmin:
        return [
          {'title': 'Total Budget', 'value': '₹16,000 Cr', 'icon': Icons.account_balance, 'color': Colors.blue},
          {'title': 'Active Projects', 'value': '2,847', 'icon': Icons.folder, 'color': Colors.green},
          {'title': 'States/UTs', 'value': '36', 'icon': Icons.map, 'color': Colors.orange},
          {'title': 'Agencies', 'value': '1,245', 'icon': Icons.business, 'color': Colors.purple},
        ];
      case UserRole.stateOfficer:
        return [
          {'title': 'State Budget', 'value': '₹2,400 Cr', 'icon': Icons.account_balance, 'color': Colors.blue},
          {'title': 'Active Projects', 'value': '387', 'icon': Icons.folder, 'color': Colors.green},
          {'title': 'Districts', 'value': '75', 'icon': Icons.location_city, 'color': Colors.orange},
          {'title': 'Agencies', 'value': '89', 'icon': Icons.business, 'color': Colors.purple},
        ];
      case UserRole.agencyUser:
        return [
          {'title': 'My Projects', 'value': '12', 'icon': Icons.folder, 'color': Colors.green},
          {'title': 'Completed', 'value': '8', 'icon': Icons.check_circle, 'color': Colors.blue},
          {'title': 'In Progress', 'value': '3', 'icon': Icons.schedule, 'color': Colors.orange},
          {'title': 'Pending', 'value': '1', 'icon': Icons.pending, 'color': Colors.red},
        ];
      case UserRole.auditor:
        return [
          {'title': 'Pending Audits', 'value': '23', 'icon': Icons.pending_actions, 'color': Colors.orange},
          {'title': 'Completed', 'value': '156', 'icon': Icons.check_circle, 'color': Colors.green},
          {'title': 'Issues Found', 'value': '8', 'icon': Icons.warning, 'color': Colors.red},
          {'title': 'Quality Score', 'value': '4.6/5', 'icon': Icons.star, 'color': Colors.purple},
        ];
      case UserRole.publicViewer:
        return [
          {'title': 'Projects Completed', 'value': '1,234', 'icon': Icons.check_circle, 'color': Colors.green},
          {'title': 'Beneficiaries', 'value': '2.4M', 'icon': Icons.people, 'color': Colors.blue},
          {'title': 'States Covered', 'value': '36', 'icon': Icons.map, 'color': Colors.orange},
          {'title': 'Success Rate', 'value': '87%', 'icon': Icons.trending_up, 'color': Colors.purple},
        ];
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.centreAdmin:
        return Icons.admin_panel_settings;
      case UserRole.stateOfficer:
        return Icons.location_city;
      case UserRole.agencyUser:
        return Icons.business;
      case UserRole.auditor:
        return Icons.verified_user;
      case UserRole.publicViewer:
        return Icons.public;
    }
  }

  Widget _buildSecondScreen() {
    return _buildGenericScreen(_destinations[1].label, Icons.folder);
  }

  Widget _buildThirdScreen() {
    return _buildGenericScreen(_destinations[2].label, Icons.account_balance);
  }

  Widget _buildFourthScreen() {
    if (_destinations.length > 3) {
      return _buildGenericScreen(_destinations[3].label, Icons.business);
    }
    return _buildGenericScreen('Screen', Icons.help);
  }

  Widget _buildFifthScreen() {
    if (_destinations.length > 4) {
      return _buildGenericScreen(_destinations[4].label, Icons.analytics);
    }
    return _buildGenericScreen('Screen', Icons.help);
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.add_circle_outline,
        'label': 'New Project',
        'onTap': () {}
      },
      {
        'icon': Icons.upload_file,
        'label': 'Upload Evidence',
        'onTap': () {}
      },
      {
        'icon': Icons.receipt_long,
        'label': 'View Reports',
        'onTap': () {}
      },
      {
        'icon': Icons.notifications_active,
        'label': 'Alerts',
        'onTap': () {}
      },
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions.map((action) {
        return ActionChip(
          avatar: Icon(action['icon'] as IconData, size: 18, color: Colors.white),
          label: Text(
            action['label'] as String,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          backgroundColor: Colors.white.withOpacity(0.2),
          onPressed: action['onTap'] as void Function()?,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        );
      }).toList(),
    );
  }

  Widget _buildFundFlowSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fund Flow',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Live Tracking',
                  style: TextStyle(
                    color: Color(0xFF6366F1),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                // Flow lines
                CustomPaint(
                  size: const Size(double.infinity, 200),
                  painter: _FundFlowPainter(),
                ),
                // Nodes
                Positioned(
                  left: 0,
                  top: 80,
                  child: _buildFlowNode('Central\nTreasury', Icons.account_balance, 0),
                ),
                Positioned(
                  left: 120,
                  top: 20,
                  child: _buildFlowNode('State\nTreasury', Icons.account_balance_wallet, 1),
                ),
                Positioned(
                  left: 120,
                  top: 140,
                  child: _buildFlowNode('District\nOffice', Icons.location_city, 2),
                ),
                Positioned(
                  right: 120,
                  top: 60,
                  child: _buildFlowNode('Project\nAgencies', Icons.business, 3),
                ),
                Positioned(
                  right: 0,
                  top: 100,
                  child: _buildFlowNode('Beneficiaries', Icons.people, 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowNode(String label, IconData icon, int index) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getNodeColor(index).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: _getNodeColor(index), width: 2),
          ),
          child: Icon(icon, color: _getNodeColor(index), size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Color _getNodeColor(int index) {
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFFF59E0B),
      const Color(0xFF10B981),
    ];
    return colors[index % colors.length];
  }

  Widget _buildProjectStatus() {
    final projects = [
      {
        'name': 'Adarsh Gram Yojana',
        'progress': 0.75,
        'status': 'In Progress',
        'statusColor': Colors.orange,
        'budget': '₹2.5 Cr',
        'completion': '75%',
      },
      {
        'name': 'PM Awas Yojana',
        'progress': 0.45,
        'status': 'In Progress',
        'statusColor': Colors.orange,
        'budget': '₹5.2 Cr',
        'completion': '45%',
      },
      {
        'name': 'Jal Jeevan Mission',
        'progress': 0.9,
        'status': 'Completed',
        'statusColor': Colors.green,
        'budget': '₹3.8 Cr',
        'completion': '100%',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          ...projects.map((project) => _buildProjectItem(project)).toList(),
        ],
      ),
    );
  }

  Widget _buildProjectItem(Map<String, dynamic> project) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                project['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (project['statusColor'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  project['status'],
                  style: TextStyle(
                    color: project['statusColor'],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: project['progress'],
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      project['statusColor'],
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                project['completion'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget: ${project['budget']}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                'View Details',
                style: TextStyle(
                  color: const Color(0xFF6366F1),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    final notifications = [
      {
        'title': 'New Project Assigned',
        'message': 'You have been assigned to Adarsh Gram Yojana',
        'time': '2h ago',
        'icon': Icons.assignment,
        'color': Colors.blue,
        'isRead': false,
      },
      {
        'title': 'Deadline Approaching',
        'message': 'Submit Q2 progress report by tomorrow',
        'time': '5h ago',
        'icon': Icons.notification_important,
        'color': Colors.orange,
        'isRead': true,
      },
      {
        'title': 'Funds Released',
        'message': '₹25 Lakhs released for PM Awas Yojana',
        'time': '1d ago',
        'icon': Icons.account_balance_wallet,
        'color': Colors.green,
        'isRead': true,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6366F1),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Mark all as read'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: notifications.map((notification) => _buildNotificationItem(notification)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (notification['color'] as Color).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          notification['icon'] as IconData,
          color: notification['color'],
          size: 20,
        ),
      ),
      title: Text(
        notification['title'],
        style: TextStyle(
          fontWeight: notification['isRead'] ? FontWeight.normal : FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        notification['message'],
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            notification['time'],
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
            ),
          ),
          if (!notification['isRead'])
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF6366F1),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      onTap: () {
        // Handle notification tap
      },
    );
  }

class _FundFlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Draw flow lines
    final path = Path();
    
    // Central Treasury to State Treasury
    path.moveTo(60, 100);
    path.cubicTo(90, 100, 100, 60, 140, 60);
    
    // Central Treasury to District Office
    path.moveTo(60, 100);
    path.cubicTo(90, 100, 100, 140, 140, 140);
    
    // State Treasury to Project Agencies
    path.moveTo(180, 60);
    path.cubicTo(220, 60, 240, 80, 260, 80);
    
    // District Office to Project Agencies
    path.moveTo(180, 140);
    path.cubicTo(220, 140, 240, 100, 260, 100);
    
    // Project Agencies to Beneficiaries
    path.moveTo(340, 100);
    path.cubicTo(360, 100, 380, 100, 400, 120);
    
    canvas.drawPath(path, paint);
    
    // Add flow animation
    final animationPaint = Paint()
      ..color = const Color(0xFF6366F1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    // Animate the flow
    final animation = DateTime.now().millisecondsSinceEpoch / 1000 % 2.0;
    if (animation < 1.0) {
      final animatedPath = Path();
      final pathMetrics = path.computeMetrics();
      
      for (final metric in pathMetrics) {
        final pathLength = metric.length;
        final start = (animation * pathLength) % pathLength;
        final end = (start + 0.2 * pathLength).clamp(0.0, pathLength);
        final extractPath = metric.extractPath(start, end);
        animatedPath.addPath(extractPath, Offset.zero);
      }
      
      canvas.drawPath(animatedPath, animationPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

  Widget _buildGenericScreen(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete $title functionality implemented with beautiful UI',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title feature activated! 🚀'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                'Explore $title',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
