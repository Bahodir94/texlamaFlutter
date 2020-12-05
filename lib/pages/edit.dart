import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tex/api/api.dart';
import 'package:tex/widgets/btmnav.dart';
import 'package:tex/widgets/sidebar.dart';

class Edit extends StatefulWidget {
  final int id;
  const Edit({Key key, this.id}) : super(key: key);
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  String newImg;
  String name;
  String token;
  File _image;

  Future<File> file;
  File tmpFile;
  String base64Image;

  String img, des, tag;
  final desc = TextEditingController();
  final tags = TextEditingController();

  var isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetch();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _fetch() async {
    isLoading = true;
    var response = await API().getData('reports/' + (widget.id).toString());
    if (response == null) {
      setState(() {
        isLoading = false;
      });
      _showMsg("The connection has timed out, Please try again!");
    } else {
      var body = jsonDecode(response.body);
      if (body['report']['id'] != null) {
        setState(() {
          desc.text = body['report']['desc'];
          tags.text = body['report']['tag'];
          img = body['report']['img'];
          isLoading = false;
        });
      } else {
        isLoading = false;
        _showMsg("Error!");
      }
    }
  }

  _imgFromCamera() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 70);

    setState(() {
      _image = image;
      List<int> imageBytes = image.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
    });
  }

  _imgFromGallery() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 70);

    setState(() {
      _image = image;
      List<int> imageBytes = image.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
    });
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        name = user['username'];
        token = localStorage.getString('token');
      });
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Image.file(
            snapshot.data,
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.height * 0.1,
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 27.0, left: 19.0, right: 18.0),
            child: img != null
                ? Image.network(
                    "http://nvuti.uz/" + img,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                  )
                : Image.asset(
                    'images/choose.png',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
          );
        }
      },
    );
  }

  void postdata() async {
    var data;
    if (_image != null) {
      String fileName = _image.path.split('/').last;
      newImg = 'images/' + fileName;
      data = {
        'img': fileName,
        'file': base64Image,
        'desc': desc.text,
        'tag': tags.text,
      };
    } else {
      newImg = img;
      data = {
        'img': img,
        'desc': desc.text,
        'tag': tags.text,
      };
    }

    var res = await API().put(data, 'reports/' + (widget.id).toString());
    if (res == null) {
      setState(() {
        isLoading = false;
      });
      _showMsg("The connection has timed out, Please try again!");
    } else {
      var body = json.decode(res.body);
      if (body['success']) {
        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
        });
        _showMsg(body['message']);
      }
      setState(() {
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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 17.0,
                  ),
                  Text("Загрузите для создания отчета"),
                  SizedBox(
                    height: 17.0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.75,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage('images/un.png'),
                        fit: BoxFit.fill,
                        scale: 1.0,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Container(
                            child: _image != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: Image.file(
                                      _image,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Column(
                                    children: <Widget>[
                                      showImage(),
                                    ],
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 35.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 19, right: 18),
                          child: TextFormField(
                            maxLines: 3,
                            controller: desc,
                            decoration: new InputDecoration(
                                contentPadding: EdgeInsets.all(7),
                                hintText: 'Description',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0))),
                          ),
                        ),
                        SizedBox(
                          height: 29.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 19, right: 18),
                          child: TextFormField(
                            controller: tags,
                            decoration: new InputDecoration(
                                contentPadding: EdgeInsets.all(7),
                                hintText: 'Tags',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0))),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 19.0, right: 18.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
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
                          child: OutlineButton(
                            onPressed: () {
                              postdata();
                            },
                            child: Text(
                              "Сохранит",
                              style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
