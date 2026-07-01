class Subscription {
  final int? id;
  final String type;           // "decouverte", "100f", "500f", etc.
  final double price;          // en FCFA (0, 100, 500, 1500, 4000, 7500, 10000)
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  Subscription({
    this.id,
    required this.type,
    required this.price,
    required this.startDate,
    required this.endDate,
    this.isActive = false,
  });

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'],
      type: map['type'],
      price: map['price'].toDouble(),
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      isActive: map['isActive'] == 1, // SQLite stocke booléen en 0/1
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'price': price,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }
}