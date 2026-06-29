# Kiru - Data Model & Database Schema

## Core Entities

---

### 1. User
```dart
class User {
  String id;
  String email;
  String displayName;
  String username; // unique handle
  String? bio;
  String? profileImageUrl;
  DateTime createdAt;
  DateTime updatedAt;
  
  // Profile
  UserProfile profile;
  
  // Privacy
  PrivacySettings privacySettings;
  
  // Social Stats
  int followerCount;
  int followingCount;
  int postCount;
  
  // Premium
  bool isPremium;
  DateTime? premiumExpiresAt;
}

class UserProfile {
  BodyMeasurements? bodyMeasurements;
  String? skinTone; // warm, cool, neutral
  List<String> stylePreferences;
  List<String> dislikedStyles;
  String? stylePersona;
  List<String>? preferredBrands;
  BudgetRange? budget;
}

class PrivacySettings {
  bool isProfilePublic; // true = public, false = private
  bool showWardrobe;
  bool showTrips;
  bool showOutfits;
  bool showActivity;
  bool allowFriendRequests;
  bool allowTagging;
}

class BodyMeasurements {
  double? height; // cm
  double? weight; // kg
  String? bodyType; // hourglass, pear, apple, rectangle, athletic
  String? topSize;
  String? bottomSize;
  String? shoeSize;
  String? dressSize;
}

enum BudgetRange { budget, midRange, luxury }
```

---

### 2. Wardrobe Item
```dart
class WardrobeItem {
  String id;
  String userId;
  String name;
  String? imageUrl;
  String category; // top, bottom, dress, outerwear, shoes, accessory
  List<String> tags;
  String color;
  String? fabric;
  String? season; // winter, spring, summer, fall, all
  DateTime? purchaseDate;
  double? purchasePrice;
  int wearCount;
  DateTime? lastWorn;
  DateTime createdAt;
  bool isArchived;
  
  // Privacy
  String visibility; // private (default), friends_only, public
  
  // AI analysis
  String? aiNotes;
  List<String>? aiPairingSuggestions;
}
```

---

### 3. Outfit
```dart
class Outfit {
  String id;
  String userId;
  String name;
  String? description;
  List<OutfitItem> items;
  String? occasion;
  String? season;
  String? imageUrl; // generated or photo
  bool isSaved;
  DateTime createdAt;
  DateTime? lastUsed;
  
  // Privacy
  String visibility; // private (default), friends_only, public
  
  // AI metadata
  String? aiGenerated;
  double? aiStyleScore;
}

class OutfitItem {
  String wardrobeItemId;
  String? itemName;
  String? itemImageUrl;
  String? notes;
}
```

---

### 4. Trip
```dart
class Trip {
  String id;
  String userId;
  String name;
  String destination;
  String? destinationCity;
  String? destinationCountry;
  DateTime startDate;
  DateTime endDate;
  List<String> occasions;
  List<TripDay> days;
  bool culturalSensitivity;
  bool modestFashionMode;
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;
  
  // Privacy - HIGHLY SENSITIVE (location + dates = burglary risk)
  String visibility; // private (DEFAULT), friends_only, public
  bool hideExactDates; // true by default - show only month/year
  bool hideExactLocation; // true by default - show only city/country
  
  // Weather
  List<WeatherForecast>? weatherForecast;
}

class TripDay {
  DateTime date;
  String? dayName;
  List<DayOutfit> outfits;
  String? notes;
  WeatherForecast? weather;
}

class DayOutfit {
  String outfitId;
  Outfit? outfit;
  String? timeOfDay; // morning, afternoon, evening
  String? occasion;
}
```

---

### 5. Weather Forecast
```dart
class WeatherForecast {
  DateTime date;
  double tempMin;
  double tempMax;
  double tempCurrent;
  String condition; // sunny, rainy, cloudy, snowy
  int humidity;
  double? windSpeed;
  String? icon;
}
```

---

### 6. Packing List
```dart
class PackingList {
  String id;
  String tripId;
  List<PackingItem> items;
  DateTime createdAt;
  DateTime updatedAt;
}

class PackingItem {
  String id;
  String name;
  int quantity;
  bool isPacked;
  String? category;
  String? wardrobeItemId;
}
```

---

### 7. AI Chat Message
```dart
class ChatMessage {
  String id;
  String userId;
  String? tripId;
  String role; // user, assistant
  String content;
  DateTime timestamp;
  List<String>? outfitIds; // if AI recommended outfits
}
```

