import 'package:blog_app/feature/blog/presentation/pages/blog_viewer.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallet.dart';
import '../../../../core/utils/calculate_reading_time.dart';
import '../../domain/entity/blog.dart';

class BlogCard extends StatefulWidget {
  final Blog blog;
  const BlogCard({super.key, required this.blog});

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  bool isLiked = false;
  bool isDisliked = false;
  bool isSaved = false;
  int likeCount = 0;
  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    likeCount = 10 + DateTime.now().second % 50;
    commentCount = 1 + DateTime.now().second % 20;
  }

  Widget _buildActionButton(
    IconData icon,
    String count, {
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: iconColor ?? Colors.grey[600]),
            if (count.isNotEmpty) const SizedBox(width: 4),
            if (count.isNotEmpty)
              Text(
                count,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardHeight = MediaQuery.of(context).size.height * 0.5;
    final imageHeight = cardHeight * 0.3;

    return GestureDetector(
      onTap: () => Navigator.push(context, BlogViewerPage.route(widget.blog)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Image (30% of card height)
              Container(
                height: imageHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(widget.blog.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: widget.blog.imageUrl.isEmpty
                    ? Container(
                        color: AppPallete.surfaceColor,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: AppPallete.textSecondary,
                        ),
                      )
                    : null,
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.blog.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Topics
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.blog.topics
                            .map(
                              (topic) => Container(
                                margin: const EdgeInsets.only(
                                  right: 8,
                                  bottom: 8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppPallete.primaryColor.withAlpha(26),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppPallete.primaryColor,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  topic,
                                  style: TextStyle(
                                    color: AppPallete.primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    // Action Buttons
                    const Divider(height: 24, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Like Button
                        _buildActionButton(
                          isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          likeCount.toString(),
                          onTap: () {
                            setState(() {
                              if (isDisliked) {
                                isDisliked = false;
                                likeCount++;
                              }
                              isLiked = !isLiked;
                              likeCount += isLiked ? 1 : -1;
                            });
                          },
                          iconColor: isLiked ? AppPallete.primaryColor : null,
                        ),

                        // Dislike Button
                        _buildActionButton(
                          isDisliked
                              ? Icons.thumb_down
                              : Icons.thumb_down_outlined,
                          '',
                          onTap: () {
                            setState(() {
                              if (isLiked) {
                                isLiked = false;
                                likeCount--;
                              }
                              isDisliked = !isDisliked;
                            });
                          },
                          iconColor: isDisliked ? Colors.red : null,
                        ),

                        // Comment Button
                        _buildActionButton(
                          Icons.mode_comment_outlined,
                          commentCount.toString(),
                          onTap: () {
                            // TODO: Implement comment functionality
                          },
                        ),

                        const Spacer(),

                        // Save Button
                        _buildActionButton(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          '',
                          iconColor: isSaved ? AppPallete.primaryColor : null,
                          onTap: () {
                            setState(() => isSaved = !isSaved);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isSaved
                                      ? 'Saved to bookmarks'
                                      : 'Removed from bookmarks',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),

                        // Share Button
                        _buildActionButton(
                          Icons.ios_share,
                          '',
                          onTap: () {
                            // TODO: Implement share functionality
                          },
                        ),
                      ],
                    ),

                    // Reading Time
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${calculateReadingTime(widget.blog.content)} min read',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
