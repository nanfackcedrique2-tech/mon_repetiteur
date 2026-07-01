class Student {
  final int? id;
  final String name;
  final String classLevel;     // ex: "SIL", "CM1", etc.
  final String system;         // "Francophone" ou "Anglophone"
  int totalPoints;             // Points cumulés
  int level;                   // 1 à 5 (étoiles)
  List<String> badges;         // Liste des badges gagnés (ex: ["3 jours", "10 exercices"])

  Student({
    this.id,
    required this.name,
    required this.classLevel,
    required this.system,
    this.totalPoints = 0,
    this.level = 1,
    this.badges = const [],
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    // Les badges sont stockés en JSON dans la base, on les convertit
    List<String> badgeList = [];
    if (map['badges'] != null) {
      badgeList = List<String>.from(map['badges']);
    }
    return Student(
      id: map['id'],
      name: map['name'],
      classLevel: map['classLevel'],
      system: map['system'],
      totalPoints: map['totalPoints'],
      level: map['level'],
      badges: badgeList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'classLevel': classLevel,
      'system': system,
      'totalPoints': totalPoints,
      'level': level,
      'badges': badges.join(','), // Stocké sous forme de chaîne séparée par des virgules
    };
  }
}