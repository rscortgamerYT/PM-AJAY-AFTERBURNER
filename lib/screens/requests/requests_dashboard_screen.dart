import 'package:flutter/material.dart';
import 'package:pmajay_app/models/requests/state_request.dart';
import 'package:pmajay_app/models/requests/public_request.dart';
import 'package:pmajay_app/models/requests/agency_request.dart';
import 'package:pmajay_app/models/requests/notification.dart';
import 'package:pmajay_app/repositories/state_request_repository.dart';
import 'package:pmajay_app/repositories/public_request_repository.dart';
import 'package:pmajay_app/repositories/agency_request_repository.dart';
import 'package:pmajay_app/services/notification_service.dart';
import 'package:pmajay_app/screens/requests/state_request_form_screen.dart';

class RequestsDashboardScreen extends StatefulWidget {
  const RequestsDashboardScreen({Key? key}) : super(key: key);

  @override
  State<RequestsDashboardScreen> createState() => _RequestsDashboardScreenState();
}

class _RequestsDashboardScreenState extends State<RequestsDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StateRequestRepository _stateRepository = StateRequestRepository();
  final PublicRequestRepository _publicRepository = PublicRequestRepository();
  final AgencyRequestRepository _agencyRepository = AgencyRequestRepository();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Management'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'State Requests'),
            Tab(text: 'Public Requests'),
            Tab(text: 'Agency Requests'),
            Tab(text: 'Notifications'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const StateRequestFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStateRequestsTab(),
          _buildPublicRequestsTab(),
          _buildAgencyRequestsTab(),
          _buildNotificationsTab(),
        ],
      ),
    );
  }

  Widget _buildStateRequestsTab() {
    return StreamBuilder<List<StateRequest>>(
      stream: _stateRepository.watchStateRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final requests = snapshot.data ?? [];

        if (requests.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No state requests yet'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: request.priority.color,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(
                  request.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.requestType.displayName),
                    Text(
                      request.status.displayName,
                      style: TextStyle(color: request.status.color),
                    ),
                  ],
                ),
                trailing: Text(
                  _formatDate(request.createdAt),
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {
                  _showRequestDetails(context, request);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPublicRequestsTab() {
    return StreamBuilder<List<PublicRequest>>(
      stream: _publicRepository.watchPublicRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final requests = snapshot.data ?? [];

        if (requests.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No public requests yet'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const Icon(Icons.people),
                title: Text(
                  request.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${request.district}, ${request.village}'),
                    Text(
                      request.status.displayName,
                      style: TextStyle(color: request.status.color),
                    ),
                  ],
                ),
                trailing: Text(
                  _formatDate(request.createdAt),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAgencyRequestsTab() {
    return StreamBuilder<List<AgencyRequest>>(
      stream: _agencyRepository.watchAgencyRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final requests = snapshot.data ?? [];

        if (requests.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No agency requests yet'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const Icon(Icons.business),
                title: Text(
                  request.agencyName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.agencyType.displayName),
                    Text(
                      request.status.displayName,
                      style: TextStyle(color: request.status.color),
                    ),
                  ],
                ),
                trailing: Text(
                  _formatDate(request.createdAt),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNotificationsTab() {
    return StreamBuilder<List<AppNotification>>(
      stream: _notificationService.watchNotifications('user-id'), // TODO: Get actual user ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final notifications = snapshot.data ?? [];

        if (notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No notifications'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: notification.readStatus ? null : Colors.blue.shade50,
              child: ListTile(
                leading: Icon(
                  notification.readStatus ? Icons.notifications_none : Icons.notifications_active,
                  color: notification.readStatus ? Colors.grey : Colors.blue,
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.readStatus ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Text(notification.message),
                trailing: Text(
                  _formatDate(notification.createdAt),
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {
                  if (!notification.readStatus) {
                    _notificationService.markAsRead(notification.id);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showRequestDetails(BuildContext context, StateRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Type', request.requestType.displayName),
              _buildDetailRow('Status', request.status.displayName),
              _buildDetailRow('Priority', request.priority.displayName),
              _buildDetailRow('State', request.stateCode),
              if (request.requestedAmount != null)
                _buildDetailRow('Amount', '₹${request.requestedAmount!.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(request.description),
              if (request.centreReviewNotes != null) ...[
                const SizedBox(height: 16),
                const Text('Centre Review:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(request.centreReviewNotes!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}