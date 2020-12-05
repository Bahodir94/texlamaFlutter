import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tex/api/api.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          child: _isLoading
              ? Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.35),
                  child: SpinKitWave(
                    color: Colors.white,
                    size: 100.0,
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.only(top: 66.0, right: 97.0, left: 98.0),
                      child: Image.asset(
                        'images/logo.png',
                        width: 165.0,
                        height: 188.0,
                      ),
                    ),
                    SizedBox(
                      height: 80.0,
                    ),
                    Container(
                      child: Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          Container(
                              width: 281.0,
                              height: 43.0,
                              child: TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                                textInputAction: TextInputAction.next,
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(5),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  suffixIcon: Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (emailValue) {
                                  if (emailValue.isEmpty) {
                                    return 'Please enter email';
                                  }
                                  email = emailValue;
                                  return null;
                                },
                              )),
                          SizedBox(
                            height: 14.0,
                          ),
                          Container(
                            width: 281.0,
                            height: 43.0,
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              obscureText: true,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                suffixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.white,
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                              validator: (passwordValue) {
                                if (passwordValue.isEmpty) {
                                  return 'Please enter some text';
                                }
                                password = passwordValue;
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 52.0,
                          ),
                          Container(
                            width: 281.0,
                            height: 47.0,
                            child: OutlineButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _login();
                                  }
                                },
                                child: Text(
                                  'LOGIN',
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
                            height: 15.0,
                          ),
                          InkWell(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  fontSize: 13.0),
                            ),
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/register');
                            },
                          ),
                          SizedBox(
                            height: 80.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 7.0),
                            child: Text(
                              "Terms & Condition",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 11.0),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    var data = {'email': email, 'password': password};
    var res = await API().post(data, 'login');
    if (res == null) {
      setState(() {
        _isLoading = false;
      });
      _showMsg("The connection has timed out, Please try again!");
    } else {
      var body = json.decode(res.body);

      if (body['success']) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', body['token']);
        localStorage.setString('user', json.encode(body['user']));
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _isLoading = false;
        _showMsg(body['message']);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
