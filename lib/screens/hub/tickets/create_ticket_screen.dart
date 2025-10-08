import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../models/user_role.dart';
import '../../../models/hub/ticket.dart';

class CreateTicketScreen extends StatefulWidget {
  final UserRole userRole;

  const CreateTicketScreen({
    super.key,
    required this.userRole,
  });

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  TicketCategory _selectedCategory = TicketCategory.technical;
  TicketPriority _selectedPriority = TicketPriority.medium;
  String? _selectedContext;
  String? _selectedContextType;
  final List<String> _attachments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Ticket'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfo(),
              const SizedBox(height: 24),
              _buildCategoryAndPriority(),
              const SizedBox(height: 24),
              _buildContextSelection(),
              const SizedBox(height: 24),
              _buildAttachments(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'Brief description of the issue',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description *',
                hintText: 'Detailed description of the issue or request',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryAndPriority() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category & Priority',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<TicketCategory>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: TicketCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Icon(
                              _getCategoryIcon(category),
                              size: 16,
                              color: _getCategoryColor(category),
                            ),
                            const SizedBox(width: 8),
                            Text(_getCategoryLabel(category)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<TicketPriority>(
                    value: _selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: TicketPriority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Row(
                          children: [
                            Icon(
                              _getPriorityIcon(priority),
                              size: 16,
                              color: _getPriorityColor(priority),
                            ),
                            const SizedBox(width: 8),
                            Text(_getPriorityLabel(priority)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCategoryDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDescription() {
    String description;
    switch (_selectedCategory) {
      case TicketCategory.technical:
        description = 'Issues related to system functionality, bugs, or technical problems';
        break;
      case TicketCategory.financial:
        description = 'Fund transfers, budget allocations, financial discrepancies';
        break;
      case TicketCategory.administrative:
        description = 'Policy questions, process clarifications, administrative requests';
        break;
      case TicketCategory.policy:
        description = 'Policy interpretations, guideline clarifications, compliance issues';
        break;
      case TicketCategory.grievance:
        description = 'Public complaints, transparency issues, grievance redressal';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getCategoryColor(_selectedCategory).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getCategoryColor(_selectedCategory).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Symbols.info,
            size: 16,
            color: _getCategoryColor(_selectedCategory),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: _getCategoryColor(_selectedCategory),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Context (Optional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Link this ticket to a specific project, request, or audit',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedContextType,
                    decoration: const InputDecoration(
                      labelText: 'Context Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'project',
                        child: Text('Project'),
                      ),
                      DropdownMenuItem(
                        value: 'request',
                        child: Text('State Request'),
                      ),
                      DropdownMenuItem(
                        value: 'audit',
                        child: Text('Audit'),
                      ),
                      DropdownMenuItem(
                        value: 'scheme',
                        child: Text('Scheme'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedContextType = value;
                        _selectedContext = null; // Reset context when type changes
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedContext,
                    decoration: const InputDecoration(
                      labelText: 'Context Item',
                      border: OutlineInputBorder(),
                    ),
                    items: _getContextItems(),
                    onChanged: _selectedContextType != null
                        ? (value) {
                            setState(() {
                              _selectedContext = value;
                            });
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachments() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Attachments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addAttachment,
                  icon: const Icon(Symbols.attach_file),
                  label: const Text('Add File'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Attach relevant documents, screenshots, or evidence',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            if (_attachments.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      Symbols.cloud_upload,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No files attached',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: _attachments.map((attachment) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Symbols.attach_file, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            attachment.split('/').last,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Symbols.close, size: 16),
                          onPressed: () => _removeAttachment(attachment),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitTicket,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Create Ticket',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getContextItems() {
    if (_selectedContextType == null) return [];

    // Mock data - in real app, fetch from API based on context type
    switch (_selectedContextType!) {
      case 'project':
        return [
          const DropdownMenuItem(value: 'proj_alpha', child: Text('Project Alpha')),
          const DropdownMenuItem(value: 'proj_beta', child: Text('Project Beta')),
          const DropdownMenuItem(value: 'proj_gamma', child: Text('Project Gamma')),
        ];
      case 'request':
        return [
          const DropdownMenuItem(value: 'req_001', child: Text('Maharashtra Budget Request')),
          const DropdownMenuItem(value: 'req_002', child: Text('Gujarat Hostel Allocation')),
        ];
      case 'audit':
        return [
          const DropdownMenuItem(value: 'audit_q2_2024', child: Text('Q2 2024 Audit')),
          const DropdownMenuItem(value: 'audit_q1_2024', child: Text('Q1 2024 Audit')),
        ];
      case 'scheme':
        return [
          const DropdownMenuItem(value: 'pm_ajay', child: Text('PM-AJAY')),
        ];
      default:
        return [];
    }
  }

  IconData _getCategoryIcon(TicketCategory category) {
    switch (category) {
      case TicketCategory.technical:
        return Symbols.bug_report;
      case TicketCategory.financial:
        return Symbols.account_balance_wallet;
      case TicketCategory.administrative:
        return Symbols.admin_panel_settings;
      case TicketCategory.policy:
        return Symbols.policy;
      case TicketCategory.grievance:
        return Symbols.report_problem;
    }
  }

  Color _getCategoryColor(TicketCategory category) {
    switch (category) {
      case TicketCategory.technical:
        return Colors.blue;
      case TicketCategory.financial:
        return Colors.green;
      case TicketCategory.administrative:
        return Colors.orange;
      case TicketCategory.policy:
        return Colors.purple;
      case TicketCategory.grievance:
        return Colors.red;
    }
  }

  String _getCategoryLabel(TicketCategory category) {
    switch (category) {
      case TicketCategory.technical:
        return 'Technical';
      case TicketCategory.financial:
        return 'Financial';
      case TicketCategory.administrative:
        return 'Administrative';
      case TicketCategory.policy:
        return 'Policy';
      case TicketCategory.grievance:
        return 'Grievance';
    }
  }

  IconData _getPriorityIcon(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.critical:
        return Symbols.priority_high;
      case TicketPriority.high:
        return Symbols.keyboard_arrow_up;
      case TicketPriority.medium:
        return Symbols.remove;
      case TicketPriority.low:
        return Symbols.keyboard_arrow_down;
    }
  }

  Color _getPriorityColor(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.critical:
        return Colors.red;
      case TicketPriority.high:
        return Colors.orange;
      case TicketPriority.medium:
        return Colors.blue;
      case TicketPriority.low:
        return Colors.green;
    }
  }

  String _getPriorityLabel(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.critical:
        return 'Critical';
      case TicketPriority.high:
        return 'High';
      case TicketPriority.medium:
        return 'Medium';
      case TicketPriority.low:
        return 'Low';
    }
  }

  void _addAttachment() {
    // In a real app, this would open a file picker
    setState(() {
      _attachments.add('mock_file_${_attachments.length + 1}.pdf');
    });
  }

  void _removeAttachment(String attachment) {
    setState(() {
      _attachments.remove(attachment);
    });
  }

  void _submitTicket() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Create ticket object
    final ticket = Ticket(
      id: 'TKT${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      priority: _selectedPriority,
      status: TicketStatus.open,
      submitterId: 'current_user',
      submitterName: 'Current User',
      submitterRole: widget.userRole.name,
      contextId: _selectedContext,
      contextType: _selectedContextType,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      attachments: _attachments,
      dueDate: DateTime.now().add(Duration(
        hours: _selectedPriority == TicketPriority.critical ? 4 :
               _selectedPriority == TicketPriority.high ? 24 :
               _selectedPriority == TicketPriority.medium ? 72 : 168,
      )),
      slaHours: _selectedPriority == TicketPriority.critical ? 4 :
                _selectedPriority == TicketPriority.high ? 24 :
                _selectedPriority == TicketPriority.medium ? 72 : 168,
    );

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket #${ticket.id} created successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back
    Navigator.of(context).pop(ticket);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
