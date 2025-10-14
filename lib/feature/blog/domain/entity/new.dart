import 'dart:convert';
import 'package:blog_app/feature/blog/data/models/news_model.dart' as model;
import 'package:http/http.dart' as http;

class News {
  List<model.NewsModel> news = [];
  // final supabase = Supabase.instance.client;
  Future<void> getNews() async {
    // final DateTime currentTime  = DateTime.now();
    // final  timeStamp = await supabase.from('apilog').select('time').eq('name', 'newApi');
    // final later = timeStamp.add(const Duration(hours: 24));
    //
    // if(timeStamp)
    const String url = 'https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=25d27783b98847ab9787243c794f7fb3';
    final response = await http.get(Uri.parse(url));
    // await supabase.from('apilog').insert({'time': currentTime.toIso8601String(), 'name': 'newsApi'});
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch news: ${response.statusCode}');
    }

    final jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      news.clear();
      for (var element in jsonData['articles']) {
        if (element['urlToImage'] != null && element['description'] != null) {
          news.add(model.NewsModel.fromJson(element));
        }
      }
    }
  }
}
