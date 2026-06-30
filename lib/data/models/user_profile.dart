import 'dart:convert';

class UserProfile {
  final String uid;
  final String username;
  final String displayName;
  final String photoUrl;
  final String bio;
  final String bodyShape;
  final String undertone;
  final List<String> stylePreferences;
  final bool culturalSensitivity;
  final bool modestFashion;

  UserProfile({
    required this.uid,
    required this.username,
    required this.displayName,
    required this.photoUrl,
    required this.bio,
    required this.bodyShape,
    required this.undertone,
    this.stylePreferences = const [],
    this.culturalSensitivity = true,
    this.modestFashion = false,
  });

  UserProfile copyWith({
    String? uid,
    String? username,
    String? displayName,
    String? photoUrl,
    String? bio,
    String? bodyShape,
    String? undertone,
    List<String>? stylePreferences,
    bool? culturalSensitivity,
    bool? modestFashion,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      bodyShape: bodyShape ?? this.bodyShape,
      undertone: undertone ?? this.undertone,
      stylePreferences: stylePreferences ?? this.stylePreferences,
      culturalSensitivity: culturalSensitivity ?? this.culturalSensitivity,
      modestFashion: modestFashion ?? this.modestFashion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'bio': bio,
      'bodyShape': bodyShape,
      'undertone': undertone,
      'stylePreferences': stylePreferences,
      'culturalSensitivity': culturalSensitivity,
      'modestFashion': modestFashion,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      displayName: map['displayName'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      bio: map['bio'] ?? '',
      bodyShape: map['bodyShape'] ?? '',
      undertone: map['undertone'] ?? '',
      stylePreferences: (map['stylePreferences'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      culturalSensitivity: map['culturalSensitivity'] as bool? ?? true,
      modestFashion: map['modestFashion'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) => UserProfile.fromMap(json.decode(source));
}
