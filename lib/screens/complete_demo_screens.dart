import 'package:flutter/material.dart';
import '../widgets/dashboard_widgets.dart';

class CompleteDemoScreens {
  // Projects Management Screen
  static Widget buildProjectsManagement(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Projects Management', style: Theme.of(context).textTheme.headlineSmall),
              FilledButton.icon(
                onPressed: () => _showCreateProjectDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('New Project'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Filter chips
          Wrap(
            spacing: 8,
            children: [
              FilterChip(label: const Text('All'), selected: true, onSelected: (v) {}),
              FilterChip(label: const Text('Adarsh Gram'), selected: false, onSelected: (v) {}),
              FilterChip(label: const Text('Hostel'), selected: false, onSelected: (v) {}),
              FilterChip(label: const Text('GIA'), selected: false, onSelected: (v) {}),
            ],
          ),
          const SizedBox(height: 16),
          
          // Projects grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              DashboardWidgets.buildProjectCard(context, 'Adarsh Gram Development', 'Village Rampur, UP', 'Active', Colors.green, 70.0),
              DashboardWidgets.buildProjectCard(context, 'SC/ST Hostel Construction', 'Bangalore, KA', 'Active', Colors.blue, 30.0),
              DashboardWidgets.buildProjectCard(context, 'General Infrastructure', 'Delhi NCR', 'Completed', Colors.purple, 100.0),
              DashboardWidgets.buildProjectCard(context, 'Community Center', 'Mumbai, MH', 'Draft', Colors.orange, 0.0),
              DashboardWidgets.buildProjectCard(context, 'Skill Development Center', 'Chennai, TN', 'Active', Colors.green, 55.0),
              DashboardWidgets.buildProjectCard(context, 'Healthcare Facility', 'Kolkata, WB', 'Planning', Colors.grey, 10.0),
            ],
          ),
        ],
      ),
    );
  }

  // Funds Management Screen
  static Widget buildFundsManagement(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PFMS Fund Tracking', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          
          // Fund overview cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              DashboardWidgets.buildStatCard(context, 'Total Sanctioned', '₹16,000 Cr', Icons.account_balance, Colors.blue),
              DashboardWidgets.buildStatCard(context, 'Released', '₹12,800 Cr', Icons.trending_up, Colors.green),
              DashboardWidgets.buildStatCard(context, 'Utilized', '₹9,600 Cr', Icons.payments, Colors.orange),
            ],
          ),
          const SizedBox(height: 24),
          
          // Recent transactions
          Text('Recent Fund Transfers', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _buildFundTransferTile(context, 'Centre → Uttar Pradesh', '₹240 Cr', 'Processed', Colors.green),
                _buildFundTransferTile(context, 'Uttar Pradesh → DDA', '₹45 Cr', 'Pending', Colors.orange),
                _buildFundTransferTile(context, 'Centre → Karnataka', '₹180 Cr', 'Processed', Colors.green),
                _buildFundTransferTile(context, 'Karnataka → KIC', '₹32 Cr', 'Processing', Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Agency Management Screen
  static Widget buildAgencyManagement(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Agency Registry', style: Theme.of(context).textTheme.headlineSmall),
              FilledButton.icon(
                onPressed: () => _showAddAgencyDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Agency'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Agency stats
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              DashboardWidgets.buildStatCard(context, 'Total Agencies', '1,245', Icons.business, Colors.blue),
              DashboardWidgets.buildStatCard(context, 'Active', '1,156', Icons.check_circle, Colors.green),
              DashboardWidgets.buildStatCard(context, 'High Rated', '892', Icons.star, Colors.orange),
              DashboardWidgets.buildStatCard(context, 'New This Month', '23', Icons.new_releases, Colors.purple),
            ],
          ),
          const SizedBox(height: 24),
          
          // Agency list
          Text('Top Performing Agencies', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _buildAgencyTile(context, 'Delhi Development Agency', 'Delhi', '4.8', '23 projects'),
                _buildAgencyTile(context, 'Maharashtra Rural Development', 'Maharashtra', '4.7', '45 projects'),
                _buildAgencyTile(context, 'Karnataka Infrastructure Corp', 'Karnataka', '4.6', '38 projects'),
                _buildAgencyTile(context, 'UP Development Authority', 'Uttar Pradesh', '4.5', '67 projects'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Evidence Upload Screen
  static Widget buildEvidenceUpload(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Evidence Upload', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          
          // Upload section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upload Project Evidence', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Project',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '1', child: Text('Adarsh Gram Development')),
                      DropdownMenuItem(value: '2', child: Text('Community Center')),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showImagePicker(context),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Take Photo'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showFilePicker(context),
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Upload File'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  FilledButton(
                    onPressed: () => _showSuccessSnackbar(context),
                    child: const Text('Submit Evidence'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Recent uploads
          Text('Recent Uploads', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildEvidenceCard(context, 'Foundation Work', 'Adarsh Gram', '2 days ago'),
              _buildEvidenceCard(context, 'Progress Report', 'Community Center', '5 days ago'),
              _buildEvidenceCard(context, 'Quality Check', 'Adarsh Gram', '1 week ago'),
              _buildEvidenceCard(context, 'Milestone 2', 'Community Center', '2 weeks ago'),
            ],
          ),
        ],
      ),
    );
  }

  // Analytics Screen
  static Widget buildAnalytics(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Analytics & Reports', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          
          // Key metrics
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              DashboardWidgets.buildStatCard(context, 'Completion Rate', '87%', Icons.check_circle, Colors.green),
              DashboardWidgets.buildStatCard(context, 'On-Time Delivery', '92%', Icons.schedule, Colors.blue),
              DashboardWidgets.buildStatCard(context, 'Budget Utilization', '75%', Icons.account_balance, Colors.orange),
              DashboardWidgets.buildStatCard(context, 'Quality Score', '4.6/5', Icons.star, Colors.purple),
            ],
          ),
          const SizedBox(height: 24),
          
          // Charts placeholder
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Project Progress Trends', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Chart visualization will be implemented here'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Public Feedback System
  static Widget buildFeedbackSystem(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Public Feedback', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          
          // Feedback form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Submit Feedback', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Your Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Email (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  const TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Your Feedback',
                      border: OutlineInputBorder(),
                      hintText: 'Share your thoughts about PM-AJAY projects...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  FilledButton(
                    onPressed: () => _showSuccessSnackbar(context),
                    child: const Text('Submit Feedback'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  static Widget _buildFundTransferTile(BuildContext context, String transfer, String amount, String status, Color statusColor) {
    return ListTile(
      leading: Icon(Icons.account_balance_wallet, color: statusColor),
      title: Text(transfer),
      subtitle: Text(amount),
      trailing: Chip(
        label: Text(status),
        backgroundColor: statusColor.withOpacity(0.2),
        labelStyle: TextStyle(color: statusColor),
      ),
    );
  }

  static Widget _buildAgencyTile(BuildContext context, String name, String state, String rating, String projects) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.business)),
      title: Text(name),
      subtitle: Text('$state • $projects'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.orange, size: 16),
          Text(rating),
        ],
      ),
    );
  }

  static Widget _buildEvidenceCard(BuildContext context, String title, String project, String date) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(project, style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            Text(date, style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )),
          ],
        ),
      ),
    );
  }

  // Dialog methods
  static void _showCreateProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Project'),
        content: const Text('Project creation form will be implemented here.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Create')),
        ],
      ),
    );
  }

  static void _showAddAgencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Agency'),
        content: const Text('Agency registration form will be implemented here.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Add')),
        ],
      ),
    );
  }

  static void _showImagePicker(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera functionality will be implemented')),
    );
  }

  static void _showFilePicker(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File picker functionality will be implemented')),
    );
  }

  static void _showSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Success! Data submitted successfully.'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
