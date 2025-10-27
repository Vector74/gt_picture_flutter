import 'package:flutter/material.dart';
import '../components/main_app_bar.dart';
import '../utils/core_util.dart';
import '../models/gtitem.dart';
import '../globals/global_vars.dart'; // Importáljuk a GlobalVars-t
import 'gt_folders_screen.dart'; // Importáljuk a GTFoldersScreen-t

class GTItemsScreen extends StatefulWidget {
  const GTItemsScreen({super.key});

  @override
  State<GTItemsScreen> createState() => _GTItemsScreenState();
  
}

class _GTItemsScreenState extends State<GTItemsScreen> {
  List<GTItem> _items = []; // Az összes GT elem listája
  List<GTItem> _filteredItems = []; // A szűrt GT elemek listája
  final CoreUtil _coreUtil = CoreUtil(); // CoreUtil példány az API hívásokhoz

  @override
  void initState() {
    super.initState();
    _loadItems(); // Elemlista betöltése az inicializáláskor
  }

  Future<void> _loadItems() async {
    try {
      final response = await _coreUtil.getItems(); // API hívás az elemek lekérésére
      setState(() {
        _items = response.data['items']; // Az elemek beállítása
        _filteredItems = _items; // A szűrt elemek kezdetben megegyeznek az összes elemmel
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hiba történt az elemek betöltésekor')),
      );
    }
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = _items
          .where((item) => item.gtnumber.toLowerCase().contains(query.toLowerCase()))
          .toList(); // Csak azok az elemek maradnak, amelyek megfelelnek a keresési feltételnek
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'GT Items'), // Fő alkalmazás sáv
      body: Column(
        children: [
          TextField(
            onChanged: _filterItems, // Keresési mező változásának kezelése
            decoration: const InputDecoration(
              labelText: 'Keresés',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length, // A listaelemek száma
              itemBuilder: (context, index) {
                final item = _filteredItems[index]; // Az aktuális elem
                return ListTile(
                  leading: const Icon(Icons.label),
                  title: Text(item.gtnumber), // Az elem GT száma
                  subtitle: Text('Határidő: ${item.deadline}'), // Az elem határideje
                  onTap: () {
                    // A kiválasztott elem elmentése a GlobalVars-ba
                    GlobalVars.setSelectedItem(item);
                    // Navigálás a GTFoldersScreen-re
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GTFoldersScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}