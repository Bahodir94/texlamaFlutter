import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tex/api/api.dart';
import 'package:tex/models/report.dart';
import 'package:tex/pages/view.dart';
import 'package:tex/widgets/btmnav.dart';
import 'package:tex/widgets/sidebar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name;

  var isLoading = false;
  var rep = new List<Report>();

  @override
  void initState() {
    fetch();
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        name = user['username'];
      });
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  fetch() async {
    setState(() {
      isLoading = true;
    });
    var resp = await API().getData('reports');
    if (resp.statusCode == 200) {
      final jsonList = json.decode(resp.body) as List;
      final repList = jsonList.map((map) => Report.fromJson(map)).toList();
      setState(() {
        isLoading = false;
        rep = repList;
      });
      return repList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/create');
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.camera_alt),
              ),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        elevation: 0,
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
        physics: ScrollPhysics(),
        child: ReportView(),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ReportView() {
    if (isLoading) {
      return Container(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
        child: SpinKitWave(
          color: Color(0xff8A1DCD),
          size: 100.0,
        ),
      );
    } else {
      return Center(
        child: Container(
          margin: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(children: <Widget>[
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: rep.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: InkWell(
                      onTap: () async {
                        var route = MaterialPageRoute(
                            builder: (BuildContext context) => OneCardWidget(
                                  id: rep[index].id,
                                ));
                        await Navigator.of(context).push(route).then((value) {
                          setState(() {
                            fetch();
                          });
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Image.network(
                              'http://nvuti.uz/' + rep[index].img,
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    rep[index].desc,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontSize: 14.0,
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
                })
          ]),
        ),
      );
    }
  }
}
