import 'package:alice/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersafekey/model/user_request.dart';
import 'package:fluttersafekey/services/webservices.dart';
import 'package:fluttersafekey/utilities/alice_util.dart';
import 'package:fluttersafekey/utilities/constants.dart';
import 'package:fluttersafekey/utilities/deviceutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_button/progress_button.dart';
import 'package:wifi_info_plugin/wifi_info_plugin.dart';

import 'dashboardmaintest.dart';
import 'otpage.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() {
    alice = Alice(
        showNotification: true, showInspectorOnShake: true, darkTheme: false);
    return new _RegistrationState();
  }
}

class _RegistrationState extends State<Registration> {
  final _imeiController = TextEditingController();
  final _mobileController = TextEditingController();
  final _vehicleNoController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _emailController = TextEditingController();
  Webservices webservices = Webservices();
  DeviceUtil deviceUtil;
  bool _isEnabled = false;
  bool _isOtpVerified = false;
  String _deviceId;
  Future<String> macAddress;
  WifiInfoWrapper _wifiObject;

  @override
  Future<void> initState() {
    super.initState();
    // Start listening to changes.
    _imeiController.addListener(_checkIMEIIfInputIsValid);
    initPlatformState();
    deviceUtil = DeviceUtil(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: alice.getNavigatorKey(),
      home: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: CustomSliverDelegate(
                  expandedHeight: 105,
                ),
              ),
              SliverFillRemaining(
                child: SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Registration',
                          style: kRegistrationTextStyle,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          maxLength: 15,
                          autofocus: false,
                          obscureText: false,
                          controller: _imeiController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "IMEI",
                              hintText: "IMEI",
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.green,
                                      style: BorderStyle.solid))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          enabled: true,
                          autofocus: false,
                          obscureText: false,
                          keyboardType: TextInputType.phone,
                          controller: _mobileController,
                          decoration: InputDecoration(
                              labelText: "Mobile no",
                              hintText: "Mobile no",
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.green,
                                      style: BorderStyle.solid))),
                        ),
                        Visibility(
                          visible: !_isOtpVerified,
                          child: SizedBox(
                            height: 10,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 40.0),
                          child: Visibility(
                            visible: !_isOtpVerified,
                            child: new Container(
                              width: 150.0,
                              height: 40.0,
                              child: new RaisedButton(
                                  onPressed: () {
                                    _getOTP();
                                  },
                                  child: Text("Get OTP"),
                                  textColor: Colors.white,
                                  color: Color(0xFF960018),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _isOtpVerified,
                          child: TextField(
                            enabled: _isEnabled,
                            autofocus: false,
                            controller: _emailController,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: "Email",
                                hintText: "Email",
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.green,
                                        style: BorderStyle.solid))),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: _isOtpVerified,
                          child: TextField(
                            enabled: _isEnabled,
                            autofocus: false,
                            controller: _customerNameController,
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "Customer Name",
                                hintText: "Customer Name",
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.green,
                                        style: BorderStyle.solid))),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: _isOtpVerified,
                          child: TextField(
                            enabled: _isEnabled,
                            autofocus: false,
                            controller: _vehicleNoController,
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "Vehicle no",
                                hintText: "Vehicle no",
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.green,
                                        style: BorderStyle.solid))),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: _isOtpVerified,
                          child: TextField(
                            enabled: _isEnabled,
                            autofocus: false,
                            obscureText: false,
                            controller: _vehicleTypeController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "Vehicle type",
                                hintText: "Vehicle type",
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.green,
                                        style: BorderStyle.solid))),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Visibility(
                          visible: _isOtpVerified,
                          child: ProgressButton(
                            child: Text(
                              'REGISTER',
                              style: kButtonTextStyle,
                            ),
                            backgroundColor: Color(0xFF960018),
                            progressColor: Theme.of(context).primaryColor,
                            onPressed: _isEnabled
                                ? () {
                                    callRegisterApi();
                                  }
                                : () {
                                    showToastMsg(
                                        'Please enter a valid IMEI number.');
                                  },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: _isOtpVerified,
                          child: new FlatButton(
                            onPressed: () {
                              navigationPage();
                            },
                            child: new Text("Skip Registration"),
                          ),
                        ),
                      ]),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigationPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DashboardMainTest(imeiNo: _imeiController?.text);
    }));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    WifiInfoWrapper wifiObject;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      wifiObject = await WifiInfoPlugin.wifiDetails;
      print(wifiObject.macAddress);
    } on PlatformException {}
    if (!mounted) return;
    _wifiObject = wifiObject;
  }

  void callRegisterApi() async {
    var mobNo = _mobileController?.text ?? "";
    var vehType = _vehicleTypeController?.text ?? "";
    var vehNo = _vehicleNoController?.text ?? "";
    var imeiNo = _imeiController?.text ?? "";
    var macAddress = _wifiObject.macAddress;
    var custName = _customerNameController?.text ?? "Test Name";
    var email = _emailController?.text ?? "test@email.com";
    UserRequest userRequest = UserRequest(mobNo, "Mobile Brand", macAddress,
        imeiNo, custName, email, vehNo, vehType);
    var response = await webservices?.registerDeviceCall(userRequest);
    if (response[0]['Status'] == 'False') {
      showToastMsg('Registration failed!');
    } else if (response[0]['Status'] == 'True') {
      navigationPage();
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _imeiController.dispose();
    _vehicleTypeController.dispose();
    _vehicleNoController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  _checkIMEIIfInputIsValid() async {
    if (_imeiController.text != null && _imeiController.text.length == 15) {
      var data = await webservices.verifyIMEI(_imeiController.text);
      if (data[0]['Status'] == 'False') {
        showToastMsg('Invalid IMEI');
      } else if (data[0]['Status'] == 'True') {
        enableOrDisableWidget(true);
      }

      _deviceId = await deviceUtil.getId();
      print(_deviceId);
    }
  }

  void enableOrDisableWidget(bool isEnabled) {
    setState(() {
      _isEnabled = isEnabled;
    });
  }

  showToastMsg(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // A method that launches the SelectionScreen and awaits the
  // result from Navigator.pop.
  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
          builder: (context) => OtpPage(mobNumber: _mobileController.text)),
    );
    if (result == SUCCESS) {
      setState(() {
        _isOtpVerified = true;
      });
    }
  }

  void _getOTP() async {
    //  if (_mobileController.text != null && _mobileController.text.length == 10) {
    var otpStatus = await Webservices().getOTP('9886070052');
    if (otpStatus[0]['Status'] == 'False') {
      // showToastMsg('Mobile number is not valid!');
      _navigateAndDisplaySelection(context);
    } else if (otpStatus[0]['Status'] == 'True') {
      //enableOrDisableWidget(true);
      _navigateAndDisplaySelection(context);
    }
    //}
  }
}

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;

  CustomSliverDelegate({
    @required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - shrinkOffset;
    final cardTopPosition = expandedHeight / 4 - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    return SizedBox(
      height: expandedHeight + expandedHeight / 2,
      child: Stack(
        children: [
          SizedBox(
            height: appBarSize < kToolbarHeight ? kToolbarHeight : appBarSize,
            child: AppBar(
              backgroundColor: Color(0xFF960018),
              leading: Container(),
              elevation: 0.0,
              title: Opacity(
                  opacity: hideTitleWhenExpanded ? 1.0 - percent : 1.0,
                  child: Text("")),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: cardTopPosition > 0 ? cardTopPosition : 0,
            bottom: 0.0,
            child: Opacity(
              opacity: percent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40 * percent),
                child: Card(
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xFF960018)),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  elevation: 10.0,
                  child: Center(
                    child: new Image.asset(
                      'images/safekeylogo.png',
                      height: 55.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + expandedHeight / 2;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
