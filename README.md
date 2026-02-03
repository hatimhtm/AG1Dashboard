# AG1 Dashboard - iOS App 📊

> Application SwiftUI moderne pour l'analyse des performances publicitaires Meta Ads.
> **iOS 17+ | Swift 5.9 | SwiftUI Charts**

## ✨ Fonctionnalités iOS 17+

| Feature | Description |
|---------|-------------|
| 🎯 Symbol Effects | Animations `.bounce`, `.pulse`, `.wiggle` |
| 📳 Sensory Feedback | Haptics contextualisés (selection, impact, notification) |
| 🔢 Content Transitions | `.numericText()` pour les KPIs animés |
| 📊 Chart Selection | Sélection interactive sur les graphiques |
| 🔍 Search Suggestions | Suggestions de recherche natives |
| 📱 Dynamic Island | Support Live Activities pour tracking temps réel |
| 🎨 Material Backgrounds | `.regularMaterial` blur effects |

## 📱 Écrans

### 1. Overview (Dashboard)
- 6 KPIs avec animations `.bounce`
- Charts ROAS/Mois avec sélection interactive
- Charts Budget/Produit
- Top 5 créas par ROAS
- Top 5 créateurs par conversions
- Pull-to-refresh avec haptics

### 2. Liste des Créas
- Recherche intelligente avec suggestions iOS 17
- Filtres: Produit, Mois, Statut, Type
- Tri: ROAS ↑↓, Budget ↑↓, Conversions ↑↓
- Context menus avec aperçu
- Swipe actions (favoris, archiver)
- Presentation detents (sheet adaptive)

### 3. Détail Créative
- 8 KPIs sélectionnables avec feedback
- Flow layout pour tags
- Animations d'entrée staggered
- Actions rapides (éditer, dupliquer, partager)

## 🗂 Structure du Projet

```
AG1Dashboard/
├── AG1DashboardApp.swift          # Point d'entrée
├── AG1-Data.csv                   # 1200 lignes de données mock
├── Theme/
│   └── Theme.swift                # Design system complet
├── Models/
│   ├── Creative.swift             # Modèle de données
│   └── FilterState.swift          # État des filtres observables
├── ViewModels/
│   └── DashboardViewModel.swift   # Logique métier + charts
├── Services/
│   ├── CSVParser.swift            # Parsing CSV français
│   └── LiveActivityManager.swift  # Dynamic Island support
└── Views/
    ├── ContentView.swift          # Navigation adaptive
    ├── Components/
    │   └── Components.swift       # 15+ composants réutilisables
    └── Screens/
        ├── OverviewView.swift     # Dashboard avec charts
        ├── CreativesListView.swift # Liste filtrable
        └── CreativeDetailView.swift # Vue détail
```

## 🎨 Design System

```swift
// Couleurs
AppTheme.Colors.primary          // Vert AG1
AppTheme.Colors.background       // Gradient léger
AppTheme.Colors.accentBlue/Purple/Cyan...

// Animations
AppTheme.Animations.smooth       // 0.3s easeInOut
AppTheme.Animations.bouncy       // Spring avec rebond
AppTheme.Animations.snappy       // Réponse rapide

// Styles
.cardStyle()                     // Cartes avec ombre
.gradientBackground()            // Fond dégradé
```

## 📊 Données Mock

Le fichier `AG1-Data.csv` contient 1200 entrées avec:
- 7 produits (AG1 Powder, Travel Packs, Vitamines...)
- 10 créateurs différents
- 5 types de contenu (UGC, Podcast, Vidéo, Image, Témoignage)
- 8 angles marketing
- 5 mois (Juillet - Novembre 2025)
- Métriques variées (budget, conversions, ROAS, impressions...)

## 🚀 Installation

```bash
# 1. Cloner le projet
git clone <repo>

# 2. Ouvrir dans Xcode 15+
open AG1Dashboard.xcodeproj

# 3. Build & Run
# Target: iOS 17.0+ Simulator ou Device
```

## 📦 Technologies

- **SwiftUI** - Interface déclarative
- **Swift Charts** - Graphiques natifs
- **Combine** - Réactivité
- **ActivityKit** - Live Activities
- **Observation** - @Observable macro (iOS 17)

## 🏗 Architecture

```
MVVM Clean Architecture
├── Models (Data layer)
├── ViewModels (Business logic)
├── Views (Presentation layer)
│   ├── Screens (Pages)
│   └── Components (Réutilisables)
└── Services (External interfaces)
```

## 📝 Colonnes CSV

| Colonne | Description |
|---------|-------------|
| Nom de l'annonce | Identifiant créative |
| Produit | Catégorie produit |
| Créateur | Nom du créateur |
| Type de contenu | UGC/Podcast/Vidéo... |
| Angle marketing | Hook principal |
| Mois | Période de diffusion |
| Statut | En ligne/Arrêtée/Pause/Archivée |
| Budget dépensé (€) | Montant investi |
| Conversions | Nombre d'achats |
| ROAS | Return on Ad Spend |
| Impressions | Nombre de vues |
| Clics | Interactions |
| Taux de clic (%) | CTR |

---

*Développé pour ViralFactory - Test iOS Developer*
*iOS 17 | Swift 5.9 | SwiftUI*
