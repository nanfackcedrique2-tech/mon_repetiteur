import '../database/database_helper.dart';
import '../models/lesson.dart';
import '../models/exercise.dart';

class DataSeeder {
  final DatabaseHelper _db = DatabaseHelper();

  Future<void> seedAll() async {
    try {
      List<Lesson> existing = await _db.getLessonsBySubjectAndLevel('Mathématiques', 'SIL');
      if (existing.isNotEmpty) {
        print('Données déjà présentes.');
        return;
      }

      print('Insertion des données SIL...');

      // Leçon 1
      Lesson l1 = Lesson(
        title: 'Addition simple (1 à 10)',
        summary: 'Apprends à additionner deux nombres.',
        content: 'Explication, exemple, étapes...',
        classLevel: 'SIL',
        subject: 'Mathématiques',
      );
      int id1 = await _db.insertLesson(l1);

      // Leçon 2
      Lesson l2 = Lesson(
        title: 'Lecture : sons a, e, i',
        summary: 'Reconnaître les sons.',
        content: 'Description des sons...',
        classLevel: 'SIL',
        subject: 'Lecture',
      );
      int id2 = await _db.insertLesson(l2);

      // Leçon 3
      Lesson l3 = Lesson(
        title: 'Copie de mots simples',
        summary: 'Écrire des mots de 3 lettres.',
        content: 'Méthode de copie...',
        classLevel: 'SIL',
        subject: 'Orthographe',
      );
      int id3 = await _db.insertLesson(l3);

      // Exercices pour l1
      List<Exercise> exos1 = [];
      for (int i = 1; i <= 20; i++) {
        int a = i % 5 + 1;
        int b = (i * 2) % 10 + 1;
        exos1.add(Exercise(
          lessonId: id1,
          question: '$a + $b = ?',
          correctAnswer: '${a + b}',
          type: 'addition',
          difficulty: 'facile',
        ));
      }
      for (var ex in exos1) await _db.insertExercise(ex);

      // Exercices pour l2 (lecture)
      List<Exercise> exos2 = [];
      List<String> syll = ['ma', 'me', 'mi', 'mo', 'mu', 'pa', 'pe', 'pi', 'po', 'pu',
                           'ta', 'te', 'ti', 'to', 'tu', 'sa', 'se', 'si', 'so', 'su'];
      for (var s in syll) {
        exos2.add(Exercise(
          lessonId: id2,
          question: 'Lis ce son : "$s"',
          correctAnswer: s,
          type: 'lecture',
          difficulty: 'facile',
        ));
      }
      for (var ex in exos2) await _db.insertExercise(ex);

      // Exercices pour l3 (orthographe)
      List<Exercise> exos3 = [];
      List<String> mots = ['sac', 'lit', 'pom', 'rat', 'mot', 'sel', 'fil', 'bol', 'car', 'vol',
                           'bus', 'pot', 'mur', 'sol', 'pain', 'dent', 'vert', 'bleu', 'rouge', 'jaune'];
      for (var w in mots) {
        exos3.add(Exercise(
          lessonId: id3,
          question: 'Copie ce mot : "$w"',
          correctAnswer: w,
          type: 'orthographe',
          difficulty: 'facile',
        ));
      }
      for (var ex in exos3) await _db.insertExercise(ex);

      print('✅ Insertion terminée.');
    } catch (e) {
      print('❌ Erreur dans seedAll : $e');
      rethrow;
    }
  }
}