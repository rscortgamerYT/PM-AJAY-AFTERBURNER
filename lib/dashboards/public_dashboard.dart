import 'package:flutter/material.dart';

class PublicDashboard extends StatefulWidget {
  const PublicDashboard({super.key});

  @override
  State<PublicDashboard> createState() => _PublicDashboardState();
}

class _PublicDashboardState extends State<PublicDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Portal'),
        backgroundColor: const Color(0xFF388E3C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF388E3C),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRequestDialog(),
        backgroundColor: const Color(0xFF388E3C),
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHome();
      case 1:
        return _buildRequests();
      case 2:
        return _buildTrack();
      case 3:
        return _buildInfo();
      default:
        return _buildHome();
    }
  }

  Widget _buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF388E3C).withOpacity(0.1),
                  const Color(0xFF388E3C).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to PM-AJAY Public Portal',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF388E3C),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Submit requests, track progress, and access public information',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Quick Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildServiceCard('Submit Request', Icons.request_page, Colors.blue),
              _buildServiceCard('Track Status', Icons.track_changes, Colors.orange),
              _buildServiceCard('View Projects', Icons.visibility, Colors.green),
              _buildServiceCard('Contact Support', Icons.support_agent, Colors.purple),
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
                    'Recent Announcements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAnnouncementItem('New infrastructure projects approved for rural areas', '2 days ago'),
                  _buildAnnouncementItem('Online portal maintenance scheduled for weekend', '5 days ago'),
                  _buildAnnouncementItem('Public consultation meeting for upcoming projects', '1 week ago'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard('Active Projects', '2,450+', Icons.work, Colors.blue),
              _buildStatCard('Completed', '1,200+', Icons.check_circle, Colors.green),
              _buildStatCard('Beneficiaries', '1.2M+', Icons.people, Colors.orange),
              _buildStatCard('Investment', '₹15K Cr', Icons.monetization_on, Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequests() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Requests',
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
              final requests = [
                'Road Repair Request',
                'Water Supply Issue',
                'Street Light Installation',
                'Drainage Problem'
              ];
              final statuses = ['In Progress', 'Pending', 'Completed', 'Under Review'];
              final colors = [Colors.blue, Colors.orange, Colors.green, Colors.purple];
              final dates = ['Oct 5, 2024', 'Oct 3, 2024', 'Sep 28, 2024', 'Sep 25, 2024'];
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colors[index][100],
                    child: Text('${index + 1}'),
                  ),
                  title: Text(requests[index]),
                  subtitle: Text('Submitted: ${dates[index]}'),
                  trailing: Chip(
                    label: Text(statuses[index]),
                    backgroundColor: colors[index][100],
                  ),
                  onTap: () => _showRequestDetails(requests[index], statuses[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrack() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Track Request',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter Request ID',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showTrackingDetails(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF388E3C),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Track Request'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Recent Tracking',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Request #REQ001 - Road Repair',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildTrackingStep('Request Submitted', 'Oct 5, 2024', true),
                  _buildTrackingStep('Under Review', 'Oct 6, 2024', true),
                  _buildTrackingStep('Approved', 'Oct 7, 2024', true),
                  _buildTrackingStep('Work in Progress', 'Oct 8, 2024', false),
                  _buildTrackingStep('Completed', 'Pending', false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Information Center',
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
              _buildInfoCard('Guidelines', Icons.book, Colors.blue),
              _buildInfoCard('FAQs', Icons.help, Colors.green),
              _buildInfoCard('Contact', Icons.phone, Colors.orange),
              _buildInfoCard('Feedback', Icons.feedback, Colors.purple),
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
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ExpansionTile(
                    title: const Text('How to submit a request?'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: const Text('You can submit a request by clicking the "New Request" button and filling out the required information.'),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('How long does processing take?'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: const Text('Processing time varies by request type, typically 7-15 business days.'),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('How to track my request?'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: const Text('Use the Track tab and enter your request ID to see the current status.'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, Color color) {
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
            ],
          ),
        ),
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
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, IconData icon, Color color) {
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementItem(String announcement, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF388E3C),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(announcement, style: const TextStyle(fontSize: 14)),
                Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStep(String step, String date, bool completed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: completed ? const Color(0xFF388E3C) : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: completed
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: completed ? FontWeight.bold : FontWeight.normal,
                    color: completed ? Colors.black : Colors.grey[600],
                  ),
                ),
                Text(
                  date,
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
    );
  }

  void _showRequestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit New Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Request Type'),
              items: ['Road Repair', 'Water Supply', 'Street Light', 'Drainage', 'Other']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Request submitted successfully!'),
                  backgroundColor: Color(0xFF388E3C),
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showRequestDetails(String request, String status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: $status'),
            const SizedBox(height: 8),
            const Text('Description: Request for immediate attention to the reported issue.'),
            const SizedBox(height: 8),
            const Text('Expected completion: 7-10 business days'),
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

  void _showTrackingDetails() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tracking details displayed below'),
        backgroundColor: Color(0xFF388E3C),
      ),
    );
  }
}
