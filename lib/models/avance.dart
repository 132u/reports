import 'avanceType.dart';

class Avance {
  final String type;
  final double amount;
  final DateTime createdAt;
  final String driverId;
  Avance(this.type, this.amount, this.createdAt, this.driverId);

  // @override
  // String toString() {
  //   switch (type) {
  //     case AvanceType.avance:
  //       return 'Аванс';
  //     case AvanceType.passed:
  //       return 'Сдал';
  //   }
  // }

  Map<String, dynamic> toMap() {
    return {
      'driverId':driverId,
      'type': type,
      'createdAt': createdAt,
      //'amount': type == AvanceType.avance ? -amount: amount,
      'amount': amount,
    };
  }

  Avance.fromMap(Map<String, dynamic> avance)
      : amount = avance["amount"],
        type = avance["type"],
        driverId = avance["driverId"],
        createdAt = avance["createdAt"].toDate();
}
