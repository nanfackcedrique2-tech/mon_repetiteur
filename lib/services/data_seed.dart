import '../database/database_helper.dart';
import '../models/lesson.dart';
import '../models/exercise.dart';

class DataSeeder {
  final DatabaseHelper _db = DatabaseHelper();

  // Méthode principale à appeler une seule fois (à la première installation)
  Future<void> seedAll() async {
    // Vérifier si des leçons existent déjà pour éviter les doublons
    List<Lesson> existing = await _db.getLessonsBySubjectAndLevel('Mathématiques', 'SIL');
    if (existing.isNotEmpty) {
      print('Données déjà présentes pour SIL. Pas de ré-insertion.');
      return;
    }

    print('Insertion des données pour la classe SIL...');

    // --- LEÇON 1 : Addition simple ---
    Lesson lesson1 = Lesson(
      title: 'Addition simple (1 à 10)',
      summary: 'Apprends à additionner deux nombres entre 1 et 10.',
      content: '''
**Explication :**
L'addition, c'est quand on ajoute deux nombres pour en obtenir un plus grand.
Exemple : 3 + 2 = 5 (on ajoute 2 à 3, ça fait 5).

**Exemple concret :**
Tu as 4 pommes, ta maman te donne 3 pommes de plus. Combien as-tu de pommes au total ?
Réponse : 4 + 3 = 7 pommes.

**Démonstration étape par étape :**
1. Prends le premier nombre (4).
2. Ajoute le deuxième nombre (3).
3. Compte les deux ensemble : 4, 5, 6, 7.
4. Le résultat est 7.
''',
      classLevel: 'SIL',
      subject: 'Mathématiques',
    );

    // --- LEÇON 2 : Lecture (déchiffrage) ---
    Lesson lesson2 = Lesson(
      title: 'Lecture : Les sons "a", "e", "i"',
      summary: 'Reconnaître et prononcer les sons simples.',
      content: '''
**Explication :**
Pour lire, il faut connaître les sons des lettres.
Aujourd'hui, nous apprenons les sons : "a" (comme dans "arbre"), "e" (comme dans "école"), "i" (comme dans "image").

**Exemples concrets :**
- "a" : le a de "avion".
- "e" : le e de "éléphant".
- "i" : le i de "igloo".

**Démonstration :**
Regarde l'image, écoute le son, répète-le plusieurs fois.
''',
      classLevel: 'SIL',
      subject: 'Lecture',
    );

    // --- LEÇON 3 : Orthographe (copie simple) ---
    Lesson lesson3 = Lesson(
      title: 'Copie de mots simples (3 lettres)',
      summary: 'Écrire correctement des mots de 3 lettres.',
      content: '''
**Explication :**
Copier un mot, c'est regarder chaque lettre et l'écrire dans le bon ordre.

**Exemple :**
Le mot "chat" : c - h - a - t. Il faut écrire chaque lettre l'une après l'autre.

**Démonstration :**
1. Regarde le mot "sac".
2. Écris la première lettre : "s".
3. Écris la deuxième : "a".
4. Écris la troisième : "c".
5. Vérifie que tu as bien écrit "sac".
''',
      classLevel: 'SIL',
      subject: 'Orthographe',
    );

    // Insérer les 3 leçons
    int id1 = await _db.insertLesson(lesson1);
    int id2 = await _db.insertLesson(lesson2);
    int id3 = await _db.insertLesson(lesson3);

    // --- EXERCICES pour la Leçon 1 (Addition) : 20 exercices générés aléatoirement ---
    List<Exercise> exercisesLesson1 = [];
    List<List<int>> additions = [
      [1, 2], [2, 3], [3, 4], [4, 5], [5, 6],
      [6, 7], [7, 8], [8, 9], [9, 1], [2, 4],
      [3, 5], [4, 6], [5, 7], [6, 8], [7, 9],
      [8, 2], [9, 3], [1, 9], [2, 6], [3, 7]
    ];
    for (var pair in additions) {
      int a = pair[0];
      int b = pair[1];
      String question = '$a + $b = ?';
      String answer = '${a + b}';
      exercisesLesson1.add(Exercise(
        lessonId: id1,
        question: question,
        correctAnswer: answer,
        type: 'addition',
        difficulty: 'facile',
      ));
    }
    for (var ex in exercisesLesson1) {
      await _db.insertExercise(ex);
    }

    // --- EXERCICES pour la Leçon 2 (Lecture) : 20 exercices ---
    List<Exercise> exercisesLesson2 = [];
    List<String> syllables = ['ma', 'me', 'mi', 'mo', 'mu', 'pa', 'pe', 'pi', 'po', 'pu',
                              'ta', 'te', 'ti', 'to', 'tu', 'sa', 'se', 'si', 'so', 'su'];
    for (var syll in syllables) {
      exercisesLesson2.add(Exercise(
        lessonId: id2,
        question: 'Lis ce son : "$syll"',
        correctAnswer: syll,
        type: 'lecture',
        difficulty: 'facile',
      ));
    }
    for (var ex in exercisesLesson2) {
      await _db.insertExercise(ex);
    }

    // --- EXERCICES pour la Leçon 3 (Orthographe) : 20 exercices ---
    List<Exercise> exercisesLesson3 = [];
    List<String> words = ['sac', 'lit', 'pom', 'rat', 'mot', 'sel', 'fil', 'bol', 'car', 'vol',
                          'bus', 'pot', 'mur', 'sol', 'pain', 'dent', 'vert', 'bleu', 'rouge', 'jaune'];
    for (var w in words) {
      exercisesLesson3.add(Exercise(
        lessonId: id3,
        question: 'Copie ce mot : "$w"',
        correctAnswer: w,
        type: 'orthographe',
        difficulty: 'facile',
      ));
    }
    for (var ex in exercisesLesson3) {
      await _db.insertExercise(ex);
    }

    print('✅ Insertion terminée pour la classe SIL (3 leçons, 60 exercices).');
  }
}