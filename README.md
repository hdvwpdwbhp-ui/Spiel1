# AI Overlord – Fertige Dateien & Xcode-Setup

## Wo sind die fertigen Dateien?

Alle fertigen Swift-Dateien liegen im Ordner **`AIOverlord/`** in diesem Repository.

```
AIOverlord/
├── AIOverlordApp.swift              ← App-Einstiegspunkt (@main)
│
├── Utilities/
│   ├── GameConstants.swift          ← Alle Spielkonstanten
│   ├── NumberFormat.swift           ← Zahlenformatierung (K, M, B, T, aa …)
│   ├── TimeUtil.swift               ← Zeit-Hilfsfunktionen
│   ├── Theme.swift                  ← Farbthemen pro Dimension
│   └── Haptics.swift                ← Haptisches Feedback
│
├── Models/
│   ├── Skin.swift                   ← Skin-Datenmodell + Rarität
│   ├── Business.swift               ← Business-Datenmodell (Einkommen, Kosten)
│   ├── Dimension.swift              ← Dimension-Datenmodell
│   ├── SkillNode.swift              ← Skill-Tree-Knoten
│   ├── SkillNodeFactory.swift       ← Erzeugt Standard-Skills (3 Pfade × 20)
│   ├── DimensionFactory.swift       ← Erzeugt Dimensionen 1–5 mit Businesses
│   ├── SkinFactory.swift            ← Skin-Pool (20 Launch-Skins)
│   └── PlayerState.swift            ← Gesamter Spielstand (Codable)
│
├── Services/
│   ├── PersistenceService.swift     ← Speichern / Laden (JSON in Documents)
│   ├── IncomeService.swift          ← Einkommensberechnung + Multiplikatoren
│   ├── PrestigeService.swift        ← Prestige-Reset + Token-Gewinn
│   ├── SpinService.swift            ← Glücksrad-Logik + Soft Pity
│   ├── AntiCheatService.swift       ← Basis-Anti-Cheat-Validierung
│   ├── NotificationService.swift    ← Push-Benachrichtigungen (Platzhalter)
│   ├── FirebaseService.swift        ← Firebase Analytics + Firestore (optional)
│   └── PurchaseService.swift        ← StoreKit 2 In-App-Käufe (Skeleton)
│
├── ViewModels/
│   ├── GameViewModel.swift          ← Haupt-ViewModel (Timer, Einkommen, Prestige)
│   ├── DimensionViewModel.swift     ← Dimensionen-Auswahl
│   ├── SpinWheelViewModel.swift     ← Glücksrad-Ergebnis-Anzeige
│   ├── ShopViewModel.swift          ← Shop / StoreKit-Produkte
│   └── LeaderboardViewModel.swift   ← Bestenliste (Firebase)
│
├── Views/
│   ├── RootTabView.swift            ← TabView mit 7 Tabs
│   ├── EmpireView.swift             ← Hauptbildschirm (Businesses, AI-Upgrade)
│   ├── SingularityEyeView.swift     ← Animiertes AI-Auge
│   ├── BusinessRowView.swift        ← Einzelne Business-Zeile
│   ├── UpgradesView.swift           ← Skill-Trees + Skins
│   ├── SkillTreeView.swift          ← Einzelner Skill-Pfad
│   ├── DimensionView.swift          ← Dimensions-Wechsel
│   ├── RewardsView.swift            ← Glücksrad-Bildschirm
│   ├── SpinWheelView.swift          ← Glücksrad-Animation
│   ├── ShopView.swift               ← In-App-Käufe
│   ├── LeaderboardView.swift        ← Bestenliste
│   └── SettingsView.swift           ← Einstellungen + Feedback
│
└── Resources/                       ← (Platzhalter für Localizable.strings)
```

## Wie bekomme ich das in Xcode?

### Schritt-für-Schritt-Anleitung

1. **Neues Xcode-Projekt erstellen**
   - Xcode → File → New → Project → **iOS App**
   - Product Name: `AIOverlord`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Minimum Deployment: **iOS 16.0**

2. **Standard-Dateien löschen**
   - Lösche die von Xcode erstellte `ContentView.swift` (wird nicht benötigt)

3. **Ordner in Xcode anlegen**
   - Rechtsklick auf den `AIOverlord`-Ordner im Project Navigator
   - New Group → erstelle: `Models`, `ViewModels`, `Services`, `Views`, `Utilities`, `Resources`

4. **Dateien einfügen**
   - Kopiere die Dateien aus diesem Repository in die jeweiligen Ordner
   - **Wichtig:** Beim Hinzufügen "Copy items if needed" aktivieren und das Target `AIOverlord` anhaken
   - Die Datei `AIOverlordApp.swift` ersetzt die bestehende App-Datei

5. **Starten**
   - Wähle einen iPhone-Simulator (z.B. iPhone 15)
   - Drücke ⌘R (Run)
   - Du solltest eine TabView mit 7 Tabs sehen: Empire, Upgrades, Dimensions, Rewards, Shop, Rank, Settings

### Firebase (optional)
Die App kompiliert auch **ohne** Firebase. Firebase ist mit `#if canImport(...)` geschützt.
Wenn du Firebase aktivieren willst:
- Firebase-Projekt auf [console.firebase.google.com](https://console.firebase.google.com) erstellen
- `GoogleService-Info.plist` herunterladen und ins Projekt ziehen
- Swift Package hinzufügen: `https://github.com/firebase/firebase-ios-sdk`

### StoreKit (optional)
Die App kompiliert auch **ohne** konfigurierte Produkte.
Für lokale Tests:
- Xcode → File → New → File → **StoreKit Configuration**
- Im Schema unter Run → Options → StoreKit Configuration zuweisen

## Spezifikation

Die vollständige Spezifikation findest du in:
- **`AI_Overlord_EVERYTHING_OnePDF_Master.pdf`** ← Hauptdokument (alles in einer PDF)
