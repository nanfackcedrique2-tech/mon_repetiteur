class Progress {
  final int? id;
  final int studentId;
  final int lessonId;
  final double score;          // Score en pourcentage (ex: 85.0)
  final int attempts;          // Nombre de tentatives
  final DateTime lastAttemptDate;

  Progress({
    this.id,
    required this.studentId,
    required this.lessonId,
    required this.score,
    required this.attempts,
    required this.lastAttemptDate,
  });

  factory Progress.fromMap(Map<String, dynamic> map) {
    return Progress(
      id: map['id'],
      studentId: map['studentId'],
      lessonId: map['lessonId'],
      score: map['score'].toDouble(),
      attempts: map['attempts'],
      lastAttemptDate: DateTime.parse(map['lastAttemptDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'lessonId': lessonId,
      'score': score,
      'attempts': attempts,
      'lastAttemptDate': lastAttemptDate.toIso8601String(),
    };
  }
}