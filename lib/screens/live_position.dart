/*https://medium.com/flutter-community/add-a-custom-info-window-to-your-google-map-pins-in-flutter-2e96fdca211a*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttersafekey/components/map_pin_pill.dart';
import 'package:fluttersafekey/model/pin_pill_info.dart';
import 'package:fluttersafekey/services/webservices.dart';
import 'package:fluttersafekey/utilities/constants.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLng _center = LatLng(13.0510, 77.5938);

class LivePosition extends StatefulWidget {
  LivePosition({this.imeiNo});

  final imeiNo;

  @override
  State<StatefulWidget> createState() {
    return _LivePosition();
  }
}

class _LivePosition extends State<LivePosition> {
  double pinPillPosition = 0;
  BitmapDescriptor sourceIcon;
  bool isDataAvailable = false;
  String speed = "";
  String vehicle = '';
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: "",
      avatarPath: "images/destination_map_marker.png",
      location: _center,
      locationName:
          'No 2c,Ashiayana Apartment, 9 th cross, kempapura,Hebbal Bangalore',
      labelColor: Colors.teal);
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  PinInformation livePinInfo;

  void _onMapCreated(GoogleMapController controller) {
    //controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
    //setMapPins();
  }

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
    getLiveData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0,
                tilt: 0,
                bearing: 30,
              ),
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Visibility(
                  visible: isDataAvailable,
                  child: Container(
                    margin: EdgeInsets.all(15),
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              blurRadius: 20,
                              offset: Offset.zero,
                              color: Colors.teal.withOpacity(0.5))
                        ]),
                    child: Center(
                      child: Text(
                        speed,
                        style: kSpeedTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Visibility(
                  visible: isDataAvailable,
                  child: Container(
                    margin: EdgeInsets.all(15),
                    width: 130,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              blurRadius: 20,
                              offset: Offset.zero,
                              color: Colors.teal.withOpacity(0.5))
                        ]),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        vehicle,
                        style: kSpeedTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isDataAvailable,
              child: MapPinPillComponent(
                  pinPillPosition: pinPillPosition,
                  currentlySelectedPin: currentlySelectedPin),
            )
          ],
        ),
      ),
    );
  }

  void setMapPins() {
    _markers.add(
      Marker(
          markerId: MarkerId('sourcePin'), position: _center, icon: sourceIcon),
    );
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/driving_pin.png');
  }

  void getLiveData() async {
    var vehicleData = await Webservices().getLivePositionTrack(widget.imeiNo);
    updateUI(vehicleData);
  }

  void updateUI(dynamic data) {
    String _latitude = "";
    String _longitude = "";
    String _vstatus = "";
    String _speed = "";
    String _degree = "";
    String _vehicleModel = "";
    String _vehicleno = "";
    if (data['success'].toString() == '1') {
      _latitude = data['items'][0]['Lattitude'].toString();
      _longitude = data['items'][0]['Longitude'].toString();
      _vstatus = data['items'][0]['vstatus'].toString();
      _speed = data['items'][0]['speed'].toString();
      _degree = data['items'][0]['ddegree'].toString();
      _vehicleModel = data['items'][0]['cVehicleModel'].toString();
      _vehicleno = data['items'][0]['cVehicleno'].toString();
      _center = LatLng(double.parse(_latitude), double.parse(_longitude));

      if (_vehicleModel == 'null' && _vehicleno == 'null')
        vehicle = 'KA 02 ME 1411';
      else
        vehicle = _vehicleModel + '  ' + _vehicleno;
      speed = _speed + ' km/h';
      _getLocation(double.parse(_latitude), double.parse(_longitude));
    }
  }

  _getLocation(double lat, double longitude) async {
    final coordinates = new Coordinates(lat, longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var address = addresses.first.addressLine;
    livePinInfo = PinInformation(
        pinPath: '',
        avatarPath: 'images/friend1.jpg',
        location: _center,
        locationName: address,
        labelColor: Colors.teal);
    currentlySelectedPin = livePinInfo;
    isDataAvailable = true;
    _goToLivePosition(lat, longitude);
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId('myLocation'),
            position: _center,
            icon: sourceIcon),
      );
    });
  }

  Future<void> _goToLivePosition(double lan, double longitude) async {
    final CameraPosition _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lan, longitude),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
