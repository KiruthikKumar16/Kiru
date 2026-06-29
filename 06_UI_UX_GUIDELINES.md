# Kiru - UI/UX Guidelines & Design System

## Design Philosophy
Clean, modern, and elegant - prioritizing usability while staying fashion-forward.

---

## Color Palette

### Primary Colors
- **Primary: #6366F1 (Indigo 500)
- **Primary Light: #818CF8 (Indigo 400)
- **Primary Dark: #4F46E5 (Indigo 600)

### Secondary Colors
- **Secondary: #EC4899 (Pink 500)
- **Accent: #10B981 (Emerald 500)

### Neutral Colors
- **Background: #FFFFFF (White)
- **Surface: #F8FAFC (Slate 50)
- **Text Primary: #1E293B (Slate 800)
- **Text Secondary: #64748B (Slate 500)
- **Border: #E2E8F0 (Slate 200)

### Semantic Colors
- **Success: #10B981
- **Warning: #F59E0B
- **Error: #EF4444
- **Info: #3B82F6

---

## Typography

### Font Family
- **Primary: Inter (Google Fonts)
- **Headings: Inter Bold/Semi-bold
- **Body: Inter Regular/Medium

### Type Scale
```
displayLarge: 32px, Bold
displayMedium: 28px, Bold
headlineLarge: 24px, SemiBold
headlineMedium: 20px, SemiBold
titleLarge: 18px, SemiBold
titleMedium: 16px, Medium
bodyLarge: 16px, Regular
bodyMedium: 14px, Regular
bodySmall: 12px, Regular
labelLarge: 14px, Medium
labelSmall: 11px, Medium
```

---

## Spacing System
```
spacing-0: 0
spacing-1: 4px
spacing-2: 8px
spacing-3: 12px
spacing-4: 16px
spacing-5: 20px
spacing-6: 24px
spacing-8: 32px
spacing-10: 40px
spacing-12: 48px
```

---

## Border Radius
```
radius-sm: 4px
radius-md: 8px
radius-lg: 12px
radius-xl: 16px
radius-2xl: 24px
radius-full: 9999px
```

---

## Shadows
```
shadow-sm: subtle
shadow-md: medium
shadow-lg: large
shadow-xl: extra large
```

---

## Component Guidelines

### Buttons
- Primary button: filled, primary color
- Secondary button: outlined
- Text button: no border, text only
- All buttons: minimum height 48px (touch target)

### Cards
- Elevation: shadow-md
- Border radius: radius-lg
- Padding: spacing-4

### Input Fields
- Height: 56px
- Border radius: radius-md
- Focus: primary color border

### Bottom Navigation
- 5 icons
- Selected: primary color
- Unselected: text-secondary
- Height: 64px

---

## Animations
- Hero animations for item transitions
- Smooth page transitions (300ms)
- Micro-interactions on buttons
- Loading states with shimmer effect
- Pull to refresh

---

## Accessibility
- Minimum touch target: 48x48px
- Color contrast ratio: 4.5:1 minimum
- Screen reader support
- Semantic labels for all interactive elements
- Dark mode support (Phase 2)

---

## Iconography
- Use Material Icons / Cupertino Icons
- Consistent icon style: outlined
- Icon size: 24dp standard

---

## Imagery
- High-quality outfit photos
- Consistent aspect ratios:
  - Square (1:1) for wardrobe items
  - 4:3 for trip cards
  - 16:9 for hero images

---

## UI Patterns

### Swipe Cards (Style Quiz)
- Draggable left/right
- Left = dislike
- Right = like
- Visual feedback: green check / red x

### Outfit Builder
- Drag and drop
- Grid layout
- Visual pairing suggestions

### Trip Calendar
- Horizontal timeline
- Weather icons
- Outfit previews

---

## Onboarding UX
- 4-5 screens maximum
- Progress indicator
- Skip option (but encourage completion)
- Visual, not text-heavy

---

## Empty States
- Friendly illustrations
- Clear call-to-action
- Encourage user action
