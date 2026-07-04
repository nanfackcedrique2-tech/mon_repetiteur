import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/subscription.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  bool _isLoading = false;
  String? _selectedType;
  final Map<String, dynamic> _plans = {
    'Découverte (0F)': {'price': 0, 'duration': 1},
    '100F - 1 jour': {'price': 100, 'duration': 1},
    '500F - 7 jours': {'price': 500, 'duration': 7},
    '1500F - 1 mois': {'price': 1500, 'duration': 30},
    '4000F - 3 mois': {'price': 4000, 'duration': 90},
    '7500F - 6 mois': {'price': 7500, 'duration': 180},
    '10000F - 12 mois': {'price': 10000, 'duration': 365},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisis ton abonnement'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenue !',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Sélectionne une formule :'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _plans.keys.length,
                itemBuilder: (context, index) {
                  String label = _plans.keys.elementAt(index);
                  var data = _plans[label];
                  double price = data['price'];
                  int days = data['duration'];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(label),
                      subtitle: Text('$days jour(s)'),
                      trailing: Text(
                        price == 0 ? 'Gratuit' : '$price FCFA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: price == 0 ? Colors.green : Colors.blue,
                        ),
                      ),
                      onTap: () => _selectPlan(label),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: _selectedType == label ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _activateSubscription,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('ACTIVER'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectPlan(String label) {
    setState(() => _selectedType = label);
  }

  Future<void> _activateSubscription() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choisis une formule.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      var data = _plans[_selectedType];
      double price = data['price'];
      int days = data['duration'];

      DateTime now = DateTime.now();
      DateTime endDate = now.add(Duration(days: days));

      await _db.deactivateAllSubscriptions();
      Subscription newSub = Subscription(
        type: _selectedType!,
        price: price,
        startDate: now,
        endDate: endDate,
        isActive: true,
      );
      await _db.insertSubscription(newSub);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Actif jusqu\'au ${endDate.toLocal()}'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}