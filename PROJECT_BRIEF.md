# 🌟 Kiru - Project Brief for Dev Team

---

## 📱 App Overview
**Kiru** - AI-Powered Travel Outfit Recommender & Virtual Wardrobe

**Tagline**: *Pack smarter, dress better - AI stylist for every trip.*

**Vision**: Become the world's #1 app for travel fashion - making packing effortless, personalized, and culturally-aware for every traveler.

---

## 🎯 Project Goals (Phase 1: MVP)

### Core MVP Features (Must-Have)
1. ✅ User authentication & profiles
2. ✅ Virtual wardrobe (add/remove/edit items, categories)
3. ✅ Style quiz onboarding
4. ✅ Trip planning (destination, dates, weather integration)
5. ✅ AI outfit recommendations from user's wardrobe
6. ✅ Day-by-day packing lists
7. ✅ Basic UI/UX following design system

### Non-Goals for Phase 1
- ❌ Social features (Phase 2)
- ❌ AR try-on (Phase 2)
- ❌ Shopping integration (Phase 2+)
- ❌ Premium tier (Phase 3)

---

## 🏗️ Tech Stack

### Frontend
- **Framework**: Flutter (3.x) - cross-platform iOS/Android
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Local Storage**: Hive/Isar (encrypted)
- **HTTP Client**: Dio

### Backend (Firebase)
- **Auth**: Firebase Auth
- **Database**: Firestore
- **Storage**: Firebase Storage
- **Push Notifications**: Firebase Cloud Messaging (FCM)
- **Analytics**: Firebase Analytics

### AI/ML
- **AI Stylist**: Google Gemini API
- **Image Recognition**: Google ML Kit (for wardrobe item tagging)

### External APIs
- **Weather**: OpenWeatherMap / WeatherAPI.com
- **Location**: Google Maps Geocoding (optional, Phase 1+)

---

## 📁 Project Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/       # app constants, colors, typography
│   ├── errors/          # error handling
│   ├── theme/           # theme, design system
│   └── utils/           # helpers, extensions
├── features/
│   ├── auth/            # login/signup
│   ├── onboarding/      # style quiz, profile setup
│   ├── wardrobe/        # virtual wardrobe management
│   ├── trips/           # trip planning, packing lists
│   ├── ai_stylist/      # AI recommendations
│   └── profile/         # user settings, profile
├── data/
│   ├── datasources/     # Firebase, local storage
│   ├── models/          # data models (from 05_DATA_MODEL_SCHEMA.md)
│   └── repositories/    # data repos
├── domain/
│   ├── entities/        # business entities
│   └── usecases/        # business logic
└── presentation/
    ├── pages/           # UI screens
    ├── widgets/         # reusable components
    └── providers/       # Riverpod providers
```

---

## 📐 Design System (Follow Strictly)

### Colors
- **Primary**: `#6366F1` (Indigo 500)
- **Primary Light**: `#818CF8`
- **Primary Dark**: `#4F46E5`
- **Secondary**: `#EC4899`
- **Accent**: `#10B981`
- **Background**: `#FFFFFF`
- **Surface**: `#F8FAFC`

### Typography
- Use **Inter** font family
- Follow type scale defined in `06_UI_UX_GUIDELINES.md`

### Accessibility
- Minimum touch targets: **48x48dp**
- Color contrast ratio ≥ 4.5:1
- Screen reader support

---

## 🔐 Security & Privacy (CRITICAL)

### Non-Negotiable Rules
1. **EXIF Stripping**: Auto-remove EXIF metadata from all uploaded photos
2. **Data Privacy Defaults**:
   - All trips/wardrobes/outfits: **PRIVATE BY DEFAULT**
   - Hide exact trip dates/locations by default
3. **Local Storage Encryption**: Hive/Isar must be encrypted
4. **IDOR Protection**: Always validate user owns data before access
5. **Rate Limiting**: All API calls (friend requests, messages, etc.) must have rate limits
6. **No NSFW Content**: Strict content moderation, family-friendly only

---

## 📅 Phase 1 Development Timeline (Suggested)

| Week | Focus | Deliverable |
|------|-------|-------------|
| 1 | Project setup, auth, onboarding | Working login/signup + style quiz |
| 2 | Virtual wardrobe | Full CRUD for wardrobe items |
| 3 | Trip planning + weather | Trip creation + weather integration |
| 4 | AI stylist MVP | Basic Gemini-powered recommendations from wardrobe |
| 5 | Packing lists + polish | Day-by-day packing + UI/UX polish |
| 6 | Testing & QA | Bug fixes, accessibility checks |

---

## 📋 Reference Documents

All in project root directory:
1. `01_PROJECT_OVERVIEW.md` - Project goals & vision
2. `02_ARCHITECTURE_TECH_STACK.md` - Detailed architecture
3. `03_SCREEN_MAP_NAVIGATION.md` - Full screen hierarchy
4. `04_CORE_FEATURES.md` - All features by phase
5. `05_DATA_MODEL_SCHEMA.md` - Data models & DB schema
6. `06_UI_UX_GUIDELINES.md` - Design system

---

## 🎯 Key Success Metrics (Phase 1)
- App Store/Play Store launch-ready
- 0 critical security bugs
- Smooth onboarding (≤ 30 seconds to add first 5 wardrobe items)
- 80%+ crash-free sessions

---

## 🚀 Ready to Build?
Let's get started! Let me know if you want to initialize the Flutter project next.
