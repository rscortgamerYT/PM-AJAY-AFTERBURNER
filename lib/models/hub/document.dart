import 'package:equatable/equatable.dart';

enum DocumentType {
  guideline,
  sop,
  report,
  certificate,
  meetingMinutes,
  policy,
  form,
  evidence,
  other
}

enum DocumentAccessLevel {
  public,
  internal,
  restricted,
  confidential
}

class HubDocument extends Equatable {
  final String id;
  final String name;
  final String description;
  final DocumentType type;
  final DocumentAccessLevel accessLevel;
  final String folderId;
  final String folderPath;
  final String uploaderId;
  final String uploaderName;
  final String uploaderRole;
  final String fileUrl;
  final String fileName;
  final String fileExtension;
  final int fileSizeBytes;
  final String? contextId; // project_id, request_id, meeting_id
  final String? contextType; // project, request, meeting, scheme
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final List<DocumentVersion> versions;
  final Map<String, bool> permissions; // userId -> canEdit
  final int downloadCount;
  final DateTime? lastAccessedAt;

  const HubDocument({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.accessLevel,
    required this.folderId,
    required this.folderPath,
    required this.uploaderId,
    required this.uploaderName,
    required this.uploaderRole,
    required this.fileUrl,
    required this.fileName,
    required this.fileExtension,
    required this.fileSizeBytes,
    this.contextId,
    this.contextType,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.versions = const [],
    this.permissions = const {},
    this.downloadCount = 0,
    this.lastAccessedAt,
  });

  factory HubDocument.fromJson(Map<String, dynamic> json) {
    return HubDocument(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: DocumentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DocumentType.other,
      ),
      accessLevel: DocumentAccessLevel.values.firstWhere(
        (e) => e.name == json['access_level'],
        orElse: () => DocumentAccessLevel.internal,
      ),
      folderId: json['folder_id'] as String,
      folderPath: json['folder_path'] as String,
      uploaderId: json['uploader_id'] as String,
      uploaderName: json['uploader_name'] as String,
      uploaderRole: json['uploader_role'] as String,
      fileUrl: json['file_url'] as String,
      fileName: json['file_name'] as String,
      fileExtension: json['file_extension'] as String,
      fileSizeBytes: json['file_size_bytes'] as int,
      contextId: json['context_id'] as String?,
      contextType: json['context_type'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      versions: (json['versions'] as List<dynamic>?)
              ?.map((e) => DocumentVersion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      permissions: (json['permissions'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as bool)) ??
          {},
      downloadCount: json['download_count'] as int? ?? 0,
      lastAccessedAt: json['last_accessed_at'] != null
          ? DateTime.parse(json['last_accessed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'access_level': accessLevel.name,
      'folder_id': folderId,
      'folder_path': folderPath,
      'uploader_id': uploaderId,
      'uploader_name': uploaderName,
      'uploader_role': uploaderRole,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_extension': fileExtension,
      'file_size_bytes': fileSizeBytes,
      'context_id': contextId,
      'context_type': contextType,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'tags': tags,
      'versions': versions.map((v) => v.toJson()).toList(),
      'permissions': permissions,
      'download_count': downloadCount,
      'last_accessed_at': lastAccessedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        accessLevel,
        folderId,
        folderPath,
        uploaderId,
        uploaderName,
        uploaderRole,
        fileUrl,
        fileName,
        fileExtension,
        fileSizeBytes,
        contextId,
        contextType,
        createdAt,
        updatedAt,
        tags,
        versions,
        permissions,
        downloadCount,
        lastAccessedAt,
      ];
}

class DocumentVersion extends Equatable {
  final String id;
  final String documentId;
  final int versionNumber;
  final String fileUrl;
  final String fileName;
  final int fileSizeBytes;
  final String uploaderId;
  final String uploaderName;
  final DateTime createdAt;
  final String? changeLog;
  final bool isCurrent;

  const DocumentVersion({
    required this.id,
    required this.documentId,
    required this.versionNumber,
    required this.fileUrl,
    required this.fileName,
    required this.fileSizeBytes,
    required this.uploaderId,
    required this.uploaderName,
    required this.createdAt,
    this.changeLog,
    this.isCurrent = false,
  });

  factory DocumentVersion.fromJson(Map<String, dynamic> json) {
    return DocumentVersion(
      id: json['id'] as String,
      documentId: json['document_id'] as String,
      versionNumber: json['version_number'] as int,
      fileUrl: json['file_url'] as String,
      fileName: json['file_name'] as String,
      fileSizeBytes: json['file_size_bytes'] as int,
      uploaderId: json['uploader_id'] as String,
      uploaderName: json['uploader_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      changeLog: json['change_log'] as String?,
      isCurrent: json['is_current'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'document_id': documentId,
      'version_number': versionNumber,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_size_bytes': fileSizeBytes,
      'uploader_id': uploaderId,
      'uploader_name': uploaderName,
      'created_at': createdAt.toIso8601String(),
      'change_log': changeLog,
      'is_current': isCurrent,
    };
  }

  @override
  List<Object?> get props => [
        id,
        documentId,
        versionNumber,
        fileUrl,
        fileName,
        fileSizeBytes,
        uploaderId,
        uploaderName,
        createdAt,
        changeLog,
        isCurrent,
      ];
}

class DocumentFolder extends Equatable {
  final String id;
  final String name;
  final String description;
  final String path;
  final String? parentId;
  final String contextId; // scheme_id, state_id, project_id
  final String contextType; // scheme, state, project, audit
  final String createdById;
  final DateTime createdAt;
  final List<String> allowedRoles;
  final Map<String, bool> permissions; // userId -> canWrite
  final int documentCount;

  const DocumentFolder({
    required this.id,
    required this.name,
    required this.description,
    required this.path,
    this.parentId,
    required this.contextId,
    required this.contextType,
    required this.createdById,
    required this.createdAt,
    this.allowedRoles = const [],
    this.permissions = const {},
    this.documentCount = 0,
  });

  factory DocumentFolder.fromJson(Map<String, dynamic> json) {
    return DocumentFolder(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      path: json['path'] as String,
      parentId: json['parent_id'] as String?,
      contextId: json['context_id'] as String,
      contextType: json['context_type'] as String,
      createdById: json['created_by_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      allowedRoles: (json['allowed_roles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      permissions: (json['permissions'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as bool)) ??
          {},
      documentCount: json['document_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'path': path,
      'parent_id': parentId,
      'context_id': contextId,
      'context_type': contextType,
      'created_by_id': createdById,
      'created_at': createdAt.toIso8601String(),
      'allowed_roles': allowedRoles,
      'permissions': permissions,
      'document_count': documentCount,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        path,
        parentId,
        contextId,
        contextType,
        createdById,
        createdAt,
        allowedRoles,
        permissions,
        documentCount,
      ];
}
