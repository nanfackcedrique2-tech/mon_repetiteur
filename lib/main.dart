import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'services/data_seed.dart';
import 'models/lesson.dart';
import 'models/subscription.dart';
import 'screens/subscription_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Répétiteur',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/subscription': (context) => const SubscriptionScreen(),
        '/home': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Écran de démarrage qui vérifie l'abonnement
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSubscription();
  }

  // MÉTHODE CORRIGÉE avec vérification 'mounted'
  Future<void> _checkSubscription() async {
    final db = DatabaseHelper();

    await db.database;

    final seeder = DataSeeder();
    await seeder.seedAll();

    Subscription? activeSub = await db.getActiveSubscription();

    // Vérifier si le widget est toujours monté avant de naviguer
    if (!mounted) return;

    if (activeSub != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/subscription');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Chargement de Mon Répétiteur...'),
          ],
        ),
      ),
    );
  }
}

// Page d'accueil (liste des leçons)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Lesson>> _lessonsFuture;

  @override
  void initState() {
    super.initState();
    _lessonsFuture = _loadLessons();
  }

  Future<List<Lesson>> _loadLessons() async {
    final db = DatabaseHelper();
    return await db.getLessonsBySubjectAndLevel('Mathématiques', 'SIL');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Répétiteur - Accueil'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _deactivateSubscription();
            },
            tooltip: 'Déconnexion (test)',
          ),
        ],
      ),
      body: FutureBuilder<List<Lesson>>(
        future: _lessonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Chargement des leçons...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur : ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucune leçon trouvée pour la classe SIL.'),
            );
          }

          final lessons = snapshot.data!;
          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(lesson.title),
                  subtitle: Text('Matière : ${lesson.subject} | Niveau : ${lesson.classLevel}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Leçon : ${lesson.title}')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // MÉTHODE CORRIGÉE avec vérification 'mounted'
  Future<void> _deactivateSubscription() async {
    final db = DatabaseHelper();
    await db.deactivateAllSubscriptions();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abonnement désactivé (test). Retour à l\'écran de choix.'),
        backgroundColor: Colors.orange,
      ),
    );
    Navigator.pushReplacementNamed(context, '/');
  }
}