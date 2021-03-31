import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class Parser {

  final url = Uri.parse("https://www.france24.com/fr/actualites/rss");

  Future chargerRss() async {
    final response = await http.get(url);
    if (response.statusCode == 200){
      final feed = RssFeed.parse(response.body);
      return feed;
    } else {
      print('Erreur: ${response.statusCode}');
    }
  }
}
