class DocumentReference {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final int fileSize;
  final DateTime uploadedAt;

  DocumentReference({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.fileSize,
    required this.uploadedAt,
  });

  factory DocumentReference.fromJson(Map<String, dynamic> json) {
    return DocumentReference(
      id: json['id'] ?? '',
      fileName: json['file_name'] ?? '',
      fileUrl: json['file_url'] ?? '',
      fileType: json['file_type'] ?? '',
      fileSize: json['file_size'] ?? 0,
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.parse(json['uploaded_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_name': fileName,
      'file_url': fileUrl,
      'file_type': fileType,
      'file_size': fileSize,
      'uploaded_at': uploadedAt.toIso8601String(),
    };
  }
}