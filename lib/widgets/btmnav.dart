import 'package:flutter/material.dart';

class BottomNavWidget extends StatefulWidget {
  @override
  createState() => new BottomNavWidgetState();
}

class BottomNavWidgetState extends State<BottomNavWidget> {
  int _index = 0;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 12.0,
      onTap: (_index) {
        setState(() {
          this._index = _index;
        });
        switch (_index) {
          case 0:
            // Navigator.popAndPushNamed(context, '/home');
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
            // Navigator.pushReplacementNamed(context, '/home');
            break;
          case 2:
            Navigator.pushNamed(context, '/create');
            break;
          case 3:
            Navigator.pushNamed(context, '/img');
            break;
        }
      },
      currentIndex: _index,
      iconSize: 40.0,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'images/home.png',
            width: 28.0,
            height: 28.0,
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'images/bell.png',
            width: 28.0,
            height: 28.0,
          ),
          label: "Notifications",
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'images/add.png',
            width: 44.0,
            height: 44.0,
          ),
          label: "Add",
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'images/compass.png',
            width: 28.0,
            height: 28.0,
          ),
          label: "Compass",
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'images/user.png',
            width: 28.0,
            height: 28.0,
          ),
          label: "User",
        )
      ],
    );
  }
}
