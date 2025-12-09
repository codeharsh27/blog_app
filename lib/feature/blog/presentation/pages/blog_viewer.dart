import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';

import 'package:flutter/material.dart';
import '../../domain/entity/blog.dart';

class BlogViewerPage extends StatelessWidget {
  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));
  final Blog blog;
  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Icon(Icons.share_outlined)],
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
                Text(
                  blog.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'By ${blog.posterName}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                Text(
                  '${formatDateBydMMYYYY(blog.updateAt)} . ${calculateReadingTime(blog.content)} min',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppPallete.greyColor,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 500,
                  height: 250,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(blog.imageUrl, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),
                Text(blog.content, style: TextStyle(fontSize: 19, height: 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
