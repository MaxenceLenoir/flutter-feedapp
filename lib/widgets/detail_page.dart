import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';

class DetailPage extends StatelessWidget {
  RssItem item;

  DetailPage(RssItem item) {
    this.item = item;
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Detail de l'artticle"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(item.title, style: TextStyle(fontSize: 30)),
              Card(
                elevation: 7,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Image.network(item.enclosure.url, fit: BoxFit.fill),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.source != null ? item.source.value : "Inconnu"),
                  getHour(item.pubDate)
                ],
              ),
              Text(item.description)
            ],
          )
        )
      );
    }

  Text getHour(date) {
    int hours = DateTime.now().difference(date).inHours.toInt().floor();
    return Text("il y a $hours heures", style: TextStyle(color: Colors.red, fontSize: 12));
  }
}