import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tex/api/api.dart';
import 'package:tex/pages/edit.dart';
import 'package:tex/pages/home.dart';
import 'package:tex/widgets/btmnav.dart';
import 'package:tex/widgets/sidebar.dart';

class OneCardWidget extends StatefulWidget {
  final int id;

  const OneCardWidget({Key key, this.id}) : super(key: key);

  @override
  createState() => new OneCardWidgetState();
}

class OneCardWidgetState extends State<OneCardWidget> {
  // ignore: non_constant_identifier_names
  String img, desc, tag, user_name;
  // ignore: non_constant_identifier_names
  int user_id, cur_user_id;
  var isLoading = false;

  @override
  initState() {
    _fetch();
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        cur_user_id = user['id'];
      });
    }
  }

  _fetch() async {
    isLoading = true;
    var response = await API().getData('reports/' + (widget.id).toString());
    var body = jsonDecode(response.body);
    // print(body['report']['img']);

    if (body['user'] != null) {
      setState(() {
        img = body['report']['img'];
        desc = body['report']['desc'];
        tag = body['report']['tag'];
        user_id = body['user']['id'];
        user_name = body['user']['name'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  transform: GradientRotation(90),
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Color(0xffCF11DF),
                Color(0xff8A1DCD),
                Color(0xffA624B1),
                Color(0xffA524B0)
              ])),
        ),
      ),
      endDrawer: navigationDrawer(),
      bottomNavigationBar: BottomNavWidget(),
      body: SingleChildScrollView(
        child: isLoading
            ? Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.35),
                child: SpinKitWave(
                  color: Color(0xff8A1DCD),
                  size: 100.0,
                ),
              )
            : Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: InteractiveViewer(
                            panEnabled: false, // Set it to false
                            boundaryMargin: EdgeInsets.all(100),
                            minScale: 0.5,
                            maxScale: 2,
                            child: Image.network(
                              'http://nvuti.uz/' + img,
                            ),
                          ),
                        ),
                        _edit(),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0,
                                    right: 25.0,
                                    top: 25.0,
                                    bottom: 0.0),
                                child: Text(
                                  desc,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontFamily: "serif"),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.local_offer),
                                    Text(
                                      tag,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _edit() {
    if (user_id == cur_user_id) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            alignment: Alignment.centerRight,
            color: Color(0xffCF11DF),
            onPressed: () async {
              var route = MaterialPageRoute(
                  builder: (BuildContext context) => Edit(
                        id: widget.id,
                      ));
              Navigator.of(context).push(route).then((value) {
                setState(() {
                  _fetch();
                });
              });
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            color: Color(0xffCF11DF),
            onPressed: () => {showAlertDialog(context, widget.id)},
            icon: Icon(Icons.delete),
          ),
        ],
      );
    } else
      return Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.people),
            Text(
              user_name,
            ),
          ],
        ),
      );
  }

  showAlertDialog(BuildContext context, id) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget confirmButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        _delete(widget.id);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Are you sure you want to delete this item?"),
      actions: [
        confirmButton,
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _delete(id) async {
    var res = await API().delete('reports/' + (id).toString());
    var body = jsonDecode(res.body);
    if (body['success']) {
      var route = MaterialPageRoute(builder: (BuildContext contex) => Home());
      Navigator.pushReplacement(context, route);
    }
  }
}
