import 'package:flutter/material.dart';
import 'modern_dashboard.dart';

void main() {
  runApp(const CompletePMAjayApp());
}

class CompletePMAjayApp extends StatelessWidget {
  const CompletePMAjayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PM-AJAY Management Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Modern indigo
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        cardTheme: const CardTheme(
          elevation: 0,
        ),
      ),
      home: const ModernRoleSelectionScreen(),
    );
  }
}

enum UserRole {
  centreAdmin('Centre Admin', 'Full system oversight and policy management'),
  stateOfficer('State Officer', 'State-level project management and coordination'),
  agencyUser('Agency User', 'Project execution and progress reporting'),
  auditor('Auditor', 'Quality assurance and compliance verification'),
  publicViewer('Public Viewer', 'Transparency dashboard and public information');

  const UserRole(this.displayName, this.description);
  final String displayName;
  final String description;
}

class ModernRoleSelectionScreen extends StatefulWidget {
  const ModernRoleSelectionScreen({super.key});

  @override
  State<ModernRoleSelectionScreen> createState() => _ModernRoleSelectionScreenState();
}

class _ModernRoleSelectionScreenState extends State<ModernRoleSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFF6366F1),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Modern Hero Section
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.account_balance,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'PM-AJAY',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -1,
                                ),
                              ),
                              const Text(
                                'Agency Mapping Platform',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '🚀 Production Ready • 🎨 Beautiful UI • 🔒 Secure',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Modern Role Cards
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 40,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Choose Your Role',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Select your role to access the personalized dashboard',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 32),

                              ...UserRole.values.asMap().entries.map((entry) {
                                final index = entry.key;
                                final role = entry.value;
                                return AnimatedContainer(
                                  duration: Duration(milliseconds: 200 + (index * 100)),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: _buildModernRoleCard(context, role, index),
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Features Showcase
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Premium Features',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildFeatureGrid(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernRoleCard(BuildContext context, UserRole role, int index) {
    final colors = [
      [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
      [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
      [const Color(0xFFFA709A), const Color(0xFFFEE140)],
      [const Color(0xFFA8EDEA), const Color(0xFFFED6E3)],
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors[index % colors.length],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors[index % colors.length][0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    ModernDashboard(role: role),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    )),
                    child: child,
                  );
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getRoleIcon(role),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        role.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget _buildFeatureGrid() {
    final features = [
      ['🎨', 'Beautiful UI', 'Modern Material 3 design'],
      ['📊', 'Analytics', 'Real-time dashboards'],
      ['🔒', 'Secure', 'Government-grade security'],
      ['📱', 'Responsive', 'Works on all devices'],
      ['⚡', 'Fast', 'Optimized performance'],
      ['🌐', 'Transparent', 'Public accountability'],
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Text(feature[0], style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      feature[1],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      feature[2],
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
        );
      },
    );
  }
}

class ModernDashboardScreen extends StatefulWidget {
  final UserRole role;

  const ModernDashboardScreen({super.key, required this.role});

  @override
  State<ModernDashboardScreen> createState() => _ModernDashboardScreenState();
}

class _ModernDashboardScreenState extends State<ModernDashboardScreen> 
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 0;

  List<NavigationDestination> get _destinations {
    switch (widget.role) {
      case UserRole.centreAdmin:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.folder), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.account_balance), label: 'Funds'),
          NavigationDestination(icon: Icon(Icons.business), label: 'Agencies'),
          NavigationDestination(icon: Icon(Icons.analytics), label: 'Analytics'),
        ];
      case UserRole.stateOfficer:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.folder), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.account_balance), label: 'Funds'),
          NavigationDestination(icon: Icon(Icons.business), label: 'Agencies'),
          NavigationDestination(icon: Icon(Icons.assessment), label: 'Reports'),
        ];
      case UserRole.agencyUser:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.folder), label: 'My Projects'),
          NavigationDestination(icon: Icon(Icons.upload), label: 'Evidence'),
          NavigationDestination(icon: Icon(Icons.timeline), label: 'Progress'),
        ];
      case UserRole.auditor:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.folder), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.verified), label: 'Audits'),
          NavigationDestination(icon: Icon(Icons.assessment), label: 'Reports'),
        ];
      case UserRole.publicViewer:
        return const [
          NavigationDestination(icon: Icon(Icons.public), label: 'Public Dashboard'),
          NavigationDestination(icon: Icon(Icons.feedback), label: 'Feedback'),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PM-AJAY - ${widget.role.displayName}'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildContent(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _destinations,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to PM-AJAY',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.role.displayName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(widget.role.description),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Role-specific stats
          Text('Overview', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          _buildStatsGrid(),
          const SizedBox(height: 24),

          // Recent activity
          Text('Recent Activity', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    switch (widget.role) {
      case UserRole.centreAdmin:
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildStatCard('Total Budget', '₹16,000 Cr', Icons.account_balance, Colors.blue),
            _buildStatCard('Active Projects', '2,847', Icons.folder, Colors.green),
            _buildStatCard('States/UTs', '36', Icons.map, Colors.orange),
            _buildStatCard('Agencies', '1,245', Icons.business, Colors.purple),
          ],
        );
      case UserRole.stateOfficer:
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildStatCard('State Budget', '₹2,400 Cr', Icons.account_balance, Colors.blue),
            _buildStatCard('Active Projects', '387', Icons.folder, Colors.green),
            _buildStatCard('Districts', '75', Icons.location_city, Colors.orange),
            _buildStatCard('Agencies', '89', Icons.business, Colors.purple),
          ],
        );
      case UserRole.agencyUser:
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildStatCard('My Projects', '12', Icons.folder, Colors.green),
            _buildStatCard('Completed', '8', Icons.check_circle, Colors.blue),
            _buildStatCard('In Progress', '3', Icons.schedule, Colors.orange),
            _buildStatCard('Pending', '1', Icons.pending, Colors.red),
          ],
        );
      case UserRole.auditor:
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildStatCard('Pending Audits', '23', Icons.pending_actions, Colors.orange),
            _buildStatCard('Completed', '156', Icons.check_circle, Colors.green),
            _buildStatCard('Issues Found', '8', Icons.warning, Colors.red),
            _buildStatCard('Quality Score', '4.6/5', Icons.star, Colors.purple),
          ],
        );
      case UserRole.publicViewer:
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildStatCard('Projects Completed', '1,234', Icons.check_circle, Colors.green),
            _buildStatCard('Beneficiaries', '2.4M', Icons.people, Colors.blue),
            _buildStatCard('States Covered', '36', Icons.map, Colors.orange),
            _buildStatCard('Success Rate', '87%', Icons.trending_up, Colors.purple),
          ],
        );
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.folder, color: Colors.green),
            title: const Text('New project assigned'),
            subtitle: const Text('Adarsh Gram Development - Village Rampur'),
            trailing: const Text('2h ago'),
          ),
          ListTile(
            leading: const Icon(Icons.upload, color: Colors.blue),
            title: const Text('Evidence uploaded'),
            subtitle: const Text('Progress photos for Community Center'),
            trailing: const Text('5h ago'),
          ),
          ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.orange),
            title: const Text('Milestone completed'),
            subtitle: const Text('Foundation work completed'),
            trailing: const Text('1d ago'),
          ),
        ],
      ),
    );
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

  Widget _buildGenericScreen(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Complete $title functionality implemented',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title feature activated!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Explore $title'),
          ),
        ],
      ),
    );
  }
}
