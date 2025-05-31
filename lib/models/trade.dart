class Trade {
  final int? id;
  final String tradeName;
  final double entryPrice;
  final double exitPrice;
  final int quantity;
  final String date;
  final String notes;

  Trade({
    required this.id,
    required this.tradeName,
    required this.entryPrice,
    required this.exitPrice,
    required this.quantity,
    required this.date,
    required this.notes,
  });

  // Getter for profit/loss
  double get profitLoss => (exitPrice - entryPrice) * quantity;

  // Convert a trade Object into a Map for Sqlflite
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'tradeName' : tradeName,
      'entryPrice' : entryPrice,
      'exitPrice' : exitPrice,
      'quantity' : quantity,
      'date' : date,
      'notes' : notes,
    };
  }

  // Create a trade Object from a Map object
  factory Trade.fromMap(Map<String, dynamic> map){
    return Trade(
        id: map['id'],
        tradeName: map['tradeName'],
        entryPrice: map['entryPrice'],
        exitPrice: map['exitPrice'],
        quantity: map['quantity'],
        date: map['date'],
        notes: map['notes'],
    );
  }
  @override
  String toString() {
    // TODO: implement toString
    return 'Trade{id: $id, tradeName: $tradeName, entryPrice: $entryPrice, exitPrice: $exitPrice, quantity: $quantity, date: $date, notes: $notes, profitloss: $profitLoss}';
  }
}