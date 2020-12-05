import 'package:flutter/material.dart';
import 'package:tex/pages/view.dart';

class CardWidget extends StatefulWidget {
  final String image, text, tag;
  final int id;

  const CardWidget({Key key, this.id, this.image, this.text, this.tag})
      : super(key: key);

  @override
  createState() => new CardWidgetState();
}

class CardWidgetState extends State<CardWidget> {
  @override
  initState() {
    super.initState();
  }

  void _view() {
    // Navigator.pushNamed(context, "view");
    var route = MaterialPageRoute(
        builder: (BuildContext context) => OneCardWidget(
              id: widget.id,
            ));
    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _view,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Image.network(
                'http://nvuti.uz/' + widget.image,
                height: MediaQuery.of(context).size.height * 0.15,
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.text,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "serif",
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
