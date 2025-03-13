class UserResponse {
  // Felhasználó azonosítója
  final String id;
  
  // Felhasználó kártyaszáma
  final String cardnumber;
  
  // Felhasználó teljes neve
  final String fullname;
  
  // Felhasználó szintje
  final String userlevel;

  // Konstruktor, amely inicializálja az osztály mezőit
  UserResponse({
    required this.id,
    required this.cardnumber,
    required this.fullname,
    required this.userlevel,
  });

  // Factory konstruktor, amely egy JSON map-ből hoz létre egy UserResponse példányt
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'], // Azonosító inicializálása a JSON-ból
      cardnumber: json['cardnumber'], // Kártyaszám inicializálása a JSON-ból
      fullname: json['fullname'], // Teljes név inicializálása a JSON-ból
      userlevel: json['userlevel'], // Felhasználói szint inicializálása a JSON-ból
    );
  }

  // Metódus, amely egy UserResponse példányt JSON map-pé alakít
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Azonosító hozzáadása a JSON-hoz
      'cardnumber': cardnumber, // Kártyaszám hozzáadása a JSON-hoz
      'fullname': fullname, // Teljes név hozzáadása a JSON-hoz
      'userlevel': userlevel, // Felhasználói szint hozzáadása a JSON-hoz
    };
  }
}