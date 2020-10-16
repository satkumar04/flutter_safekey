library flutter_speedometer;

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttersafekey/utilities/painter.dart';
import 'package:rxdart/rxdart.dart';

class Speedometer extends StatefulWidget {
  double size;
  int minValue;
  int maxValue;
  int currentValue;
  int warningValue;
  Color backgroundColor;
  Color meterColor;
  Color warningColor;
  Color kimColor;
  TextStyle displayNumericStyle;
  String displayText;
  TextStyle displayTextStyle;
  PublishSubject<int> eventObservable;
  Speedometer({
    this.size,
    this.minValue,
    this.maxValue,
    this.currentValue,
    this.warningValue,
    this.backgroundColor,
    this.meterColor,
    this.warningColor,
    this.kimColor,
    this.displayNumericStyle,
    this.displayText,
    this.displayTextStyle,
    this.eventObservable,
  }) {}

  @override
  _SpeedometerState createState() => _SpeedometerState(
      this.size,
      this.minValue,
      this.maxValue,
      this.currentValue,
      this.warningValue,
      this.backgroundColor,
      this.meterColor,
      this.warningColor,
      this.kimColor,
      this.displayNumericStyle,
      this.displayText,
      this.displayTextStyle,
      this.eventObservable);
}

class _SpeedometerState extends State<Speedometer>
    with TickerProviderStateMixin {
  double size;
  int minValue;
  int maxValue;
  int currentValue;
  int warningValue;
  Color backgroundColor;
  Color meterColor;
  Color warningColor;
  Color kimColor;
  TextStyle displayNumericStyle;
  String displayText;
  TextStyle displayTextStyle;
  PublishSubject<int> eventObservable;
  StreamSubscription<int> subscription;
  double _currentValue = 0;
  double newVal;
  AnimationController percentageAnimationController;
  _SpeedometerState(
      double size,
      int minValue,
      int maxValue,
      int currentValue,
      int warningValue,
      Color backgroundColor,
      Color meterColor,
      Color warningColor,
      Color kimColor,
      TextStyle displayNumericStyle,
      String displayText,
      TextStyle displayTextStyle,
      PublishSubject<int> eventObservable) {
    this.size = size;
    this.minValue = minValue;
    this.maxValue = maxValue;
    this.currentValue = currentValue;
    this.warningValue = warningValue;
    this.backgroundColor = backgroundColor;
    this.warningColor = warningColor;
    this.meterColor = meterColor;
    this.kimColor = kimColor;
    this.displayNumericStyle = displayNumericStyle;
    this.displayText = displayText;
    this.displayTextStyle = displayTextStyle;
    this.eventObservable = eventObservable;

    percentageAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {
          _currentValue = lerpDouble(
                  _currentValue, newVal, percentageAnimationController.value)
              .truncateToDouble();
        });
      });
    reloadData(double value) {
      newVal = value;
      percentageAnimationController.forward(from: 0.0);
    }

    subscription = this.eventObservable.listen((value) {
      (value >= this.maxValue)
          ? reloadData(this.maxValue.toDouble())
          : reloadData(value.toDouble());
    }); //(value) => reloadData(value));
  }

  @override
  Widget build(BuildContext context) {
    double _size = widget.size;
    int _minValue = widget.minValue;
    int _maxValue = widget.maxValue;

    int _warningValue = widget.warningValue;
    double startAngle = 3.0;
    double endAngle = 21.0;
    double _kimAngle = 0;
    if (_minValue <= _currentValue && _currentValue <= _maxValue) {
      _kimAngle = (((_currentValue - _minValue) * (endAngle - startAngle)) /
              (_maxValue - _minValue)) +
          startAngle;
    } else if (_currentValue < _minValue) {
      _kimAngle = startAngle;
    } else if (_currentValue > _maxValue) {
      _kimAngle = endAngle;
    }

    double startAngle2 = 0.0;
    double endAngle2 = 18.0;
    double _warningAngle = endAngle2;
    if (_minValue <= _warningValue && _warningValue <= _maxValue) {
      _warningAngle =
          (((_warningValue - _minValue) * (endAngle2 - startAngle2)) /
                  (_maxValue - _minValue)) +
              startAngle2;
    }
    return Container(
      color: widget.backgroundColor,
      child: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            width: _size,
            height: _size,
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(_size * 0.075),
                  child: Stack(children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        width: _size,
                        height: _size,
                        decoration: new BoxDecoration(
                          color: widget.backgroundColor,
                          boxShadow: [
                            new BoxShadow(
                                color: widget.kimColor,
                                blurRadius: 8.0,
                                spreadRadius: 4.0)
                          ],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    CustomPaint(
                      size: Size(_size, _size),
                      painter: ArcPainter(
                          startAngle: 9,
                          sweepAngle: 18,
                          color: widget.warningColor),
                    ),
                    CustomPaint(
                      size: Size(_size, _size),
                      painter: ArcPainter(
                          startAngle: 9,
                          sweepAngle: _warningAngle,
                          color: widget.meterColor),
                    ),
                  ]),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                    clipper: TriangleClipper(),
                    child: Container(
                      width: _size,
                      height: _size * 0.5,
                      color: widget.backgroundColor,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: _size * 0.1,
                    height: _size * 0.1,
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      color: widget.kimColor,
                      boxShadow: [
                        new BoxShadow(
                            color: widget.meterColor,
                            blurRadius: 10.0,
                            spreadRadius: 5.0)
                      ],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Transform.rotate(
                    angle: math.pi / 12 * _kimAngle,
                    child: ClipPath(
                      clipper: KimClipper(),
                      child: Container(
                        width: _size * 0.9,
                        height: _size * 0.9,
                        color: widget.kimColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      widget.displayText,
                      style: widget.displayTextStyle,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, _size * 0.1),
                    child: Text(
                      _currentValue.toString(),
                      style: widget.displayNumericStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
