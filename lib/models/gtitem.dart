class GTItem {
  final String id;
  final String gtnumber;
  final String deadline;

  // Konstruktor az osztály példányosításához
  GTItem({
    required this.id,
    required this.gtnumber,
    required this.deadline,
  });

  // Factory konstruktor, amely egy új GTItem példányt hoz létre egy JSON térképből
  factory GTItem.fromJson(Map<String, dynamic> json) {
    return GTItem(
      id: json['id'],
      gtnumber: json['gtnumber'],
      deadline: json['deadline'],
    );
  }

  // Metódus, amely egy GTItem példányt alakít vissza JSON térképpé
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gtnumber': gtnumber,
      'deadline': deadline,
    };
  }
}