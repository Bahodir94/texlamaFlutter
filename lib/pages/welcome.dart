import 'package:flutter/material.dart';
import 'package:tex/pages/login.dart';
import 'package:tex/pages/register.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
              ])),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 66.0, right: 97.0, left: 98.0),
                child: Image.asset(
                  'images/logo.png',
                  width: 165.0,
                  height: 188.0,
                ),
              ),
              SizedBox(
                height: 78.0,
              ),
              Container(
                width: 281.0,
                height: 47.0,
                child: OutlineButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Login()));
                    },
                    child: Text(
                      "LOG IN",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 32.0,
              ),
              Container(
                width: 281.0,
                height: 47.0,
                child: OutlineButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Register()));
                    },
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(height: 156.0),
              Padding(
                padding: EdgeInsets.only(bottom: 7.0),
                child: Text(
                  "Terms & Condition",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
