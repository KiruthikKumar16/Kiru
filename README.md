# 🌟 Kiru - AI-Powered Travel Outfit Recommender

## 🚀 Project Status
Phase 1: MVP Development (Week 1 In Progress)

---

## 📱 Overview
Kiru is an AI-powered travel outfit recommendation app that helps users pack smarter by combining:
- Virtual wardrobe management
- Real-time weather integration
- AI stylist recommendations
- Trip planning & packing lists
- Social features (Phase 2+)

---

## 📦 Project Structure

```
Kiru/
├── lib/                          # Main app source code
│   ├── main.dart                 # App entry point
│   ├── core/                     # Core utilities, theme, constants
│   ├── features/                 # Feature modules (auth, wardrobe, etc.)
│   ├── data/                     # Data layer (models, repos, datasources)
│   ├── domain/                   # Domain layer (entities, usecases)
│   └── presentation/             # UI layer (pages, widgets, providers)
├── assets/                       # Images, icons, fonts
├── test/                         # Tests
├── pubspec.yaml                  # Dependencies
├── PROJECT_BRIEF.md              # Team brief
├── MVP_TASK_BREAKDOWN.md         # Task breakdown by week
├── 01_PROJECT_OVERVIEW.md        # Project goals
├── 02_ARCHITECTURE_TECH_STACK.md # Architecture
├── 03_SCREEN_MAP_NAVIGATION.md   # Screen hierarchy
├── 04_CORE_FEATURES.md           # All features
├── 05_DATA_MODEL_SCHEMA.md       # Data models
└── 06_UI_UX_GUIDELINES.md        # Design system
```

---

## 🛠️ Getting Started

### Prerequisites
- Flutter (3.x)
- Firebase account
- Google Gemini API key
- OpenWeatherMap API key

### Setup Steps
1. **Clone repo**
   ```bash
   git clone <repo-url>
   cd Kiru
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create Firebase project
   - Enable Auth, Firestore, Storage, Analytics
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place in respective directories

4. **Environment Variables**
   - Create `.env` file with API keys:
     ```
     GEMINI_API_KEY=your_key
     WEATHER_API_KEY=your_key
     ```

5. **Run app**
   ```bash
   flutter run
   ```

---

## 📅 Timeline

See `MVP_TASK_BREAKDOWN.md` for full 6-week task breakdown

---

## 🔐 Security & Privacy (Non-Negotiable)
- All data private by default
- EXIF metadata stripped from all photos
- Local storage encrypted
- No NSFW content allowed
- Follow all design system and architecture docs

---

## 👥 Team
Let's build this awesome app together! 🎉
