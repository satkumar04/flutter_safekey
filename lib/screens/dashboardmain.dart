import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttersafekey/utilities/constants.dart';
import 'package:fluttersafekey/utilities/flutter_speedometer.dart';
import 'package:rxdart/rxdart.dart';

class DashboardMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardMain();
  }
}

class _DashboardMain extends State<DashboardMain> {
  double _lowerValue = 0.0;
  double _upperValue = 70.0;
  int start = 0;
  int end = 180;

  int counter = 0;
  double wVal = 0;
  PublishSubject<double> eventObservable = new PublishSubject();
  @override
  // ignore: must_call_super
  void initState() {
    const oneSec = const Duration(seconds: 1);
    var rng = new Random();
    new Timer.periodic(oneSec,
        (Timer t) => eventObservable.add(rng.nextInt(59) + rng.nextDouble()));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData somTheme = new ThemeData(
      primaryColor: Colors.green,
      accentColor: Colors.white70,
      backgroundColor: Colors.grey,
      textSelectionColor: Colors.white,
    );
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              "VEHICLE",
                              style: kCommonTextStyle,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "DUSTER",
                              style: kCommonTextStyle_16,
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "REG.NO",
                              style: kCommonTextStyle,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "KA-02ME1411",
                              style: kCommonTextStyle_16,
                            ),
                          ],
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 250,
                    child: Speedometer(
                      size: 250,
                      minValue: 0,
                      maxValue: 180,
                      currentValue: 100,
                      warningValue: 90,
                      backgroundColor: Colors.blueGrey[900],
                      meterColor: Colors.green,
                      warningColor: Colors.orange,
                      kimColor: Colors.white,
                      displayNumericStyle: TextStyle(
                          fontFamily: 'Digital-Display',
                          color: Colors.white,
                          fontSize: 40),
                      displayText: 'km/h',
                      displayTextStyle:
                          TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "IGNITION",
                            style: kCommonTextStyle_12,
                          ),
                        ),
                        Icon(
                          Icons.power_settings_new,
                          color: Colors.yellowAccent,
                          size: 30.0,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            width: 50,
                            height: 25,
                            child: Center(child: Text("ON")),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "INTERNET",
                            style: kCommonTextStyle_12,
                          ),
                        ),
                        Icon(
                          Icons.wifi,
                          color: Colors.green,
                          size: 30.0,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            width: 50,
                            height: 25,
                            child: Center(child: Text("ON")),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "B-TOOTH",
                            style: kCommonTextStyle_12,
                          ),
                        ),
                        Icon(
                          Icons.bluetooth,
                          color: Colors.blue,
                          size: 30.0,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            width: 50,
                            height: 25,
                            child: Center(child: Text("ON")),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(1.0),
                          ),
                        ),
                        onPressed: () {
                          print('Button Clicked.');
                        },
                        textColor: Colors.white,
                        color: Colors.yellow[600],
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                color: Colors.yellow[600],
                                padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
                                child: Text(
                                  'LOCK',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 0),
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Container(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(1.0),
                          ),
                        ),
                        onPressed: () {
                          print('Button Clicked.');
                        },
                        textColor: Colors.white,
                        color: Colors.red[800],
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                color: Colors.red[800],
                                padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
                                child: Text(
                                  'LOCK',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 0),
                                child: Icon(
                                  Icons.power_settings_new,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
