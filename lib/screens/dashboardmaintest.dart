//https://blog.kuzzle.io/communicate-through-ble-using-flutter
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:alice/alice.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttersafekey/services/webservices.dart';
import 'package:fluttersafekey/utilities/alice_util.dart';
import 'package:fluttersafekey/utilities/constants.dart';
import 'package:fluttersafekey/utilities/flutter_speedometer.dart';
import 'package:rxdart/rxdart.dart';

import 'live_position.dart';

enum ConfirmAction { NO, YES }
String mobileNo = "";
void backgroundFetchHeadlessTask(String taskId) async {
  print("[BackgroundFetch] Headless event received: $taskId");
  var reponse = await Webservices().getAlarm(mobileNo);
  String alarmtype = reponse[0]['cAlarmType'];
  String cIMEI = reponse[0]['cIMEI'];
  String cVehicleNo = reponse[0]['cVehicleNo'];
  String nAccsts = reponse[0]['nAccsts'];
  String nBikeonoffsts = reponse[0]['nBikeonoffsts'];
  if (alarmtype == 'AccOn' || alarmtype == 'powerCut') {
    AssetsAudioPlayer.playAndForget(Audio("audios/accalarmsound.wav"));

    /* AssetsAudioPlayer.newPlayer().open(
      Audio("audios/accalarmsound.wav"),
      autoStart: true,
      showNotification: true,
      playInBackground: PlayInBackground.enabled,
    );*/
  }

  // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
  // for taking too long in the background.
  BackgroundFetch.finish(taskId);
}

class DashboardMainTest extends StatefulWidget {
  DashboardMainTest({this.imeiNo, this.mobNo});
  final imeiNo;
  final mobNo;
  @override
  State<StatefulWidget> createState() {
    mobileNo = mobNo;
    alice = Alice(
        showNotification: true, showInspectorOnShake: true, darkTheme: false);
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    return _DashboardMainTest();
  }
}

class _DashboardMainTest extends State<DashboardMainTest> {
  List<String> recipents = ['7026989856'];
  double _lowerValue = 0.0;
  double _upperValue = 70.0;
  int start = 0;
  int end = 180;
  int newValue = 5;
  int counter = 0;
  double wVal = 0;
  PublishSubject<int> eventObservable = new PublishSubject();
  Webservices webservices = Webservices();
  String LOCK = 'LOCK';
  String VEH_OFF_ON_STATUS = 'VEH.OFF';
  String vehName = "";
  String regNo = "";
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  // Track the Bluetooth connection with the remote device
  BluetoothConnection connection;

  int _deviceState;

