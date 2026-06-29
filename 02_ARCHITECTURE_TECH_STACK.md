# Kiru - Architecture & Tech Stack

## App Architecture
Clean Architecture with Feature-First Structure

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── usecases/
│   ├── utils/
│   └── theme/
├── features/
│   ├── authentication/
│   ├── onboarding/
│   ├── profile/
│   ├── wardrobe/
│   ├── trips/
│   ├── ai_stylist/
│   ├── social/
│   └── shopping/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── pages/
│   ├── widgets/
│   └── providers/
└── main.dart
```

## Tech Stack

### Frontend
- **Framework: Flutter 3.x**
- **State Management: Riverpod 2.x**
- **Navigation: GoRouter**
- **Local Storage: Hive / Isar**
- **Image Handling: cached_network_image**
- **AR: ar_flutter_plugin (Phase 2)**
- **Camera: image_picker / camera**
- **ML Kit (for body/skin detection): google_mlkit**

### Backend (Phase 1 - Firebase)
- **Authentication: Firebase Auth**
- **Database: Firestore**
- **Storage: Firebase Storage**
- **Push Notifications: Firebase Cloud Messaging**

### Backend (Phase 2+ - Custom API)
- **Framework: Next.js (Node.js)**
- **Database: PostgreSQL with Prisma ORM**
- **Auth: JWT / OAuth2**

### AI Integrations
- **AI Stylist: Google Gemini API**
- **Image Generation: Gemini Image Generation / DALL-E**
- **Body Measurement: Custom ML Model / API**

### External APIs
- **Weather: OpenWeatherMap / WeatherAPI.com**
- **Location: Google Maps Geocoding**
- **Shopping: Amazon Product Advertising / Similar APIs**

### DevOps & Tools
- **CI/CD: GitHub Actions**
- **Testing: flutter_test + mockito**
- **Analytics: Firebase Analytics**
- **Crash Reporting: Crashlytics**

---

## State Management Strategy
- **Riverpod Providers** for global state
- **ViewModel Pattern** for presentation layer
- **Local Caching** with Hive/Isar for offline mode

## Data Flow
1. UI → ViewModel → UseCase → Repository
2. Repository decides between remote API or local cache
3. Data flows back to UI via reactive streams

---

## Security Considerations
- Encrypted local storage
- Secure API communication (HTTPS)
- OAuth2 for authentication
- No plaintext secrets
