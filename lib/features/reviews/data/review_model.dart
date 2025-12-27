class ReviewModel {
  final String name;
  final String date;
  final double rating;
  final String text;
  final String? avatarUrl;

  const ReviewModel({
    required this.name,
    required this.date,
    required this.rating,
    required this.text,
    this.avatarUrl,
  });
}
