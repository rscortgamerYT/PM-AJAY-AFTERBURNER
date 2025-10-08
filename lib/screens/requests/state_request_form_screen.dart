import 'package:flutter/material.dart';
import 'package:pmajay_app/models/requests/state_request.dart';
import 'package:pmajay_app/models/requests/enums.dart';
import 'package:pmajay_app/models/requests/document_reference.dart';
import 'package:pmajay_app/repositories/state_request_repository.dart';

class StateRequestFormScreen extends StatefulWidget {
  const StateRequestFormScreen({Key? key}) : super(key: key);

  @override
  State<StateRequestFormScreen> createState() => _StateRequestFormScreenState();
}

class _StateRequestFormScreenState extends State<StateRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  
  StateRequestType? _selectedRequestType;
  PriorityLevel _selectedPriority = PriorityLevel.medium;
  List<DocumentReference> _uploadedDocuments = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit State Request'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRequestDetailsCard(),
              const SizedBox(height: 16),
              _buildDocumentUploadCard(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestDetailsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Request Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Request Type Dropdown
            DropdownButtonFormField<StateRequestType>(
              decoration: const InputDecoration(
                labelText: 'Request Type',
                border: OutlineInputBorder(),
              ),
              value: _selectedRequestType,
              items: StateRequestType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRequestType = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select request type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Request Title',
                border: OutlineInputBorder(),
                hintText: 'Brief title for your request',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter request title';
                }
                if (value.length < 10) {
                  return 'Title must be at least 10 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Description Field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Detailed Description',
                border: OutlineInputBorder(),
                hintText: 'Provide detailed explanation of your request',
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                if (value.length < 50) {
                  return 'Description must be at least 50 characters';
                }
                return null;
              },
            ),
            
            // Amount Field (if applicable)
            if (_selectedRequestType == StateRequestType.fundAllocation) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Requested Amount (₹)',
                  border: OutlineInputBorder(),
                  hintText: 'Amount in rupees',
                  prefixText: '₹ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter requested amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Priority Selection
            DropdownButtonFormField<PriorityLevel>(
              decoration: const InputDecoration(
                labelText: 'Priority Level',
                border: OutlineInputBorder(),
              ),
              value: _selectedPriority,
              items: PriorityLevel.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: priority.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(priority.displayName),
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
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentUploadCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Supporting Documents',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement file picker
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File upload to be implemented')),
                );
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Documents'),
            ),
            if (_uploadedDocuments.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...(_uploadedDocuments.map((doc) => ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(doc.fileName),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _uploadedDocuments.remove(doc);
                    });
                  },
                ),
              ))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : _submitRequest,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isSubmitting
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              'Submit Request',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final request = StateRequest(
        id: '',
        stateCode: 'UP', // TODO: Get from user context
        requestType: _selectedRequestType!,
        title: _titleController.text,
        description: _descriptionController.text,
        requestedAmount: _amountController.text.isNotEmpty
            ? double.parse(_amountController.text)
            : null,
        priority: _selectedPriority,
        documents: _uploadedDocuments,
        hierarchyDetails: HierarchyDetails(
          chiefSecretary: '',
          principalSecretary: '',
          secretarySocialJustice: '',
          directorSocialWelfare: '',
          districtOfficers: [],
        ),
        officerDetails: StateOfficerDetails(
          name: '',
          designation: '',
          email: '',
          phone: '',
          employeeId: '',
          appointmentDate: DateTime.now(),
        ),
        status: RequestStatus.submitted,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final repository = StateRequestRepository();
      await repository.submitStateRequest(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}