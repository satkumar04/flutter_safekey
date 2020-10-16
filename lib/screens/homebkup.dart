import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          Center(
            child: new Image.asset(
              'images/safekeylogo.png',
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
          Card(
            elevation: 10,
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              color: Colors.white10,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "DASH BOARD",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                      child: Column(
                    children: <Widget>[
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        leading: Icon(Icons.directions_car),
                        title: Text("Registration no"),
                        subtitle: Text("KA02 ME 1411"),
                      ),
                      ListTile(
                        leading: Icon(Icons.directions_car),
                        title: Text("Model"),
                        subtitle: Text("Hyundai"),
                      ),
                      ListTile(
                        leading: Icon(Icons.directions_car),
                        title: Text("Status"),
                        subtitle: Text("ON"),
                      ),
                      ListTile(
                        leading: Icon(Icons.directions_car),
                        title: Text("Condition"),
                        subtitle: Text("ON"),
                      ),
                      ListTile(
                        leading: Icon(Icons.directions_car),
                        title: Text("Bluetooth status"),
                        subtitle: Text("ON"),
                      ),
                      Divider(
                        color: Colors.black38,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0)),
                            color: Colors.red,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.white,
                            ),
                            label: Text(
                              "LOCK",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {},
                          ),
                          SizedBox(width: 20.0),
                          RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0)),
                            color: Colors.green,
                            icon: Icon(
                              FontAwesomeIcons.powerOff,
                              color: Colors.white,
                            ),
                            label: Text(
                              "VEH.OFF",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
