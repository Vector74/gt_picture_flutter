import '../models/user_response.dart';
import '../models/gtfolders.dart'; // Import the GTFolders model
import '../models/gtitem.dart'; // Import the GTItem model

class GlobalVars {
  // Statikus UserResponse példány, amelyet a program különböző részeiből elérhetünk
  static UserResponse? currentUser;

  // Statikus GTFolders példány a kiválasztott mappa tárolására
  static GTFolders? selectedFolder;

  // Statikus GTItem példány a kiválasztott elem tárolására
  static GTItem? selectedItem;

  // Metódus a UserResponse beállításához
  static void setUser(UserResponse user) {
    currentUser = user;
  }

  // Metódus a UserResponse lekérdezéséhez
  static UserResponse? getUser() {
    return currentUser;
  }

  // Metódus a kiválasztott mappa beállításához
  static void setSelectedFolder(GTFolders folder) {
    selectedFolder = folder;
  }

  // Metódus a kiválasztott mappa lekérdezéséhez
  static GTFolders? getSelectedFolder() {
    return selectedFolder;
  }

  // Metódus a kiválasztott GTItem beállításához
  static void setSelectedItem(GTItem item) {
    selectedItem = item;
  }

  // Metódus a kiválasztott GTItem lekérdezéséhez
  static GTItem? getSelectedItem() {
    return selectedItem;
  }
}