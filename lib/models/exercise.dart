class Exercise {
  final int? id;
  final int lessonId;          // Référence à la leçon parente
  final String question;       // La question affichée (ex: "12 + 8 = ?")
  final String correctAnswer;  // La réponse correcte (ex: "20")
  final String type;           // "addition", "soustraction", "orthographe", etc.
  final String difficulty;     // "facile", "moyen", "difficile"

  Exercise({
    this.id,
    required this.lessonId,
    required this.question,
    required this.correctAnswer,
    required this.type,
    required this.difficulty,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      lessonId: map['lessonId'],
      question: map['question'],
      correctAnswer: map['correctAnswer'],
      type: map['type'],
      difficulty: map['difficulty'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lessonId': lessonId,
      'question': question,
      'correctAnswer': correctAnswer,
      'type': type,
      'difficulty': difficulty,
    };
  }
}