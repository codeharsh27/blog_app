import 'package:blog_app/feature/blog/domain/entity/news_entities.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallet.dart';
import '../pages/news_viewer.dart';
import 'package:intl/intl.dart';

class TrendNewsCard extends StatefulWidget {
  final NewsModel news;
  const TrendNewsCard({super.key, required this.news});

  @override
  State<TrendNewsCard> createState() => _TrendNewsCardState();
}

class _TrendNewsCardState extends State<TrendNewsCard> {
  bool isLiked = false;
  bool isDisliked = false;
  bool isSaved = false;
  int likeCount = 0;
  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    // Initialize with random counts for demo
    likeCount = 10 + DateTime.now().second % 50; // Random count between 10-59
    commentCount = 1 + DateTime.now().second % 20; // Random count between 1-20
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return '';
    }
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
    final formattedDate = _formatDate(widget.news.timestamp);

    final cardHeight =
        MediaQuery.of(context).size.height * 0.5; // 50% of screen height
    final imageHeight = cardHeight * 0.3; // 30% of card height for image

    return GestureDetector(
      onTap: () => Navigator.push(context, NewsViewerPage.route(widget.news)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
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
                width: double.infinity,
                height: imageHeight,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  image: widget.news.image.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(widget.news.image),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage(
                            'assets/images/news_placeholder.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source and Date
                    Row(
                      children: [
                        Text(
                          widget.news.source,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '•',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Title
                    Text(
                      widget.news.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Description
                    Text(
                      widget.news.content.isNotEmpty
                          ? widget.news.content.length > 150
                                ? '${widget.news.content.substring(0, 150)}...'
                                : widget.news.content
                          : 'No content available',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Like Button
                        _buildActionButton(
                          isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          likeCount.toString(),
                          onTap: () {
                            setState(() {
                              isLiked = !isLiked;
                              if (isLiked) {
                                likeCount++;
                                if (isDisliked) isDisliked = false;
                              } else {
                                likeCount--;
                              }
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
                              isDisliked = !isDisliked;
                              if (isDisliked && isLiked) {
                                likeCount--;
                                isLiked = false;
                              }
                            });
                          },
                          iconColor: isDisliked ? Colors.red : null,
                        ),

                        // Comment Button
                        _buildActionButton(
                          Icons.mode_comment_outlined,
                          commentCount.toString(),
                          onTap: () => Navigator.push(
                            context,
                            NewsViewerPage.route(widget.news),
                          ),
                        ),

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
                          onTap: _shareContent,
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

  void _shareContent() {
    // Show a bottom sheet instead of dialog to avoid overflow issues
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share Article',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Add your share options here
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy link'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied to clipboard')),
                );
              },
            ),
            // Add more share options as needed
          ],
        ),
      ),
    );
  }
}
