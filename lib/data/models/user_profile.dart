import 'dart:convert';

class BodyMeasurements {
  final double height; // cm
  final double weight; // kg
  final double chest; // cm
  final double waist; // cm
  final double hips; // cm
  final double inseam; // cm

  const BodyMeasurements({
    this.height = 0,
    this.weight = 0,
    this.chest = 0,
    this.waist = 0,
    this.hips = 0,
    this.inseam = 0,
  });

  BodyMeasurements copyWith({
    double? height,
    double? weight,
    double? chest,
    double? waist,
    double? hips,
    double? inseam,
  }) {
    return BodyMeasurements(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      chest: chest ?? this.chest,
      waist: waist ?? this.waist,
      hips: hips ?? this.hips,
      inseam: inseam ?? this.inseam,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'weight': weight,
      'chest': chest,
      'waist': waist,
      'hips': hips,
      'inseam': inseam,
    };
  }

  factory BodyMeasurements.fromMap(Map<String, dynamic> map) {
    return BodyMeasurements(
      height: (map['height'] as num?)?.toDouble() ?? 0,
      weight: (map['weight'] as num?)?.toDouble() ?? 0,
      chest: (map['chest'] as num?)?.toDouble() ?? 0,
      waist: (map['waist'] as num?)?.toDouble() ?? 0,
      hips: (map['hips'] as num?)?.toDouble() ?? 0,
      inseam: (map['inseam'] as num?)?.toDouble() ?? 0,
    );
  }
}

class UserProfile {
  final String uid;
  final String username;
  final String displayName;
  final String photoUrl;
  final String bio;
  final String bodyShape;
  final String undertone;
  final String stylePersona;
  final List<String> stylePreferences;
  final List<String> favoriteColors;
  final BodyMeasurements measurements;
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
    this.stylePersona = '',
    this.stylePreferences = const [],
    this.favoriteColors = const [],
    this.measurements = const BodyMeasurements(),
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
    String? stylePersona,
    List<String>? stylePreferences,
    List<String>? favoriteColors,
    BodyMeasurements? measurements,
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
      stylePersona: stylePersona ?? this.stylePersona,
      stylePreferences: stylePreferences ?? this.stylePreferences,
      favoriteColors: favoriteColors ?? this.favoriteColors,
      measurements: measurements ?? this.measurements,
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
      'stylePersona': stylePersona,
      'stylePreferences': stylePreferences,
      'favoriteColors': favoriteColors,
      'measurements': measurements.toMap(),
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
      stylePersona: map['stylePersona'] ?? '',
      stylePreferences: (map['stylePreferences'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      favoriteColors: (map['favoriteColors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      measurements: map['measurements'] != null
          ? BodyMeasurements.fromMap(map['measurements'])
          : const BodyMeasurements(),
      culturalSensitivity: map['culturalSensitivity'] as bool? ?? true,
      modestFashion: map['modestFashion'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) => UserProfile.fromMap(json.decode(source));
}
