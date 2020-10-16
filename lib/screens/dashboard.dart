import 'package:flutter/material.dart';
import 'package:fluttersafekey/screens/live_position.dart';
import 'package:fluttersafekey/utilities/constants.dart';

import 'dashboardmaintest.dart';

String _imeiNo = "";

class Dashboard extends StatefulWidget {
  Dashboard({this.imeiNo});
  final imeiNo;

  @override
  State<StatefulWidget> createState() {
    _imeiNo = imeiNo;
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  int _cIndex = 0;

  final List<Widget> _children = [
    DashboardMainTest(imeiNo: _imeiNo),
    LivePosition(imeiNo: _imeiNo),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: _children[_cIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF960018),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.menu, color: Color(0xFFFFFFFF)),
                title: Text(
                  'Home',
                  style: kMessageTextStyle,
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.my_location, color: Color(0xFFFFFFFF)),
                title: Text('Location', style: kMessageTextStyle)),
          ],
          currentIndex: _cIndex,
          onTap: onTabTapped,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.white,
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _cIndex = index;
    });
  }
}
