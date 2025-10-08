import 'package:flutter/material.dart';

class AgencyDashboard extends StatefulWidget {
  final String agencyName;
  
  const AgencyDashboard({super.key, this.agencyName = 'Infrastructure Agency'});

  @override
  State<AgencyDashboard> createState() => _AgencyDashboardState();
}

class _AgencyDashboardState extends State<AgencyDashboard> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(5, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.agencyName} Dashboard'),
        backgroundColor: const Color(0xFF26A69A),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          // Permanent Sidebar
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: const Border(
                right: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: _buildPermanentSidebar(),
          ),
          // Main Content with Infinite Scroll
          Expanded(
            child: _buildInfiniteScrollContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF26A69A),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.business,
                    size: 30,
                    color: Color(0xFF26A69A),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.agencyName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'agency@pmajay.gov.in',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Project Tasks'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Team Management'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Resource Management'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildOverview();
      case 1:
        return _buildTasks();
      case 2:
        return _buildProgress();
      case 3:
        return _buildResources();
      default:
        return _buildOverview();
    }
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.agencyName} Overview',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard('Active Projects', '12', Icons.work, Colors.blue),
              _buildStatCard('Completed Tasks', '89', Icons.check_circle, Colors.green),
              _buildStatCard('Team Members', '25', Icons.people, Colors.orange),
              _buildStatCard('Budget Used', '₹45 Cr', Icons.monetization_on, Colors.purple),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Sprint',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: 0.65,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF26A69A)),
                        ),
                        const SizedBox(height: 8),
                        const Text('65% Complete (13/20 tasks)'),
                      ],
                    ),
                  ),
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
                        const Text(
                          'Quality Score',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber[600], size: 20),
                            Icon(Icons.star, color: Colors.amber[600], size: 20),
                            Icon(Icons.star, color: Colors.amber[600], size: 20),
                            Icon(Icons.star, color: Colors.amber[600], size: 20),
                            Icon(Icons.star_half, color: Colors.amber[600], size: 20),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text('4.5/5.0 Rating'),
                      ],
                    ),
                  ),
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
                    'Recent Activities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActivityItem('Infrastructure milestone completed', '2 hours ago'),
                  _buildActivityItem('Quality inspection passed', '4 hours ago'),
                  _buildActivityItem('Resource allocation updated', '6 hours ago'),
                  _buildActivityItem('Team meeting scheduled', '1 day ago'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasks() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Project Tasks',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('New Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26A69A),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  labelColor: Color(0xFF26A69A),
                  tabs: [
                    Tab(text: 'To Do'),
                    Tab(text: 'In Progress'),
                    Tab(text: 'Completed'),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    children: [
                      _buildTaskList(['Site Survey', 'Material Procurement', 'Permit Applications'], Colors.orange),
                      _buildTaskList(['Foundation Work', 'Structural Design', 'Quality Testing'], Colors.blue),
                      _buildTaskList(['Land Acquisition', 'Environmental Clearance', 'Initial Planning'], Colors.green),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<String> tasks, Color color) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(Icons.task_alt, color: color),
            ),
            title: Text(tasks[index]),
            subtitle: Text('Priority: ${['High', 'Medium', 'Low'][index % 3]}'),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildProgress() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Project Progress',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              final projects = [
                'Highway Construction Phase 1',
                'School Building Project',
                'Water Treatment Plant',
                'Community Center Development'
              ];
              final progress = [0.85, 0.60, 0.40, 0.25];
              final colors = [Colors.green, Colors.blue, Colors.orange, Colors.red];
              
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projects[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: progress[index],
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(colors[index]),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${(progress[index] * 100).toInt()}% Complete'),
                          Text(
                            'Due: ${['Dec 2024', 'Jan 2025', 'Mar 2025', 'Jun 2025'][index]}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResources() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resource Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildResourceCard('Equipment', '15 Units', Icons.construction, Colors.blue),
              _buildResourceCard('Materials', '85% Stock', Icons.inventory, Colors.green),
              _buildResourceCard('Vehicles', '8 Active', Icons.local_shipping, Colors.orange),
              _buildResourceCard('Documents', '120 Files', Icons.folder, Colors.purple),
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
                    'Resource Allocation',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildAllocationRow('Human Resources', '60%', Colors.blue),
                  _buildAllocationRow('Equipment', '25%', Colors.green),
                  _buildAllocationRow('Materials', '10%', Colors.orange),
                  _buildAllocationRow('Other', '5%', Colors.purple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
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
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF26A69A),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity, style: const TextStyle(fontSize: 14)),
                Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationRow(String label, String percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 2,
            child: LinearProgressIndicator(
              value: double.parse(percentage.replaceAll('%', '')) / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            percentage,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return const Center(child: Text('Agency Settings'));
  }

  Widget _buildReports() {
    return const Center(child: Text('Reports & Analytics'));
  }

  // Permanent Sidebar Implementation for Agency Dashboard
  Widget _buildPermanentSidebar() {
    final sidebarItems = [
      {'title': 'Agency Overview', 'icon': Icons.dashboard, 'index': 0},
      {'title': 'Project Tasks', 'icon': Icons.assignment, 'index': 1},
      {'title': 'Project Progress', 'icon': Icons.trending_up, 'index': 2},
      {'title': 'Resource Management', 'icon': Icons.inventory, 'index': 3},
      {'title': 'Settings', 'icon': Icons.settings, 'index': 4},
    ];

    return Column(
      children: [
        // Profile Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF26A69A),
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.business,
                  size: 30,
                  color: Color(0xFF26A69A),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.agencyName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'agency@pmajay.gov.in',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        // Navigation Items
        Expanded(
          child: ListView.builder(
            itemCount: sidebarItems.length,
            itemBuilder: (context, index) {
              final item = sidebarItems[index];
              final isSelected = _selectedIndex == item['index'];
              
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected ? const Color(0xFF26A69A).withOpacity(0.1) : null,
                ),
                child: ListTile(
                  leading: Icon(
                    item['icon'] as IconData,
                    color: isSelected ? const Color(0xFF26A69A) : Colors.grey[600],
                  ),
                  title: Text(
                    item['title'] as String,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF26A69A) : Colors.grey[800],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onTap: () => _scrollToSection(item['index'] as int),
                ),
              );
            },
          ),
        ),
        
        // Logout
        Container(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  // Infinite Scroll Content for Agency Dashboard
  Widget _buildInfiniteScrollContent() {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          _updateSelectedIndex();
        }
        return false;
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Agency Overview Section
            Container(
              key: _sectionKeys[0],
              child: _buildOverview(),
            ),
            
            // Project Tasks Section
            Container(
              key: _sectionKeys[1],
              child: _buildTasks(),
            ),
            
            // Project Progress Section
            Container(
              key: _sectionKeys[2],
              child: _buildProgress(),
            ),
            
            // Resource Management Section
            Container(
              key: _sectionKeys[3],
              child: _buildResources(),
            ),
            
            // Settings Section
            Container(
              key: _sectionKeys[4],
              child: _buildSettings(),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToSection(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateSelectedIndex() {
    final scrollOffset = _scrollController.offset;
    int newIndex = 0;
    
    for (int i = 0; i < _sectionKeys.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          if (position.dy <= 100) {
            newIndex = i;
          }
        }
      }
    }
    
    if (newIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }
}
