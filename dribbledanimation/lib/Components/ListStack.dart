import 'package:flutter/material.dart';
import '../Screens/Home/data.dart';

class ListData extends StatelessWidget {
  final EdgeInsets margin;
  final index;
  final double width;
  final String title;
  final String subtitle;
  final DecorationImage image;
  DataListBuilder dataListBuilder = new DataListBuilder();
  ListData({
    this.margin,
    this.subtitle,
    this.title,
    this.width,
    this.image,
    this.index,
  });
  @override
  Widget build(BuildContext context) {
    print(dataListBuilder.rowItemList[index - 2].title);
    return (new Container(
      alignment: Alignment.center,
      // margin: margin,
      //width: width,
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new Border(
          top: new BorderSide(
              width: 1.0, color: const Color.fromRGBO(204, 204, 204, 0.3)),
          bottom: new BorderSide(
              width: 1.0, color: const Color.fromRGBO(204, 204, 204, 0.3)),
        ),
      ),
      child: new Row(
        children: <Widget>[
          new Container(
              margin: new EdgeInsets.only(
                  left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
              width: 60.0,
              height: 60.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: dataListBuilder.rowItemList[index - 2].image)),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                dataListBuilder.rowItemList[index - 2].title,
                style:
                    new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
              ),
              new Padding(
                padding: new EdgeInsets.only(top: 5.0),
                child: new Text(
                  dataListBuilder.rowItemList[index - 2].subtitle,
                  style: new TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
