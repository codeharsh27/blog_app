class NewsEssential {
  final String imageUrl;
  final String desc;
  final String title;
  final String? author;
  final String? content;
  final DateTime? publishedAt;

  NewsEssential({
    required this.title,
    required this.imageUrl,
    required this.desc,
    this.author, this.content,this.publishedAt,
  });
}