  bool isDisconnecting = false;

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool isBtoothconnected = false;
  bool isInternetconnected = true;
  bool isCroneJobStarted = false;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
    _configureBackGroundFetch();
    _checkForInternet();
    _checkBlueTooth();
    const oneSec = const Duration(milliseconds: 500);
    getVehicleData();
    var rng = new Random();
    new Timer.periodic(
        oneSec,
        (Timer t) => {
              newValue = newValue + 2,
              if (newValue > 90) {newValue = newValue - 20},
              eventObservable.add(newValue),
            });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
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
      navigatorKey: alice.getNavigatorKey(),
      home: Scaffold(
        key: _scaffoldKey,
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
                              vehName,
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
                              regNo,
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
                      currentValue: newValue,
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
                      eventObservable: eventObservable,
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                        isInternetconnected
                            ? Icon(
                                Icons.wifi,
                                color: Colors.green,
                                size: 30.0,
                              )
                            : Icon(
                                Icons.signal_wifi_off,
                                color: Colors.grey,
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
                            child: Center(
                                child:
                                    Text(isInternetconnected ? 'ON' : 'OFF')),
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
                        isBtoothconnected
                            ? Icon(
                                Icons.bluetooth,
                                //Icons.bluetooth,
                                color: Colors.blue,
                                size: 30.0,
                              )
                            : Icon(
                                Icons.bluetooth_disabled,
                                //Icons.bluetooth,
                                color: Colors.white,
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
                            child: Center(
                                child: Text(isBtoothconnected ? 'ON' : 'OFF')),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      height: 40,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(1.0),
                          ),
                        ),
                        onPressed: () {
                          _lockOrUnLockData();
                        },
                        textColor: Colors.white,
                        color: Colors.yellow[600],
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                color: Colors.yellow[600],
                                padding: EdgeInsets.fromLTRB(2, 4, 4, 4),
                                child: Text(
                                  LOCK,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                      height: 40,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(1.0),
                          ),
                        ),
                        onPressed: () async {
                          var status =
                              VEH_OFF_ON_STATUS == 'VEH.OFF' ? 'OFF' : 'ON';
                          var confirmation =
                              await _asyncConfirmDialog(context, status);
                          if (confirmation == ConfirmAction.YES) {
                            _sendSMS();
                          }
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
                                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  VEH_OFF_ON_STATUS,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Icon(
                                  Icons.power_settings_new,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(1.0),
                          ),
                        ),
                        onPressed: () {
                          navigationPage();
                        },
                        textColor: Colors.white,
                        color: Colors.blueGrey,
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                color: Colors.blueGrey,
                                padding: EdgeInsets.fromLTRB(2, 4, 4, 4),
                                child: Text(
                                  'TRACK',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                child: Icon(
                                  Icons.gps_fixed,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _lockOrUnLockData() async {
    if (isInternetconnected) {
      dynamic response = await webservices.lockOrUnLockVehicle(widget.imeiNo);
      //dynamic response = await webservices.lockOrUnLockVehicle('868996035385764');868996035384551-latest
      setState(() {
        LOCK = response[0]['nAccsts'].toString() == "0" ? "LOCK" : "UNLOCK";
        if (LOCK == "UNLOCK") {
          BackgroundFetch.start().then((int status) {
            print('[BackgroundFetch] start success: $status');
          }).catchError((e) {
            print('[BackgroundFetch] start FAILURE: $e');
          });
        } else {
          BackgroundFetch.stop().then((int status) {
            print('[BackgroundFetch] stop success: $status');
          });
        }
      });
    } else {
      show('Please check your internet connection!');
    }
  }

  Future<ConfirmAction> _asyncConfirmDialog(
      BuildContext context, String status) async {
    return await showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vehicle ?'),
          content: Text('Are you sure want to $status the vehicle '),
          actions: <Widget>[
            FlatButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.NO);
              },
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.YES);
              },
            )
          ],
        );
      },
    );
  }

  void _sendSMS() async {
    String message = '';
    if (VEH_OFF_ON_STATUS == 'VEH.OFF') {
      message = '#FUEL#323232#OFF#';
    } else {
      message = '#FUEL#323232#ON#';
    }
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    if (VEH_OFF_ON_STATUS == 'VEH.OFF')
      setState(() {
        VEH_OFF_ON_STATUS = 'VEH.ON';
      });
    else if (VEH_OFF_ON_STATUS == 'VEH.ON')
      setState(() {
        VEH_OFF_ON_STATUS = 'VEH.OFF';
      });
    print('sms_result$_result');
  }

  void getVehicleData() async {
    if (isInternetconnected) {
      var vehicleData = await Webservices().getVehicleDetails(widget.imeiNo);
      updateUI(vehicleData);
    } else {
      show('Please check your internet connection!');
    }
  }

  void updateUI(dynamic data) {
    setState(() {
      regNo = data[0]['VehicleNo'].toString();
      vehName = data[0]['VehicleModel'].toString();
      LOCK = data[0]['nAccsts'].toString() == '0' ? 'LOCK' : 'UNLOCK';
      VEH_OFF_ON_STATUS =
          data[0]['nBikeonoffsts'].toString() == '0' ? 'VEH.OFF' : 'VEH.ON';
    });
  }

  void _onBackgroundFetch(String taskId) async {
    print("[BackgroundFetch] event received: $taskId");
    var reponse = await Webservices().getAlarm(widget.mobNo);
    String alarmtype = reponse[0]['cAlarmType'];
    String cIMEI = reponse[0]['cIMEI'];
    String cVehicleNo = reponse[0]['cVehicleNo'];
    String nAccsts = reponse[0]['nAccsts'];
    String nBikeonoffsts = reponse[0]['nBikeonoffsts'];
    setState(() {
      LOCK = nAccsts == '0' ? 'LOCK' : 'UNLOCK';
      VEH_OFF_ON_STATUS = nBikeonoffsts == '0' ? 'VEH.OFF' : 'VEH.ON';
    });
    if (alarmtype == 'AccOn' || alarmtype == 'powerCut') {
      AssetsAudioPlayer.newPlayer().open(
        Audio("audios/accalarmsound.wav"),
        autoStart: true,
        showNotification: true,
      );
    }

    // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
    // for taking too long in the background.
    BackgroundFetch.finish(taskId);
  }

  void navigationPage() {
    if (isInternetconnected) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LivePosition(imeiNo: widget.imeiNo);
      }));
    } else {
      show('Please check your internet connection!');
    }
  }

  void _configureBackGroundFetch() {
    BackgroundFetch.configure(
            BackgroundFetchConfig(
              minimumFetchInterval: 15,
              forceAlarmManager: false,
              stopOnTerminate: false,
              startOnBoot: true,
              enableHeadless: true,
              requiresBatteryNotLow: false,
              requiresCharging: false,
              requiresStorageNotLow: false,
              requiresDeviceIdle: false,
              requiredNetworkType: NetworkType.NONE,
            ),
            _onBackgroundFetch)
        .then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });
  }

  void _checkBlueTooth() {
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          print('state off');
        }
        getPairedDevices();
      });
    });
  }

  void _checkForInternet() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Request Bluetooth permission from the user
  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
      devices.forEach((device) {
        if (device.name.contains('WONDERLOOP')) {
          _device = device;
          _connect();
          return;
        }
        //
      });
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }
  }

  // Method to connect to bluetooth
  void _connect() async {
    if (!isConnected) {
      await BluetoothConnection.toAddress(_device.address).then((_connection) {
        print('Connected to the device');
        connection = _connection;
        setState(() {
          isBtoothconnected = true;
        });

        connection.input.listen(null).onDone(() {
          if (isDisconnecting) {
            print('Disconnecting locally!');
          } else {
            print('Disconnected remotely!');
            setState(() {
              isBtoothconnected = false;
              if (!isCroneJobStarted) {
                var cron = new Cron();
                cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
                  // print('every three minutes');
                  _connect();
                });
                isCroneJobStarted = true;
              }
            });
          }
          if (this.mounted) {
            setState(() {
              print('Mounted');
            });
          }
        });
      }).catchError((error) {
        print('Cannot connect, exception occurred');
        print(error);
      });
      // show('Device connected');

    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        String wifiName, wifiBSSID, wifiIP;

        try {
          if (!kIsWeb && Platform.isIOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiName = await _connectivity.getWifiName();
            } else {
              wifiName = await _connectivity.getWifiName();
            }
          } else {
            wifiName = await _connectivity.getWifiName();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiName = "Failed to get Wifi Name";
        }

        try {
          if (!kIsWeb && Platform.isIOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiBSSID = await _connectivity.getWifiBSSID();
            } else {
              wifiBSSID = await _connectivity.getWifiBSSID();
            }
          } else {
            wifiBSSID = await _connectivity.getWifiBSSID();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiBSSID = "Failed to get Wifi BSSID";
        }

        try {
          wifiIP = await _connectivity.getWifiIP();
        } on PlatformException catch (e) {
          print(e.toString());
          setState(() {
            isInternetconnected = false;
          });
          wifiIP = "Failed to get Wifi IP";
        }

        setState(() {
          isInternetconnected = true;
          _connectionStatus = '$result\n'
              'Wifi Name: $wifiName\n'
              'Wifi BSSID: $wifiBSSID\n'
              'Wifi IP: $wifiIP\n';
        });
        break;
      case ConnectivityResult.none:
        setState(() {
          isInternetconnected = false;
          _connectionStatus = result.toString();
        });
        break;
      case ConnectivityResult.mobile:
        setState(() {
          isInternetconnected = true;
          _connectionStatus = result.toString();
        });
        break;
      default:
        setState(() {
          isInternetconnected = false;
          _connectionStatus = 'Failed to get connectivity.';
        });
        break;
    }
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
