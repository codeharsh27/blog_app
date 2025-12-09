import '../../domain/entity/news_entities.dart' as entity;

class NewsModel extends entity.NewsModel {
  const NewsModel({
    super.source = 'Unknown',
    super.title = '',
    super.content = '',
    super.link = '',
    super.image = 'https://via.placeholder.com/600x400.png?text=No+Image',
    super.timestamp = '',
  });

  factory NewsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const NewsModel();
    }

    return NewsModel(
      source: json['source']?.toString() ?? 'Unknown',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      link: json['link']?.toString() ?? '',
      image:
          json['image']?.toString() ??
          'https://via.placeholder.com/600x400.png?text=No+Image',
      timestamp: json['timestamp']?.toString() ?? '',
    );
  }

  /// Converts data-layer model to domain-layer entity
  entity.NewsModel toEntity() {
    return entity.NewsModel(
      source: source,
      title: title,
      content: content,
      link: link,
      image: image,
      timestamp: timestamp,
    );
  }
}
