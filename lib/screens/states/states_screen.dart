import 'package:flutter/material.dart';
import 'package:pmajay_app/models/requests/state_request.dart';
import 'package:pmajay_app/repositories/state_request_repository.dart';
import 'package:pmajay_app/models/requests/enums.dart';

class StatesScreen extends StatefulWidget {
  const StatesScreen({Key? key}) : super(key: key);

  @override
  State<StatesScreen> createState() => _StatesScreenState();
}

class _StatesScreenState extends State<StatesScreen> {
  final StateRequestRepository _repository = StateRequestRepository();
  
  // Mock data for participating states
  final List<Map<String, dynamic>> _participatingStates = [
    {
      'code': 'UP',
      'name': 'Uttar Pradesh',
      'fundAllocated': 50000000000.0,
      'fundUtilized': 35000000000.0,
      'activeProjects': 45,
      'completedProjects': 23,
      'registeredAgencies': 67,
    },
    {
      'code': 'MH',
      'name': 'Maharashtra',
      'fundAllocated': 45000000000.0,
      'fundUtilized': 32000000000.0,
      'activeProjects': 38,
      'completedProjects': 19,
      'registeredAgencies': 54,
    },
    {
      'code': 'BR',
      'name': 'Bihar',
      'fundAllocated': 35000000000.0,
      'fundUtilized': 25000000000.0,
      'activeProjects': 32,
      'completedProjects': 15,
      'registeredAgencies': 42,
    },
    {
      'code': 'WB',
      'name': 'West Bengal',
      'fundAllocated': 30000000000.0,
      'fundUtilized': 22000000000.0,
      'activeProjects': 28,
      'completedProjects': 12,
      'registeredAgencies': 38,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('State Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Participating States'),
              Tab(text: 'State Requests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildParticipatingStatesTab(),
            _buildStateRequestsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipatingStatesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _participatingStates.length,
      itemBuilder: (context, index) {
        final state = _participatingStates[index];
        final utilizationPercent = ((state['fundUtilized'] as double) / 
                                    (state['fundAllocated'] as double) * 100).toInt();
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          child: InkWell(
            onTap: () => _showStateDetails(state),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            state['code'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state['name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${state['activeProjects']} Active Projects • ${state['registeredAgencies']} Agencies',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          'Fund Allocated',
                          '₹${_formatCurrency(state['fundAllocated'])}',
                          Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Fund Utilized',
                          '₹${_formatCurrency(state['fundUtilized'])}',
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Fund Utilization',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '$utilizationPercent%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _getUtilizationColor(utilizationPercent),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: utilizationPercent / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getUtilizationColor(utilizationPercent),
                        ),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildProjectCount(
                          'Active',
                          state['activeProjects'].toString(),
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildProjectCount(
                          'Completed',
                          state['completedProjects'].toString(),
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStateRequestsTab() {
    return StreamBuilder<List<StateRequest>>(
      stream: _repository.watchStateRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final requests = snapshot.data ?? [];

        if (requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No state requests',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: request.priority.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_city,
                    color: request.priority.color,
                  ),
                ),
                title: Text(
                  request.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('${request.stateCode} • ${request.requestType.displayName}'),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: request.status.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        request.status.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          color: request.status.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (request.requestedAmount != null)
                      Text(
                        '₹${_formatCurrency(request.requestedAmount!)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(request.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                onTap: () => _showRequestDetails(request),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCount(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getUtilizationColor(int percent) {
    if (percent >= 80) return Colors.green;
    if (percent >= 50) return Colors.orange;
    return Colors.red;
  }

  String _formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)} L';
    }
    return amount.toStringAsFixed(2);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showStateDetails(Map<String, dynamic> state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(state['name']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('State Code', state['code']),
              _buildDetailRow('Fund Allocated', '₹${_formatCurrency(state['fundAllocated'])}'),
              _buildDetailRow('Fund Utilized', '₹${_formatCurrency(state['fundUtilized'])}'),
              _buildDetailRow('Active Projects', state['activeProjects'].toString()),
              _buildDetailRow('Completed Projects', state['completedProjects'].toString()),
              _buildDetailRow('Registered Agencies', state['registeredAgencies'].toString()),
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

  void _showRequestDetails(StateRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('State', request.stateCode),
              _buildDetailRow('Type', request.requestType.displayName),
              _buildDetailRow('Status', request.status.displayName),
              _buildDetailRow('Priority', request.priority.displayName),
              if (request.requestedAmount != null)
                _buildDetailRow('Amount', '₹${_formatCurrency(request.requestedAmount!)}'),
              const SizedBox(height: 16),
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(request.description),
            ],
          ),
        ),
        actions: [
          if (request.status == RequestStatus.submitted) ...[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _approveRequest(request);
              },
              child: const Text('Approve', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _rejectRequest(request);
              },
              child: const Text('Reject', style: TextStyle(color: Colors.red)),
            ),
          ],
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
            width: 120,
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

  Future<void> _approveRequest(StateRequest request) async {
    try {
      await _repository.reviewStateRequest(
        request.id,
        RequestStatus.approved,
        'Approved by Centre Admin',
        approvedGuidelines: 'Follow standard PM-AJAY guidelines',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request approved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _rejectRequest(StateRequest request) async {
    try {
      await _repository.reviewStateRequest(
        request.id,
        RequestStatus.rejected,
        'Rejected by Centre Admin',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request rejected')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}