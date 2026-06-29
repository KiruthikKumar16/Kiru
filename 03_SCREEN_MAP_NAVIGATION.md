# Kiru - Screen Map & Navigation Flow

## Main Navigation Structure
Bottom Navigation Bar with 6 main tabs:

1. **Home** - Dashboard & discovery
2. **Feed** - Social feed
3. **Trips** - Trip planning & calendar
4. **Wardrobe** - Virtual wardrobe
5. **Stylist** - AI chat stylist
6. **Profile** - Settings & account

---

## Complete Screen Hierarchy

### 1. Authentication Flow
```
Splash Screen
  ↓
Welcome Screen
  ↓
Login / Signup
  ├─ Email/Password
  ├─ Google
  ├─ Apple
  └─ Facebook
```

### 2. Onboarding Flow (First-time users)
```
Welcome Onboarding
  ↓
Style Quiz (Swipe-based)
  ├─ Outfit preference cards
  ├─ Color palette selection
  └─ Style persona choice
  ↓
Body Profile
  ├─ Upload photo (auto-detect)
  ├─ Manual measurements
  └─ Body type selection
  ↓
Skin Tone Detection
  ↓
Wardrobe Setup
  └─ Add first items (optional)
  ↓
Home Screen
```

### 3. Home Tab
```
Home Dashboard
  ├─ Trip of the Day (Inspiration)
  ├─ Upcoming Trips Preview
  ├─ Trending Destinations
  ├─ Style Challenges
  └─ Quick Actions
      ├─ Plan New Trip
      ├─ Add to Wardrobe
      └─ AI Quick Recommendation
```

### 4. Feed Tab (Social)
```
Social Feed
  ├─ Home Feed (Friends/Following)
  │   ├─ Post Detail
  │   │   ├─ Likes List
  │   │   ├─ Comments
  │   │   └─ Share Post
  │   └─ Create Post
  │       ├─ Outfit Post
  │       ├─ Trip Post
  │       └─ Outfit Vote (2 options)
  ├─ Discover
  │   ├─ Destination Style Feed
  │   ├─ Trending Outfits
  │   ├─ Trip Twin Finder
  │   └─ Creator Marketplace
  ├─ Notifications
  │   ├─ Friend Requests
  │   ├─ Likes
  │   ├─ Comments
  │   ├─ Tags
  │   └─ Shares
  └─ Messages
      ├─ Conversation List
      └─ Chat Detail
          ├─ Share Outfit
          ├─ Share Trip
          └─ Share Post
```

### 5. Trips Tab
```
Trips Overview
  ├─ Upcoming Trips List
  ├─ Past Trips List
  ├─ Shared With Me Trips
  └─ Create New Trip
      ↓
  Trip Details
      ├─ Trip Overview
      ├─ Day-by-Day Calendar
      │   └─ Day Detail (Outfits + Weather)
      ├─ Packing List
      ├─ Luggage Weight Estimator
      ├─ Invite Friends (Collaborate)
      └─ Share Trip
```

### 6. Wardrobe Tab
```
Wardrobe Dashboard
  ├─ Categories Grid
  │   ├─ Tops
  │   ├─ Bottoms
  │   ├─ Dresses
  │   ├─ Outerwear
  │   ├─ Shoes
  │   └─ Accessories
  ├─ Add Item
  │   ├─ Camera Scan
  │   ├─ Photo Upload
  │   └─ Manual Entry
  ├─ Wardrobe Analytics
  │   ├─ Color Palette Chart
  │   ├─ Cost-per-Wear
  │   └─ Declutter Suggestions
  ├─ Loaned Items (Borrowed/Lent)
  └─ Item Detail
      ├─ Edit Item
      ├─ Outfit Pairings
      ├─ Loan Item to Friend
      └─ Delete
```

### 7. Stylist Tab
```
AI Stylist Chat
  ├─ Chat Interface
  ├─ Voice Input
  ├─ Style Personas
  ├─ Surprise Me
  └─ Recommendation Detail
      ├─ Save Outfit
      ├─ Share Outfit with Friend
      ├─ Mix & Match
      ├─ Generate Image
      └─ AR Try-On (Phase 2)
```

### 8. Profile Tab
```
Profile Dashboard
  ├─ View Public Profile
  ├─ Edit Profile
  │   ├─ Username
  │   ├─ Display Name
  │   ├─ Bio
  │   └─ Profile Photo
  ├─ Followers List
  ├─ Following List
  ├─ My Posts Grid
  ├─ Saved Posts/Collections
  ├─ Style Preferences
  ├─ Body Measurements
  ├─ Saved Outfits
  ├─ Settings
  │   ├─ Notifications
  │   ├─ Privacy Settings
  │   │   ├─ Profile Visibility
  │   │   ├─ Wardrobe Visibility
  │   │   ├─ Trip Visibility
  │   │   └─ Blocked Users
  │   ├─ Modest Fashion Mode
  │   ├─ Cultural Sensitivity
  │   └─ Language
  ├─ Premium Subscription
  └─ Help & Support
```

### 9. Other User Profiles
```
User Profile
  ├─ Follow/Unfollow
  ├─ Send Friend Request
  ├─ Message
  ├─ User's Posts Grid
  ├─ User's Outfits (if public)
  └─ User's Trips (if public)
```

---

## Navigation Transitions
- Use **Hero animations** for outfit/wardrobe items
- Smooth page transitions with GoRouter
- Bottom nav with slide/fade effects

## Deep Linking
- `kiru://trip/{tripId}` - Open specific trip
- `kiru://outfit/{outfitId}` - Open specific outfit
- `kiru://share/{shareId}` - Open shared trip
- `kiru://profile/{username}` - Open user profile
- `kiru://post/{postId}` - Open social post
- `kiru://conversation/{conversationId}` - Open DM conversation
