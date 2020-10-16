import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttersafekey/utilities/LoggingInterceptor.dart';
import 'package:fluttersafekey/utilities/alice_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

const errorMsg = 'Network call failed with Error code  ';

class NetworkHelper {
  NetworkHelper(this.url);

  Client client =
      HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);
  final String url;

  Future getData() async {
    http.Response response = await client.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      print("Success:$data");
      return jsonDecode(data);
    } else {
      print("Error:$response.statusCode.toString()");
      showToastMsg(errorMsg + response.statusCode.toString());
    }
  }

  Future getDataFromPostUrl() async {
    http.Response response = await client.post(url);
    if (alice != null) alice.onHttpResponse(response);
    if (response.statusCode == 200) {
      String data = response.body;
      print("Success:$data");
      return jsonDecode(data);
    } else {
      showToastMsg(response.statusCode.toString());
    }
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
}
