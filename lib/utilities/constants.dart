import 'package:flutter/material.dart';

const String SUCCESS = 'Success', FAIL = 'Fail';

const kRegistrationTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 25.0,
);

const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 20.0,
);

const kCommonTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  color: Colors.white,
  fontSize: 20.0,
);

const kCommonTextStyle_16 = TextStyle(
  fontFamily: 'Spartan MB',
  color: Colors.white,
  fontSize: 16.0,
);

const kCommonTextStyle_12 = TextStyle(
    fontFamily: 'Spartan MB',
    color: Colors.white,
    fontSize: 12.0,
    wordSpacing: 10);

const kBottomSheetTextStyle =
    TextStyle(fontFamily: 'Spartan MB', fontSize: 20.0, color: Colors.white);

const kSpeedTextStyle =
    TextStyle(fontFamily: 'Spartan MB', fontSize: 14.0, color: Colors.white);

const kButtonTextStyle =
    TextStyle(fontSize: 25.0, fontFamily: 'Spartan MB', color: Colors.white);

const kTextStyle =
    TextStyle(fontSize: 25.0, fontFamily: 'Spartan MB', color: Colors.black);

const kConditionTextStyle = TextStyle(
  fontSize: 100.0,
);

const kTextFieldInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  icon: Icon(
    Icons.location_city,
    color: Colors.white,
  ),
  hintText: 'Enter City Name',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide.none,
  ),
);
