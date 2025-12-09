import 'package:blog_app/core/theme/app_pallet.dart';

import 'package:blog_app/feature/blog/data/models/news_model.dart' as model;
import 'package:blog_app/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/feature/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/feature/blog/presentation/widget/blog_card.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/new.dart'; // contains News() class
import '../widget/news_card.dart'; // contains TrendNewsCard widget

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage>
    with SingleTickerProviderStateMixin {
  List<model.NewsModel> news = [];
  final News _newsService = News();
  late TabController _tabController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Load blogs
    if (mounted) {
      context.read<BlogBloc>().add(BlogFetchAllBlogs());
    }

    // Load news with cache-first strategy
    await _loadNews();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNews({bool forceRefresh = false}) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }

    try {
      // Try to get news (will use cache if valid)
      final freshNews = await _newsService.getNews(forceRefresh: forceRefresh);

      if (mounted) {
        setState(() {
          news = freshNews;
          _isLoading = false;
        });
      }

      // Then try to refresh in background if this wasn't a forced refresh
      if (!forceRefresh) {
        _refreshNewsInBackground();
      }

      // Clear any previous error messages
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    } catch (e) {
      // Log the error
      debugPrint('Error loading news: $e');

      // If we have cached data, use it
      if (_newsService.news.isNotEmpty) {
        if (mounted) {
          setState(() {
            news = _newsService.news;
          });
        }
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });

        String errorMessage = 'Failed to load news';
        if (e.toString().contains('timeout') || e is TimeoutException) {
          errorMessage = 'Server is taking too long to respond';
        } else if (e.toString().contains('network') ||
            e.toString().contains('connection')) {
          errorMessage = 'No internet connection';
        }

        if (news.isEmpty) {
          _showErrorSnackbar('$errorMessage. Pull down to retry.');
        } else {
          _showErrorSnackbar('$errorMessage. Showing cached data.');
        }
      }
    }
  }

  // Build section header
  Widget _buildHeaderSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          // Container(
          //   padding: const EdgeInsets.all(8),
          //   decoration: BoxDecoration(
          //     color: AppPallete.primaryColor.withOpacity(0.1),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          // ),
          // const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Build AI Summary Card
  Widget _buildAISummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(158, 158, 158, 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppPallete.primaryColor.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppPallete.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'AI-Powered Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Here\'s what\'s trending in tech today: AI advancements, latest framework updates, and startup funding news. Stay ahead with these key insights...',
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Read More',
                style: TextStyle(color: AppPallete.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Get time-based greeting
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    } else if (hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }

  // Helper method to show error messages
  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Refresh news in background
  Future<void> _refreshNewsInBackground() async {
    try {
      await _newsService.getNews(forceRefresh: true);
      if (mounted && _newsService.news.isNotEmpty) {
        setState(() {
          news = _newsService.news;
        });
        // _showErrorSnackbar('News updated');
      }
    } catch (e) {
      debugPrint('Background refresh failed: $e');
    }
  }

  // Build the For You tab content
  Widget _buildForYouTab() {
    if (_isLoading && news.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError && news.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Failed to load news'),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _loadNews, child: const Text('Retry')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadNews(forceRefresh: true),
      child: CustomScrollView(
        slivers: [
          // Welcome Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good ${_getGreeting()},',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const Text(
                    'Discover Tech Insights',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // AI Summary Section
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverToBoxAdapter(child: _buildAISummary()),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Latest News Section
          SliverToBoxAdapter(child: _buildHeaderSection('Latest Tech News')),

          // News Grid
          if (news.isEmpty)
            const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            // First featured news card (full width)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                  left: 16,
                  right: 16,
                ),
                child: news.isNotEmpty
                    ? TrendNewsCard(news: news[0].toEntity())
                    : null,
              ),
            ),

          // Remaining news cards in a list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Start from index 1 since we already showed index 0
                final newsIndex = index + 1;
                if (newsIndex >= news.length) return null;
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                    left: 16,
                    right: 16,
                  ),
                  child: TrendNewsCard(news: news[newsIndex].toEntity()),
                );
              },
              // Show remaining cards (total - 1 since we already showed the first one)
              childCount: news.length > 1 ? news.length - 1 : 0,
            ),
          ),
        ],
      ),
    );
  }

  // Build the Blogs tab content
  Widget _buildBlogsTab() {
    return BlocBuilder<BlogBloc, BlogState>(
      builder: (context, state) {
        if (state is BlogLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is BlogDisplaySuccess) {
          if (state.blogs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('No blogs available'),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.blogs.length,
            itemBuilder: (context, index) {
              final blog = state.blogs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: BlogCard(blog: blog),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                titleSpacing: 0,
                leading: Container(
                  margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                title: const Text(
                  'Tech Insight',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFBBDEFB), Colors.white],
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        // Add search functionality here
                      },
                    ),
                  ),
                ],
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  tabs: const [
                    Tab(icon: Icon(Icons.add, size: 20)),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('For You'),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Blogs'),
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              // Empty container for the first tab (Add)
              const Center(child: Icon(Icons.add, size: 50)),
              // For You Tab
              RefreshIndicator(
                onRefresh: () async {
                  // Refresh both blogs and news
                  if (mounted) {
                    context.read<BlogBloc>().add(BlogFetchAllBlogs());
                  }
                  await _loadNews();
                },
                child: _buildForYouTab(),
              ),
              // Blogs Tab
              RefreshIndicator(
                onRefresh: () {
                  context.read<BlogBloc>().add(BlogFetchAllBlogs());
                  return Future.value();
                },
                child: _buildBlogsTab(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, AddNewBlogPage.route());
          },
          backgroundColor: AppPallete.primaryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          label: const Text(
            'New Post',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          icon: const Icon(Icons.add, size: 20),
        ),
      ),
    );
  }
}