---

### 8. Style Quiz Response
```dart
class StyleQuizResponse {
  String userId;
  List<QuizAnswer> answers;
  DateTime completedAt;
  Map<String, double> styleScores;
}

class QuizAnswer {
  String questionId;
  String answerId;
  bool liked; // swipe right = true
}
```

---

### 9. Social (Phase 2+)
```dart
// Friend/Follow Relationships
class Follow {
  String id;
  String followerId;
  String followingId;
  DateTime createdAt;
}

class FriendRequest {
  String id;
  String fromUserId;
  String toUserId;
  String status; // pending, accepted, rejected
  DateTime createdAt;
}

// Blocked Users
class Block {
  String id;
  String blockerId;
  String blockedId;
  DateTime createdAt;
}

// Social Posts
class SocialPost {
  String id;
  String userId;
  String? tripId;
  String? outfitId;
  String caption;
  List<String> imageUrls;
  List<String> taggedUserIds;
  List<String> hashtags;
  String? destination;
  String visibility; // public, friends_only, private
  int likeCount;
  int commentCount;
  int saveCount;
  DateTime createdAt;
}

// Likes
class Like {
  String id;
  String postId;
  String userId;
  DateTime createdAt;
}

// Comments
class Comment {
  String id;
  String postId;
  String userId;
  String content;
  List<String> taggedUserIds;
  DateTime createdAt;
}

// Saves/Collections
class SavedPost {
  String id;
  String userId;
  String postId;
  String? collectionId;
  DateTime createdAt;
}

class Collection {
  String id;
  String userId;
  String name;
  String? description;
  bool isPublic;
  DateTime createdAt;
}

// Direct Messages
class Conversation {
  String id;
  List<String> participantIds;
  String? lastMessage;
  DateTime? lastMessageAt;
  DateTime createdAt;
}

class Message {
  String id;
  String conversationId;
  String senderId;
  String content;
  String? outfitId;
  String? tripId;
  String? postId;
  DateTime createdAt;
  bool isRead;
}

// Shared Items
class SharedOutfit {
  String id;
  String outfitId;
  String fromUserId;
  String toUserId;
  String? note;
  DateTime createdAt;
}

class SharedTrip {
  String id;
  String tripId;
  String fromUserId;
  List<String> toUserIds;
  bool canEdit; // collaborative access
  DateTime createdAt;
}

// Wardrobe Loans
class WardrobeLoan {
  String id;
  String itemId;
  String ownerId;
  String borrowerId;
  DateTime borrowedAt;
  DateTime? dueDate;
  DateTime? returnedAt;
  String status; // borrowed, returned, overdue
}

// Outfit Voting
class OutfitVote {
  String id;
  String postId;
  String userId;
  int optionIndex; // 0 or 1
  DateTime createdAt;
}
```

---

## Firestore Schema (Phase 1)

```
users/
  {userId}/
    profile: {}
    preferences: {}
    privacySettings: {}
    followerCount: number
    followingCount: number
    postCount: number
    isPremium: bool

wardrobe/
  {itemId}/
    userId: string
    ...

outfits/
  {outfitId}/
    userId: string
    ...

trips/
  {tripId}/
    userId: string
    ...

chat_messages/
  {messageId}/
    userId: string
    ...

quiz_responses/
  {userId}/
    answers: []
    ...
```

## Firestore Schema (Phase 2 - Social)

```
follows/
  {followId}/
    followerId: string
    followingId: string

friend_requests/
  {requestId}/
    fromUserId: string
    toUserId: string
    status: string

blocks/
  {blockId}/
    blockerId: string
    blockedId: string

posts/
  {postId}/
    userId: string
    ...

likes/
  {likeId}/
    postId: string
    userId: string

comments/
  {commentId}/
    postId: string
    ...

collections/
  {collectionId}/
    userId: string
    ...

saved_posts/
  {savedId}/
    userId: string
    postId: string

conversations/
  {conversationId}/
    participantIds: []
    ...

messages/
  {messageId}/
    conversationId: string
    ...

shared_outfits/
  {shareId}/
    ...

shared_trips/
  {shareId}/
    ...

wardrobe_loans/
  {loanId}/
    ...
```

## Local Storage (Hive/Isar)
- Cache user profile
- Cache wardrobe items
- Cache trips
- Cache outfits
- Offline first strategy
