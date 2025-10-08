import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../models/user_role.dart';
import '../../../models/hub/document.dart';

class DocumentsScreen extends StatefulWidget {
  final UserRole userRole;

  const DocumentsScreen({
    super.key,
    required this.userRole,
  });

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String _selectedFolder = 'all';
  String _selectedSort = 'updated_desc';
  final List<HubDocument> _documents = _getDemoDocuments();
  final List<DocumentFolder> _folders = _getDemoFolders();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildFolderNavigation(),
        _buildFiltersAndSort(),
        Expanded(
          child: _buildDocumentGrid(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          const Icon(Symbols.folder, size: 24),
          const SizedBox(width: 12),
          const Text(
            'Document Library',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          _buildStorageInfo(),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => _uploadDocument(),
            icon: const Icon(Symbols.upload_file, size: 18),
            label: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.cloud,
            size: 16,
            color: Colors.blue[600],
          ),
          const SizedBox(width: 4),
          Text(
            '2.4 GB / 10 GB',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderNavigation() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[50],
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _folders.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildFolderChip('all', 'All Documents', _documents.length);
                }
                final folder = _folders[index - 1];
                final docCount = _documents.where((d) => d.folderId == folder.id).length;
                return _buildFolderChip(folder.id, folder.name, docCount);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Symbols.create_new_folder),
            onPressed: () => _createFolder(),
            tooltip: 'Create folder',
          ),
        ],
      ),
    );
  }

  Widget _buildFolderChip(String folderId, String name, int count) {
    final isSelected = _selectedFolder == folderId;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              folderId == 'all' ? Symbols.folder_open : Symbols.folder,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(name),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFolder = folderId;
          });
        },
      ),
    );
  }

  Widget _buildFiltersAndSort() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          DropdownButton<String>(
            value: _selectedSort,
            items: const [
              DropdownMenuItem(value: 'updated_desc', child: Text('Recently Updated')),
              DropdownMenuItem(value: 'created_desc', child: Text('Recently Created')),
              DropdownMenuItem(value: 'name_asc', child: Text('Name A-Z')),
              DropdownMenuItem(value: 'size_desc', child: Text('Largest First')),
              DropdownMenuItem(value: 'downloads_desc', child: Text('Most Downloaded')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedSort = value!;
              });
            },
            underline: const SizedBox(),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Symbols.search),
            onPressed: () => _showSearch(),
            tooltip: 'Search documents',
          ),
          IconButton(
            icon: const Icon(Symbols.filter_list),
            onPressed: () => _showFilters(),
            tooltip: 'Filter documents',
          ),
          IconButton(
            icon: const Icon(Symbols.view_list),
            onPressed: () => _toggleView(),
            tooltip: 'Toggle view',
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentGrid() {
    final filteredDocs = _getFilteredDocuments();
    
    if (filteredDocs.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: filteredDocs.length,
      itemBuilder: (context, index) {
        final document = filteredDocs[index];
        return _buildDocumentCard(document);
      },
    );
  }

  Widget _buildDocumentCard(HubDocument document) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _openDocument(document),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getDocumentIcon(document.fileExtension),
                    size: 32,
                    color: _getDocumentColor(document.fileExtension),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (action) => _handleDocumentAction(document, action),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'download',
                        child: Row(
                          children: [
                            Icon(Symbols.download),
                            SizedBox(width: 8),
                            Text('Download'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Symbols.share),
                            SizedBox(width: 8),
                            Text('Share'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'versions',
                        child: Row(
                          children: [
                            Icon(Symbols.history),
                            SizedBox(width: 8),
                            Text('Version History'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Symbols.delete),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    child: const Icon(Symbols.more_vert, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                document.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                document.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  if (document.versions.length > 1) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'v${document.versions.length}',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: Text(
                      _formatFileSize(document.fileSizeBytes),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Symbols.person,
                    size: 10,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      document.uploaderName,
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey[500],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Text(
                _formatTimestamp(document.updatedAt),
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Symbols.folder_open,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No documents found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload documents to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _uploadDocument(),
            icon: const Icon(Symbols.upload_file),
            label: const Text('Upload Document'),
          ),
        ],
      ),
    );
  }

  List<HubDocument> _getFilteredDocuments() {
    var filtered = _selectedFolder == 'all' 
        ? _documents 
        : _documents.where((d) => d.folderId == _selectedFolder).toList();

    // Sort
    switch (_selectedSort) {
      case 'updated_desc':
        filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case 'created_desc':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'name_asc':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'size_desc':
        filtered.sort((a, b) => b.fileSizeBytes.compareTo(a.fileSizeBytes));
        break;
      case 'downloads_desc':
        filtered.sort((a, b) => b.downloadCount.compareTo(a.downloadCount));
        break;
    }

    return filtered;
  }

  IconData _getDocumentIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Symbols.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Symbols.description;
      case 'xls':
      case 'xlsx':
        return Symbols.table_chart;
      case 'ppt':
      case 'pptx':
        return Symbols.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Symbols.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Symbols.video_file;
      default:
        return Symbols.insert_drive_file;
    }
  }

  Color _getDocumentColor(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Colors.purple;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _uploadDocument() {
    // Show upload dialog
  }

  void _createFolder() {
    // Show create folder dialog
  }

  void _showSearch() {
    // Show search interface
  }

  void _showFilters() {
    // Show filter options
  }

  void _toggleView() {
    // Toggle between grid and list view
  }

  void _openDocument(HubDocument document) {
    // Open document viewer
  }

  void _handleDocumentAction(HubDocument document, String action) {
    switch (action) {
      case 'download':
        // Download document
        break;
      case 'share':
        // Share document
        break;
      case 'versions':
        // Show version history
        break;
      case 'delete':
        // Delete document
        break;
    }
  }

  static List<DocumentFolder> _getDemoFolders() {
    return [
      DocumentFolder(
        id: 'guidelines',
        name: 'Guidelines',
        description: 'Policy guidelines and SOPs',
        path: '/guidelines',
        contextId: 'pm_ajay',
        contextType: 'scheme',
        createdById: 'centre_admin',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        allowedRoles: ['Centre Admin', 'State Officer', 'Agency User'],
        documentCount: 12,
      ),
      DocumentFolder(
        id: 'reports',
        name: 'Reports',
        description: 'Progress and audit reports',
        path: '/reports',
        contextId: 'pm_ajay',
        contextType: 'scheme',
        createdById: 'centre_admin',
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        allowedRoles: ['Centre Admin', 'State Officer', 'Auditor'],
        documentCount: 8,
      ),
      DocumentFolder(
        id: 'certificates',
        name: 'Certificates',
        description: 'Completion and compliance certificates',
        path: '/certificates',
        contextId: 'pm_ajay',
        contextType: 'scheme',
        createdById: 'state_officer',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        allowedRoles: ['State Officer', 'Agency User', 'Auditor'],
        documentCount: 15,
      ),
    ];
  }

  static List<HubDocument> _getDemoDocuments() {
    final now = DateTime.now();
    return [
      HubDocument(
        id: 'doc_001',
        name: 'PM-AJAY Implementation Guidelines v2.1',
        description: 'Updated implementation guidelines for PM-AJAY scheme',
        type: DocumentType.guideline,
        accessLevel: DocumentAccessLevel.internal,
        folderId: 'guidelines',
        folderPath: '/guidelines',
        uploaderId: 'centre_admin',
        uploaderName: 'Centre Admin',
        uploaderRole: 'Centre Admin',
        fileUrl: '/documents/pm_ajay_guidelines_v2.1.pdf',
        fileName: 'pm_ajay_guidelines_v2.1.pdf',
        fileExtension: 'pdf',
        fileSizeBytes: 2048576,
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 2)),
        tags: ['guidelines', 'implementation', 'policy'],
        downloadCount: 45,
        versions: [
          DocumentVersion(
            id: 'ver_001',
            documentId: 'doc_001',
            versionNumber: 1,
            fileUrl: '/documents/pm_ajay_guidelines_v2.0.pdf',
            fileName: 'pm_ajay_guidelines_v2.0.pdf',
            fileSizeBytes: 1945600,
            uploaderId: 'centre_admin',
            uploaderName: 'Centre Admin',
            createdAt: now.subtract(const Duration(days: 15)),
          ),
          DocumentVersion(
            id: 'ver_002',
            documentId: 'doc_001',
            versionNumber: 2,
            fileUrl: '/documents/pm_ajay_guidelines_v2.1.pdf',
            fileName: 'pm_ajay_guidelines_v2.1.pdf',
            fileSizeBytes: 2048576,
            uploaderId: 'centre_admin',
            uploaderName: 'Centre Admin',
            createdAt: now.subtract(const Duration(days: 2)),
            isCurrent: true,
          ),
        ],
      ),
      HubDocument(
        id: 'doc_002',
        name: 'Q2 2024 Progress Report',
        description: 'Quarterly progress report for all states',
        type: DocumentType.report,
        accessLevel: DocumentAccessLevel.restricted,
        folderId: 'reports',
        folderPath: '/reports',
        uploaderId: 'centre_admin',
        uploaderName: 'Centre Admin',
        uploaderRole: 'Centre Admin',
        fileUrl: '/documents/q2_2024_progress_report.xlsx',
        fileName: 'q2_2024_progress_report.xlsx',
        fileExtension: 'xlsx',
        fileSizeBytes: 1536000,
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 5)),
        tags: ['report', 'progress', 'quarterly'],
        downloadCount: 23,
      ),
      HubDocument(
        id: 'doc_003',
        name: 'Maharashtra Project Completion Certificate',
        description: 'Completion certificate for Project Alpha',
        type: DocumentType.certificate,
        accessLevel: DocumentAccessLevel.internal,
        folderId: 'certificates',
        folderPath: '/certificates',
        uploaderId: 'mh_officer',
        uploaderName: 'Rajesh Kumar',
        uploaderRole: 'State Officer',
        fileUrl: '/documents/mh_project_alpha_certificate.pdf',
        fileName: 'mh_project_alpha_certificate.pdf',
        fileExtension: 'pdf',
        fileSizeBytes: 512000,
        contextId: 'proj_alpha',
        contextType: 'project',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
        tags: ['certificate', 'completion', 'maharashtra'],
        downloadCount: 12,
      ),
    ];
  }
}
