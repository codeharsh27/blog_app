import 'package:blog_app/feature/blog/domain/entity/news_essential.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallet.dart';
import '../../../../core/utils/calculate_reading_time.dart';
import '../../../../core/utils/format_date.dart';

class NewsViewerPage extends StatelessWidget {
  static route(NewsEssential news) => MaterialPageRoute(
    builder: (context) => NewsViewerPage(news: news),
  );

  final NewsEssential news;
  const NewsViewerPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.share_outlined),
          ],
        ),
        backgroundColor: AppPallete.transparentColor,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Author
                if (news.author != null && news.author!.isNotEmpty)
                  Text(
                    'By ${news.author}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                const SizedBox(height: 5),

                // Date + Reading time
                Text(
                  '${news.publishedAt != null ? formatDateBydMMYYYY(news.publishedAt!) : ""}'
                      ' • ${calculateReadingTime(news.content ?? "")} min',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppPallete.greyColor,
                  ),
                ),

                const SizedBox(height: 20),

                // Image
                if (news.imageUrl.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        news.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 60),
                            ),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Content
                  Text(
                    news.content!,
                    style: const TextStyle(
                      fontSize: 19,
                      height: 1.6,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
