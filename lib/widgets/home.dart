import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:feedapp/models/parser.dart';
import 'detail_page.dart';
import 'chargement.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  RssFeed feed;
  List<RssItem> listItems = [];
  RssItem selectedArticle;

  @override
  void initState() {
    super.initState();
    parse();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: bodyChoice(orientation),
    );
  }

  Future<Null> parse() async {
    RssFeed recu = await Parser().chargerRss();
    if (recu != null ){
      setState(() {
        feed = recu;
        feed.items.forEach((element) {
          RssItem item = element;
          listItems.add(element);
          if (item.source != null) {
            print(item.enclosure.url);
          }
        });
      });
    }
  }

  Text getHour(date) {
    int hours = DateTime.now().difference(date).inHours.toInt().floor();
    return Text("il y a $hours heures", style: TextStyle(color: Colors.red, fontSize: 12));
  }

  Widget grid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(7.5),
          child: Card(
            elevation: 10,
            child: InkWell(
              onTap: () => print('Tap grid'),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(listItems[index].source != null ? listItems[index].source.value : 'Inconnu', style: TextStyle(fontSize: 12)),
                      getHour(listItems[index].pubDate),
                    ]
                  ),
                  Text(listItems[index].title, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
                  Image.network(listItems[index].enclosure.url)
                ],
              ),
            )
          )
        );
      },
    );
  }

  Widget list() {
    return ListView.builder(
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(7.5),
          child: Card(
            elevation: 10,
            child: InkWell(
              onTap: () {
                setState((){
                  selectedArticle = listItems[index];
                });
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return DetailPage(selectedArticle);
                }));
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(listItems[index].source != null ? listItems[index].source.value : 'Inconnu', style: TextStyle(fontSize: 12)),
                      getHour(listItems[index].pubDate),
                    ]
                  ),
                  Padding(
                    child: Text(listItems[index].title, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                  ),
                  Image.network(listItems[index].enclosure.url)
                ],
              ),
              )
            )
          )
        );
      },
    );
  }

  Widget bodyChoice(Orientation orientation) {
    if (feed == null) {
      return Chargement();
    } else {
      return (orientation == Orientation.portrait) ? list() : grid();
    }
  }
}