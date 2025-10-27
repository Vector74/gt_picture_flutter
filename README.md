# gt_picture

Ez egy új Flutter projekt.

## A projekt célja

Ez az alkalmazás egy Flutter alapú mobil alkalmazás, amely célja, hogy könnyen kezelhető felületet biztosítson a felhasználók számára a képek megjelenítésére és kezelésére. Az alkalmazás képes NFC-s azonosításra, amely lehetővé teszi a felhasználók számára, hogy gyorsan és egyszerűen bejelentkezzenek a saját eszközeikkel.

## Főbb Funkciók

- **Felhasználói bejelentkezés NFC segítségével**: Az alkalmazás képes NFC címkék használatára a bejelentkezési folyamat során.
- **Képek kezelése**: Képek készítése a készülék kamerájával, valamint ezeknek a képeknek a beküldése és törlése.
- **Mappák kezelése**: Mappák listájának megjelenítése és a kiválasztott mappa kezelésének lehetősége.
## API Végpontok

Az alkalmazás RESTful API-t használ, amely a következő végpontokat tartalmazza:

### 1. Felhasználó bejelentkezése
- **POST /api/login**
  Kérés:

