import 'package:blog_app/feature/blog/presentation/pages/blog_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/calculate_reading_time.dart';
import '../../domain/entity/blog.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, BlogViewerPage.route(blog));
      },
      child: Container(
        width: 350,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Image
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      blog.imageUrl,
                      fit: BoxFit.cover, // fills box proportionally
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                /// title
                Text(blog.title, style:const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:blog.topics.map((e)=>Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Chip(label: Text(e),
                      ),
                    ),
                    ).toList(),
                  ),
                ),
              ],
            ),

            // const SizedBox(height: 10,),
            /// time taken to read content
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${calculateReadingTime(blog.content)} min', style: TextStyle(fontSize: 15),),
                // const SizedBox(width: 20,),
                ///share button
                Icon(Icons.share_outlined, size: 20,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
