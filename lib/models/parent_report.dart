class ParentReport {
  final int? id;
  final int studentId;
  final DateTime date;
  final int timeSpent;         // en minutes
  final int exercisesDone;     // Nombre d'exercices réalisés
  final int errors;            // Nombre d'erreurs
  final double progressLevel;  // 0.0 à 1.0

  ParentReport({
    this.id,
    required this.studentId,
    required this.date,
    required this.timeSpent,
    required this.exercisesDone,
    required this.errors,
    required this.progressLevel,
  });

  factory ParentReport.fromMap(Map<String, dynamic> map) {
    return ParentReport(
      id: map['id'],
      studentId: map['studentId'],
      date: DateTime.parse(map['date']),
      timeSpent: map['timeSpent'],
      exercisesDone: map['exercisesDone'],
      errors: map['errors'],
      progressLevel: map['progressLevel'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'date': date.toIso8601String(),
      'timeSpent': timeSpent,
      'exercisesDone': exercisesDone,
      'errors': errors,
      'progressLevel': progressLevel,
    };
  }
}