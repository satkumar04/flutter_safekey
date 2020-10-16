import 'dart:async';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersafekey/screens/registration.dart';
import 'package:fluttersafekey/services/webservices.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:wifi_info_plugin/wifi_info_plugin.dart';

import 'dashboardmaintest.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Webservices webservices = Webservices();
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isInternetOn = true;
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, initPlatformState);
  }

  void navigationPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Registration();
    }));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: isInternetOn
            ? new Center(
                child: Card(
                  elevation: 10.0,
                  child: Center(
                    child: new Image.asset(
                      'images/esanimage.png',
                      height: 55.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            : FullScreenWidget(
                child: new Image.asset(
                  "images/no_inter_new.gif",
                  fit: BoxFit.scaleDown,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
              ));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    WifiInfoWrapper wifiObject;
    GetConnect();
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      wifiObject = await WifiInfoPlugin.wifiDetails;
      print(wifiObject.macAddress);
      callCheckMacApi(wifiObject.macAddress);
    } on PlatformException {}
    if (!mounted) return;
  }

  void GetConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    }
  }

  void callCheckMacApi(String macAddress) async {
    if (isInternetOn) {
      var response = await webservices.checkMACAddress(macAddress);
      if (response[0]['Status'] == 'False') {
        navigationPage();
      } else if (response[0]['Status'] == 'True') {
        var mobileNo = response[0]['MobileNo'];
        callVehicleCountApi(mobileNo);
      }
    } else {
      show('Please check your internet connection!');
    }
  }

  void callVehicleCountApi(String mobileNumber) async {
    if (isInternetOn) {
      var response = await webservices.getVehicleCount(mobileNumber);
      if (response != null) {
        var imeiNo = response[0]['IMEI'];
        navigationToDashBoard(imeiNo, mobileNumber);
      } else
        navigationPage();
    } else {
      show('Please check your internet connection!');
    }
  }

  void navigationToDashBoard(String imEi, String mobileNo) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return DashboardMainTest(
        imeiNo: imEi,
        mobNo: mobileNo,
      );
    }));
  }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
