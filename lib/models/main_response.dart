class MainResponse {
  // Az API válasz státusza
  final int status;
  
  // Az API válasz üzenete
  final String message;
  
  // Az API válasz adatai, dinamikus típusú map-ként
  final Map<String, dynamic> data;
  
  // Az API által végrehajtott parancs
  final String command;

  // Konstruktor, amely inicializálja az osztály mezőit
  MainResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.command,
  });

  // Factory konstruktor, amely egy JSON map-ből hoz létre egy MainResponse példányt
  factory MainResponse.fromJson(Map<String, dynamic> json) {
    return MainResponse(
      status: json['status'], // Státusz inicializálása a JSON-ból
      message: json['message'], // Üzenet inicializálása a JSON-ból
      data: json['data'], // Adatok inicializálása a JSON-ból
      command: json['command'], // Parancs inicializálása a JSON-ból
    );
  }

  // Metódus, amely egy MainResponse példányt JSON map-pé alakít
  Map<String, dynamic> toJson() {
    return {
      'status': status, // Státusz hozzáadása a JSON-hoz
      'message': message, // Üzenet hozzáadása a JSON-hoz
      'data': data, // Adatok hozzáadása a JSON-hoz
      'command': command, // Parancs hozzáadása a JSON-hoz
    };
  }
}