class GTFolders {
  final int id;
  final String name;
  final bool pdf;
  final String color;

  // Konstruktor az osztály példányosításához
  GTFolders({
    required this.id,
    required this.name,
    required this.pdf,
    required this.color,
  });

  // Factory konstruktor, amely egy új GTFolders példányt hoz létre egy JSON térképből
  factory GTFolders.fromJson(Map<String, dynamic> json) {
    return GTFolders(
      id: json['id'],
      name: json['name'],
      pdf: json['pdf'],
      color: json['color'],
    );
  }

  // Metódus, amely egy GTFolders példányt alakít vissza JSON térképpé
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pdf': pdf,
      'color': color,
    };
  }
}