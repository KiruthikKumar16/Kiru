class SocialPost {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String imageUrl;
  final String caption;
  final String destination;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isVote;
  final String? optionA;
  final String? optionB;

  const SocialPost({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.imageUrl,
    required this.caption,
    required this.destination,
    required this.likes,
    required this.comments,
    this.isLiked = false,
    this.isVote = false,
    this.optionA,
    this.optionB,
  });

  SocialPost copyWith({
    String? id,
    String? authorName,
    String? authorAvatar,
    String? imageUrl,
    String? caption,
    String? destination,
    int? likes,
    int? comments,
    bool? isLiked,
    bool? isVote,
    String? optionA,
    String? optionB,
  }) {
    return SocialPost(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      destination: destination ?? this.destination,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
      isVote: isVote ?? this.isVote,
      optionA: optionA ?? this.optionA,
      optionB: optionB ?? this.optionB,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'imageUrl': imageUrl,
      'caption': caption,
      'destination': destination,
      'likes': likes,
      'comments': comments,
      'isLiked': isLiked,
      'isVote': isVote,
      'optionA': optionA,
      'optionB': optionB,
    };
  }

  factory SocialPost.fromMap(Map<String, dynamic> map) {
    return SocialPost(
      id: map['id'] as String,
      authorName: map['authorName'] as String,
      authorAvatar: map['authorAvatar'] as String,
      imageUrl: map['imageUrl'] as String,
      caption: map['caption'] as String,
      destination: map['destination'] as String,
      likes: map['likes'] as int? ?? 0,
      comments: map['comments'] as int? ?? 0,
      isLiked: map['isLiked'] as bool? ?? false,
      isVote: map['isVote'] as bool? ?? false,
      optionA: map['optionA'] as String?,
      optionB: map['optionB'] as String?,
    );
  }
}
