import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../widgets/components/hero_card.dart';
import '../../widgets/feature_access_panel.dart';
import '../../services/supabase_service.dart';
import '../../models/user_role.dart';
import '../../utils/navigation_helper.dart';

class PublicPortalHome extends StatefulWidget {
  const PublicPortalHome({super.key});

  @override
  State<PublicPortalHome> createState() => _PublicPortalHomeState();
}

class _PublicPortalHomeState extends State<PublicPortalHome> {
  bool _isLoading = true;
  int _totalProjects = 0;
  double _totalInvestment = 0;
  int _beneficiaries = 0;
  double _successRate = 0;
  List<Map<String, dynamic>> _recentProjects = [];
  List<Map<String, dynamic>> _successStories = [];
  Map<String, dynamic> _selectedFilters = {};

  @override
  void initState() {
    super.initState();
    _loadPublicData();
  }

  Future<void> _loadPublicData() async {
    setState(() => _isLoading = true);
    
    try {
      final results = await Future.wait([
        _getTotalProjectsCount(),
        _getTotalInvestment(),
        _getBeneficiariesCount(),
        _getSuccessRate(),
        SupabaseService.getPublicProjects({}),
        _getSuccessStories(),
      ]);

      setState(() {
        _totalProjects = results[0] as int;
        _totalInvestment = results[1] as double;
        _beneficiaries = results[2] as int;
        _successRate = results[3] as double;
        _recentProjects = List<Map<String, dynamic>>.from(results[4] as List);
        _successStories = results[5] as List<Map<String, dynamic>>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  Future<int> _getTotalProjectsCount() async {
    final projects = await SupabaseService.query('public_projects_view');
    return projects.length;
  }

  Future<double> _getTotalInvestment() async {
    final investment = await SupabaseService.query('public_investment_summary');
    return investment.isNotEmpty ? investment.first['total_investment']?.toDouble() ?? 0 : 0;
  }

  Future<int> _getBeneficiariesCount() async {
    final beneficiaries = await SupabaseService.query('public_beneficiaries_summary');
    return beneficiaries.isNotEmpty ? beneficiaries.first['total_beneficiaries'] ?? 0 : 0;
  }

  Future<double> _getSuccessRate() async {
    final success = await SupabaseService.query('public_success_rate');
    return success.isNotEmpty ? success.first['success_rate']?.toDouble() ?? 0 : 0;
  }

  Future<List<Map<String, dynamic>>> _getSuccessStories() async {
    return await SupabaseService.query(
      'success_stories',
      orderBy: 'created_at',
      ascending: false,
      limit: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PM-AJAY Public Portal'),
        backgroundColor: const Color(0xFF388E3C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _showFilters,
            icon: const Icon(Symbols.tune),
            tooltip: 'Filters',
          ),
          IconButton(
            onPressed: _loadPublicData,
            icon: const Icon(Symbols.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPublicData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildFullScreenMap(),
              _buildStatsCards(),
              _buildSuccessStoriesCarousel(),
              _buildRecentProjects(),
              FeatureAccessPanel(userRole: UserRole(
                id: 'public_role_001',
                userId: 'public_user',
                roleType: UserRoleType.publicUser,
                createdAt: DateTime.now(),
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitPublicRequest,
        backgroundColor: const Color(0xFF388E3C),
        icon: const Icon(Symbols.add),
        label: const Text('Submit Request'),
      ),
    );
  }

  Widget _buildFullScreenMap() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Stack(
        children: [
          // Full-screen map placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Symbols.public,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Interactive India Map',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explore PM-AJAY projects across India',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _openFullscreenMap,
                  icon: const Icon(Symbols.fullscreen),
                  label: const Text('View Full Map'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF388E3C),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Map controls
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                _buildMapControl(Symbols.add, _zoomIn),
                const SizedBox(height: 8),
                _buildMapControl(Symbols.remove, _zoomOut),
                const SizedBox(height: 8),
                _buildMapControl(Symbols.my_location, _centerMap),
              ],
            ),
          ),
          
          // Legend
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Project Status',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildMapLegend('Completed', Colors.green),
                  _buildMapLegend('In Progress', Colors.blue),
                  _buildMapLegend('Planned', Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControl(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildMapLegend(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          HeroCard(
            title: 'Total Projects',
            value: _isLoading ? '...' : _totalProjects.toString(),
            subtitle: 'Across India',
            icon: Symbols.work,
            color: Colors.blue,
            isLoading: _isLoading,
          ),
          HeroCard(
            title: 'Investment',
            value: _isLoading ? '...' : '₹${_formatAmount(_totalInvestment)}',
            subtitle: 'Total allocated',
            icon: Symbols.account_balance_wallet,
            color: Colors.green,
            isLoading: _isLoading,
          ),
          HeroCard(
            title: 'Beneficiaries',
            value: _isLoading ? '...' : _formatNumber(_beneficiaries),
            subtitle: 'People impacted',
            icon: Symbols.people,
            color: Colors.orange,
            isLoading: _isLoading,
          ),
          HeroCard(
            title: 'Success Rate',
            value: _isLoading ? '...' : '${_successRate.toInt()}%',
            subtitle: 'Project completion',
            icon: Symbols.trending_up,
            color: Colors.purple,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStoriesCarousel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Success Stories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _viewAllStories,
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: _successStories.isEmpty
                ? const Center(child: Text('No success stories available'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _successStories.length,
                    itemBuilder: (context, index) {
                      final story = _successStories[index];
                      return _buildStoryCard(story);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(Map<String, dynamic> story) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: story['image_url'] != null
                    ? DecorationImage(
                        image: NetworkImage(story['image_url']),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: story['image_url'] == null
                  ? const Center(
                      child: Icon(
                        Symbols.image,
                        size: 48,
                        color: Colors.grey,
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    story['location'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentProjects() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Projects',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _viewAllProjects,
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _recentProjects.isEmpty
              ? const Center(child: Text('No recent projects'))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentProjects.take(5).length,
                  itemBuilder: (context, index) {
                    final project = _recentProjects[index];
                    return _buildProjectCard(project);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    final status = project['status'] ?? 'active';
    final progress = project['progress_percentage']?.toDouble() ?? 0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getProjectStatusColor(status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getProjectStatusIcon(status),
            color: _getProjectStatusColor(status),
            size: 20,
          ),
        ),
        title: Text(
          project['project_name'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${project['location']} • ${project['component']}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProjectStatusColor(status),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${progress.toInt()}%',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Symbols.info),
          onPressed: () => _viewProjectDetails(project['id']),
        ),
      ),
    );
  }

  Widget _buildPublicActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Public Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildActionCard(
                'Submit Request',
                Symbols.add_circle,
                Colors.green,
                _submitPublicRequest,
              ),
              _buildActionCard(
                'Track Request',
                Symbols.track_changes,
                Colors.blue,
                _trackRequest,
              ),
              _buildActionCard(
                'Public Forum',
                Symbols.forum,
                Colors.orange,
                _openPublicForum,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getProjectStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      case 'planned':
        return Colors.orange;
      case 'delayed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getProjectStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Symbols.check_circle;
      case 'in_progress':
        return Symbols.play_circle;
      case 'planned':
        return Symbols.schedule;
      case 'delayed':
        return Symbols.warning;
      default:
        return Symbols.circle;
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)} L';
    }
    return amount.toStringAsFixed(0);
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildFilterSheet(),
    );
  }

  Widget _buildFilterSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Projects',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Filter options would go here
          const Text('State, Component, Status filters...'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyFilters();
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    // Apply selected filters and reload data
    _loadPublicData();
  }

  void _openFullscreenMap() {
    NavigationHelper.navigateToPublicMap(context);
  }

  void _zoomIn() {
    NavigationHelper.showInfoMessage(context, 'Zooming in...');
  }

  void _zoomOut() {
    NavigationHelper.showInfoMessage(context, 'Zooming out...');
  }

  void _centerMap() {
    NavigationHelper.showInfoMessage(context, 'Centering map...');
  }

  void _viewAllStories() {
    NavigationHelper.navigateToPublicStories(context);
  }

  void _viewAllProjects() {
    NavigationHelper.navigateToPublicProjects(context);
  }

  void _viewProjectDetails(String projectId) {
    NavigationHelper.showInfoMessage(context, 'Opening project: $projectId');
    NavigationHelper.navigateToPublicProjects(context);
  }

  void _submitPublicRequest() {
    NavigationHelper.navigateToPublicRequest(context);
  }

  void _trackRequest() {
    NavigationHelper.navigateToPublicTrack(context);
  }

  void _openPublicForum() {
    NavigationHelper.navigateToPublicForum(context);
  }
}
