import 'package:blog_app/feature/blog/domain/entity/news_entities.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallet.dart';
import '../../../../core/utils/calculate_reading_time.dart';
import '../../../../core/utils/format_date.dart';

class NewsViewerPage extends StatelessWidget {
  static Route route(NewsModel news) {
    return MaterialPageRoute(builder: (context) => NewsViewerPage(news: news));
  }

  final NewsModel news;
  const NewsViewerPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = news.timestamp.isNotEmpty
        ? formatDateBydMMYYYY(DateTime.parse(news.timestamp))
        : '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPallete.transparentColor,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Icon(Icons.share_outlined)],
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                news.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 20),

              /// Source
              if (news.source.isNotEmpty)
                Text(
                  'By ${news.source}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),

              const SizedBox(height: 5),

              /// Date + Reading time
              if (formattedDate.isNotEmpty)
                Text(
                  '$formattedDate • ${calculateReadingTime(news.content)} min read',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppPallete.greyColor,
                  ),
                ),

              const SizedBox(height: 20),

              /// Image
              if (news.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    news.image,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 60),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              /// Summary / Content
              Text(
                news.content.isNotEmpty
                    ? news.content
                    : 'No content available for this article.',
                style: const TextStyle(fontSize: 18, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
