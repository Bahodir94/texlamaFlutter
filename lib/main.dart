import 'package:flutter/material.dart';
import 'package:tex/pages/create.dart';
import 'package:tex/pages/home.dart';
import 'package:tex/pages/login.dart';
import 'package:tex/pages/register.dart';
import 'package:tex/pages/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      debugShowCheckedModeBanner: false,
      home: CheckAuth(),
      routes: {
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/register': (context) => Register(),
        '/welcome': (context) => Welcome(),
        '/create': (context) => Create(),
      },
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        isLoading = false;
      });
    });
    Widget child;
    if (isAuth) {
      child = Home();
    } else {
      child = Welcome();
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: isLoading
            ? Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(15.0),
                        padding: EdgeInsets.all(15.0),
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(color: Color(0xff8A1DCD)),
                        child: Image.asset("images/logo.png")),
                    SpinKitWave(
                      color: Color(0xff8A1DCD),
                      size: 100.0,
                    ),
                  ],
                ),
              )
            : child,
      ),
    );
  }
}
