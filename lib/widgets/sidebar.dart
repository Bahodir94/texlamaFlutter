import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tex/api/api.dart';
import 'package:tex/pages/home.dart';

// ignore: camel_case_types
class navigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 1.5,
        child: Column(children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  transform: GradientRotation(197.56),
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xffCF11DF),
                    Color(0xff8A1DCD),
                    Color(0xffA624B1),
                    Color(0xffA524B0)
                  ]),
            ),
            child: null,
            // child: Image.asset('/images/logo.png'),
            // child: nu,
          ),
          Expanded(
              child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: Text('My Profile'),
                leading: Icon(Icons.people_alt),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
              ListTile(
                title: Text('Reports'),
                leading: Icon(Icons.report),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
              ListTile(
                  title: Text('Logout'),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () {
                    _logout(context);
                  })
            ],
          )),
          Container(
            color: Colors.black26,
            width: double.infinity,
            height: 0.1,
          ),
          Container(
              padding: EdgeInsets.all(10),
              height: 50.0,
              child: Text(
                "V1.0.0",
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
              )),
        ]));
  }

  void _logout(context) async {
    var res = await API().getData('logout');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }
}
