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
}
