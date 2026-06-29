# 🚀 Kiru MVP - Detailed Task Breakdown

---

## Week 1: Project Setup, Auth & Onboarding
**Goal**: Working login/signup + style quiz

| Task | Priority | Notes |
|------|----------|-------|
| Initialize Flutter project | HIGH | Use latest stable, set up Riverpod, GoRouter |
| Set up Firebase project & integrate | HIGH | Auth, Firestore, Storage, Analytics |
| Design system implementation | HIGH | Colors, typography, components following 06_UI_UX_GUIDELINES.md |
| Login/Signup UI (email/password + Google) | HIGH | Clean, modern UI |
| Splash screen & initial routing | MEDIUM | |
| Style quiz UI (swipe-based, Tinder-like) | HIGH | 20-30 outfit cards, swipe left/right |
| User profile creation (basic) | MEDIUM | Username, display name, photo |

---

## Week 2: Virtual Wardrobe System
**Goal**: Full CRUD for wardrobe items

| Task | Priority | Notes |
|------|----------|-------|
| Wardrobe data models | HIGH | Follow 05_DATA_MODEL_SCHEMA.md |
| Local storage setup (Hive/Isar, encrypted!) | HIGH | Security first! |
| Wardrobe screen UI (categories grid) | HIGH | Tops, bottoms, dresses, outerwear, shoes, accessories |
| Add wardrobe item flow (camera + gallery) | HIGH | Auto-stripping EXIF metadata REQUIRED |
| Edit/delete wardrobe items | HIGH | |
| Wardrobe item detail screen | MEDIUM | |
| Basic AI tagging (ML Kit optional) | LOW | Phase 1 can be manual tags |

---

## Week 3: Trip Planning & Weather Integration
**Goal**: Create trips + weather data

| Task | Priority | Notes |
|------|----------|-------|
| Trip data models (including privacy defaults!) | HIGH | Private, hide exact dates/location by default |
| Create trip UI (destination, dates, occasion) | HIGH | |
| Weather API integration (OpenWeatherMap) | HIGH | Real-time + 7-day forecast |
| Trip detail screen (overview, day view) | HIGH | |
| Trips list screen (upcoming + past) | MEDIUM | |
| Trip privacy settings | HIGH | Toggle visibility, date/location hiding |

---

## Week 4: AI Stylist MVP
**Goal**: AI recommendations from user's wardrobe

| Task | Priority | Notes |
|------|----------|-------|
| Set up Gemini API integration | HIGH | Secure API key management! |
| AI prompt engineering (wardrobe + trip + weather) | HIGH | Core feature, spend time getting prompts right |
| AI recommendations UI (3 outfit options) | HIGH | Show items from user's wardrobe first |
| Save/Reject feedback loop for AI learning | MEDIUM | Store preferences locally first |
| AI chat screen (basic form-based) | MEDIUM | Natural language later, Phase 2 |

---

## Week 5: Packing Lists & UI Polish
**Goal**: Full packing lists + beautiful UI

| Task | Priority | Notes |
|------|----------|-------|
| Packing list generation from trip outfits | HIGH | Auto-generate list, allow custom items |
| Packing list UI (checkboxes, shareable) | HIGH | |
| Home dashboard UI (trip preview, quick actions) | HIGH | |
| Bottom navigation setup (Home, Trips, Wardrobe, Stylist, Profile) | HIGH | |
| Profile screen UI (edit profile, settings) | MEDIUM | |
| UI/UX polish & micro-interactions | HIGH | Hero animations, loading states, etc. |

---

## Week 6: Testing, QA & Launch Prep
**Goal**: App Store/Play Store ready

| Task | Priority | Notes |
|------|----------|-------|
| Comprehensive bug testing | HIGH | All flows, edge cases |
| Accessibility checks | HIGH | Screen readers, touch targets |
| Security audit | HIGH | Verify all privacy defaults work |
| App icons, splash screens, store assets | MEDIUM | |
| Firebase security rules | HIGH | Lock down Firestore/Storage! |
| Final build & store submission prep | HIGH | |

---

## Non-Negotiables for All Phases
✅ All data private by default
✅ EXIF stripping on all photo uploads
✅ Encrypted local storage
✅ IDOR checks on all data access
✅ No NSFW content allowed
✅ Follow design system strictly
