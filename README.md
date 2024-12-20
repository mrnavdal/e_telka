# E-Telka - Systém pro řízení výroby

## Přehled
E-Telka je aplikace pro řízení výroby navržená pro společnost "Věcičky". Pomáhá spravovat a sledovat výrobní úkoly, operace a pracovní postupy v reálném čase.

## Funkce

### Správa úkolů
- Zobrazení a správa výrobních úkolů
- Sledování stavu úkolů (zahájené/nezahájené)
- Monitorování termínů dokončení
- Filtrování úkolů podle různých kritérií
- Řazení úkolů podle:
  - Počtu kusů
  - Čísla úkolu
  - Pořadí operace
  - Plánovaného data dokončení

### Výrobní proces
Aplikace zpracovává specifické výrobní postupy:
1. Rezervace materiálu
2. Objednávání materiálu
3. Operace stříhání
4. Šicí operace
5. Správa cen

### Aktualizace v reálném čase
- Integrace Firebase pro synchronizaci dat v reálném čase
- Push notifikace pro důležité aktualizace
- Podpora více platforem (Web, iOS, Android, Desktop)

## Technický stack

### Frontend
- Flutter framework pro multiplatformní vývoj
- GetX pro správu stavu
- Material Design UI komponenty

### Backend
- Firebase Realtime Database
- Firebase Authentication
- Firebase Cloud Messaging pro notifikace
- Firebase Hosting pro webové nasazení

### Podporované platformy
- Web (Progressive Web App)
- iOS
- Android
- macOS
- Windows
- Linux