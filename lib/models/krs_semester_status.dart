class KrsSemesterStatus {
  final bool isApproved;
  final String? advisorNote;
  final bool isSubmitted;

  KrsSemesterStatus({
    this.isApproved = false,
    this.advisorNote,
    this.isSubmitted = false,
  });

  factory KrsSemesterStatus.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return KrsSemesterStatus();
    }
    return KrsSemesterStatus(
      isApproved: data['approved'] ?? false,
      advisorNote: data['advisor_note'],
      isSubmitted: data['submitted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'approved': isApproved,
      'advisor_note': advisorNote,
      'submitted': isSubmitted,
    };
  }
}