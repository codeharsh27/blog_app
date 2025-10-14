import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/feature/blog/data/models/news_model.dart' as model;
import 'package:blog_app/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/feature/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/feature/blog/presentation/widget/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/news_essential.dart';
import '../../domain/entity/new.dart';
import '../widget/news_card.dart';  // <-- contains News class


class BlogPage extends StatefulWidget {
  static route()=> MaterialPageRoute(builder: (context)=> const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  // bool _loading = true;
  List<model.NewsModel> news = [];

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
    getNews();
  }

  getNews() async {
    News newsclass = News(); // from new.dart
    await newsclass.getNews();
    news = newsclass.news;
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.terminal_rounded, size: 28,),
            const Text('Dev', style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: 28
            ),),
            const Text('App',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
          ],
        ),
        backgroundColor: AppPallete.transparentColor,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, AddNewBlogPage.route());
          }, icon: Icon(Icons.file_upload_outlined, size: 25,)),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state){
            if(state is BlogFailure){
              showSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            if(state is BlogLoading){
              return const Loader();
            }
            if(state is BlogDisplaySuccess){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 10, 5),
                    child: Text('Latest Tech Blogs', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),),
                  ),
                  SizedBox(
                      height: 305,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,  // if want change vertical <--> horizontal
                          itemCount: state.blogs.length,
                          itemBuilder: (context, index){
                            final blog = state.blogs[index];
                            return BlogCard(blog: blog, color: AppPallete.gradient3);
                          }),
                    ),
                  const SizedBox(height: 10,),
                  Text("  Trending TechCrunches", style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 20,),),
                  const SizedBox(height: 10,),
                  Container(
                    // height: 200, // important! ListView needs height inside Column
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        final newsItem = NewsEssential(
                          title: news[index].title ?? '',
                          imageUrl: news[index].urlToImage ?? '',
                          desc: news[index].description ?? '',
                          author: news[index].author,
                          content: news[index].content,
                          publishedAt: news[index].publishedAt,
                        );
                        return TrendNewsCard(
                          color: AppPallete.gradient1,
                          news: newsItem,
                        );
                      },
                    ),
                  )
        
                ],
              );
            }
            return const SizedBox();
          }
        ),
      ),
    );
  }
}
