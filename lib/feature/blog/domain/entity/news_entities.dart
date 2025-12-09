class NewsModel {
  final String source;
  final String title;
  final String content;
  final String link;
  final String image;
  final String timestamp;

  const NewsModel({
    this.source = 'Unknown',
    this.title = '',
    this.content = '',
    this.link = '',
    this.image = 'https://via.placeholder.com/600x400.png?text=No+Image',
    this.timestamp = '',
  });
}
