class Lesson {
  final int? id;
  final String title;
  final String summary;      // Résumé bref du cours
  final String content;      // Explication détaillée, exemples, étapes
  final String classLevel;   // ex: "SIL", "CP", etc.
  final String subject;      // "Mathématiques", "Lecture", etc.
  final String? audioUrl;    // Chemin vers le fichier audio (optionnel)

  Lesson({
    this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.classLevel,
    required this.subject,
    this.audioUrl,
  });

  // Convertir un objet Map (venant de SQLite) en objet Lesson
  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'],
      title: map['title'],
      summary: map['summary'],
      content: map['content'],
      classLevel: map['classLevel'],
      subject: map['subject'],
      audioUrl: map['audioUrl'],
    );
  }

  // Convertir un objet Lesson en Map (pour SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'classLevel': classLevel,
      'subject': subject,
      'audioUrl': audioUrl,
    };
  }
}