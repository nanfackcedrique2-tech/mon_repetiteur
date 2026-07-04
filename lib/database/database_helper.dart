import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/lesson.dart';
import '../models/exercise.dart';
import '../models/student.dart';
import '../models/progress.dart';
import '../models/parent_report.dart';
import '../models/subscription.dart';
import 'dart:io';
import 'dart:async';

class DatabaseHelper {
  // Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = path.join(dir.path, 'mon_repetiteur.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE lessons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        summary TEXT NOT NULL,
        content TEXT NOT NULL,
        classLevel TEXT NOT NULL,
        subject TEXT NOT NULL,
        audioUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lessonId INTEGER NOT NULL,
        question TEXT NOT NULL,
        correctAnswer TEXT NOT NULL,
        type TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        FOREIGN KEY(lessonId) REFERENCES lessons(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        classLevel TEXT NOT NULL,
        system TEXT NOT NULL,
        totalPoints INTEGER DEFAULT 0,
        level INTEGER DEFAULT 1,
        badges TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentId INTEGER NOT NULL,
        lessonId INTEGER NOT NULL,
        score REAL NOT NULL,
        attempts INTEGER DEFAULT 0,
        lastAttemptDate TEXT NOT NULL,
        FOREIGN KEY(studentId) REFERENCES students(id) ON DELETE CASCADE,
        FOREIGN KEY(lessonId) REFERENCES lessons(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE parent_reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentId INTEGER NOT NULL,
        date TEXT NOT NULL,
        timeSpent INTEGER DEFAULT 0,
        exercisesDone INTEGER DEFAULT 0,
        errors INTEGER DEFAULT 0,
        progressLevel REAL DEFAULT 0,
        FOREIGN KEY(studentId) REFERENCES students(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE subscriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        price REAL NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        isActive INTEGER DEFAULT 0
      )
    ''');
  }

  // ========== MÉTHODES GÉNÉRIQUES ==========

  Future<int> insert(String table, Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {String? where, List<Object?>? whereArgs, String? orderBy}) async {
    Database db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  Future<int> update(String table, Map<String, dynamic> data,
      {String? where, List<Object?>? whereArgs}) async {
    Database db = await database;
    return await db.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> delete(String table,
      {String? where, List<Object?>? whereArgs}) async {
    Database db = await database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  // ========== MÉTHODES SPÉCIFIQUES ==========

  // --- Lessons ---
  Future<int> insertLesson(Lesson lesson) async {
    return await insert('lessons', lesson.toMap());
  }

  Future<List<Lesson>> getLessonsBySubjectAndLevel(String subject, String classLevel) async {
    List<Map<String, dynamic>> maps = await query(
      'lessons',
      where: 'subject = ? AND classLevel = ?',
      whereArgs: [subject, classLevel],
    );
    return maps.map((map) => Lesson.fromMap(map)).toList();
  }

  Future<Lesson?> getLessonById(int id) async {
    List<Map<String, dynamic>> maps = await query(
      'lessons',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) return Lesson.fromMap(maps.first);
    return null;
  }

  // --- Exercises ---
  Future<int> insertExercise(Exercise exercise) async {
    return await insert('exercises', exercise.toMap());
  }

  Future<List<Exercise>> getExercisesByLessonId(int lessonId) async {
    List<Map<String, dynamic>> maps = await query(
      'exercises',
      where: 'lessonId = ?',
      whereArgs: [lessonId],
    );
    return maps.map((map) => Exercise.fromMap(map)).toList();
  }

  // --- Students ---
  Future<int> insertStudent(Student student) async {
    return await insert('students', student.toMap());
  }

  Future<List<Student>> getAllStudents() async {
    List<Map<String, dynamic>> maps = await query('students');
    return maps.map((map) => Student.fromMap(map)).toList();
  }

  Future<Student?> getStudentById(int id) async {
    List<Map<String, dynamic>> maps = await query(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) return Student.fromMap(maps.first);
    return null;
  }

  Future<int> updateStudent(Student student) async {
    return await update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  // --- Progress ---
  Future<int> insertProgress(Progress progress) async {
    return await insert('progress', progress.toMap());
  }

  Future<List<Progress>> getProgressByStudentId(int studentId) async {
    List<Map<String, dynamic>> maps = await query(
      'progress',
      where: 'studentId = ?',
      whereArgs: [studentId],
    );
    return maps.map((map) => Progress.fromMap(map)).toList();
  }

  Future<Progress?> getProgressByStudentAndLesson(int studentId, int lessonId) async {
    List<Map<String, dynamic>> maps = await query(
      'progress',
      where: 'studentId = ? AND lessonId = ?',
      whereArgs: [studentId, lessonId],
    );
    if (maps.isNotEmpty) return Progress.fromMap(maps.first);
    return null;
  }

  Future<int> updateProgress(Progress progress) async {
    return await update(
      'progress',
      progress.toMap(),
      where: 'id = ?',
      whereArgs: [progress.id],
    );
  }

  // --- Parent Reports ---
  Future<int> insertParentReport(ParentReport report) async {
    return await insert('parent_reports', report.toMap());
  }

  Future<List<ParentReport>> getReportsByStudentId(int studentId) async {
    List<Map<String, dynamic>> maps = await query(
      'parent_reports',
      where: 'studentId = ?',
      whereArgs: [studentId],
      orderBy: 'date DESC',
    );
    return maps.map((map) => ParentReport.fromMap(map)).toList();
  }

  // --- Subscriptions ---
  Future<int> insertSubscription(Subscription subscription) async {
    return await insert('subscriptions', subscription.toMap());
  }

  Future<Subscription?> getActiveSubscription() async {
    List<Map<String, dynamic>> maps = await query(
      'subscriptions',
      where: 'isActive = 1',
      orderBy: 'endDate DESC',
    );
    if (maps.isNotEmpty) return Subscription.fromMap(maps.first);
    return null;
  }

  Future<int> deactivateAllSubscriptions() async {
    return await update(
      'subscriptions',
      {'isActive': 0},
      where: '1 = 1',
    );
  }
}