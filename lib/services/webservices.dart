import 'package:fluttersafekey/model/user_request.dart';

import 'networking.dart';

const baseURL = 'http://safekey.esanindia.com/api/mac/';
const serverURL = 'http://safekeyphp.esanindia.com/';
const socketUrl = "http://smartkey.trackagps.com:8888";

class Webservices {
  var imeiUrl = baseURL + 'IMEICheck';

  Future<dynamic> verifyIMEI(String imeiNum) async {
    NetworkHelper networkHelper = NetworkHelper('$imeiUrl?IMEI=$imeiNum');
    var imeiData = await networkHelper.getDataFromPostUrl();
    return imeiData;
  }

  Future<dynamic> registerDeviceCall(UserRequest user) async {
    var mobileNo = user.mobileNo;
    var mobileBrand = user.mobileBrand;
    var macaddress = user.macAddress;
    var imei = user.imeiNumber;
    var customerName = user.customerName;
    var emailId = user.emailId;
    var vehicleNo = user.vehicleNum;
    var vehicleModel = user.vehicleModel;

    var registerUrl = baseURL +
        'Register?MobileNo=$mobileNo&MobileBrand=$mobileBrand&Mac=$macaddress&IMEI=$imei&CustomerName=$customerName&EmailId=$emailId&VehicleNo=$vehicleNo&VehicleModel=$vehicleModel';
    NetworkHelper networkHelper = NetworkHelper(registerUrl);
    var response = await networkHelper.getDataFromPostUrl();

    return response;
  }

  Future<dynamic> lockOrUnLockVehicle(String imeiNo) async {
    var lockUnlockUrl = baseURL + 'UpdateAccsts?IMEI=$imeiNo';
    NetworkHelper networkHelper = NetworkHelper(lockUnlockUrl);
    var response = await networkHelper.getDataFromPostUrl();
    return response;
  }

  Future<dynamic> getLivePosition(String imeiNo) async {
    var livePosUrl = baseURL + 'LivePosition?IMEI=$imeiNo';
    NetworkHelper networkHelper = NetworkHelper(livePosUrl);
    var response = await networkHelper.getDataFromPostUrl();
    return response;
  }

  Future<dynamic> getVehicleDetails(String imeiNo) async {
    var vehPosUrl = baseURL + 'VehicleDetails?imei=$imeiNo';
    NetworkHelper networkHelper = NetworkHelper(vehPosUrl);
    var response = await networkHelper.getDataFromPostUrl();
    return response;
  }

  Future<dynamic> getLivePositionTrack(String imeiNo) async {
    var livePosUrl = serverURL + 'getliveposition.php?imei=$imeiNo';
    NetworkHelper networkHelper = NetworkHelper(livePosUrl);
    var response = await networkHelper.getDataFromPostUrl();
    return response;
  }

  Future<dynamic> getOTP(String mobileNumber) async {
    var otpUrl = baseURL + 'MobileNumber?MobileNo=$mobileNumber';
    NetworkHelper networkHelper = NetworkHelper(otpUrl);
    var response = await networkHelper.getDataFromPostUrl();
    return response;
  }

  Future<dynamic> verifyOTP(String mobileNumber, String otp) async {
    var otpUrl = baseURL + 'OTPVerification?MobileNo=$mobileNumber&OTP=$otp';
    NetworkHelper networkHelper = NetworkHelper(otpUrl);
    var response = await networkHelper.getDataFromPostUrl();
    return response;
  }

  Future<dynamic> upDateMacAddress(
      String mobileNumber, String mac, String mobileBrand) async {
    var url = baseURL +
        'UpdatMac?MobileNo=$mobileNumber&Mac=$mac&MobileBrand=$mobileBrand';
    NetworkHelper networkHelper = NetworkHelper(url);
    var response = await networkHelper.getDataFromPostUrl();
    return response;
  }

  Future<dynamic> getVehicleCount(String mobileNumber) async {
    var url = baseURL + 'VehicleCount?MobileNo=$mobileNumber';
    NetworkHelper networkHelper = NetworkHelper(url);
    var response = await networkHelper.getDataFromPostUrl();
    return response;
  }

  Future<dynamic> getAlarm(String mobileNumber) async {
    var url = baseURL + 'Alarms?MobileNo=$mobileNumber';
    NetworkHelper networkHelper = NetworkHelper(url);
    var response = await networkHelper.getDataFromPostUrl();
    return response;
  }

  Future<dynamic> getOverSpeedDetails(String imeiNum) async {
    var url = serverURL + 'getvehiclespeed.php?imei=$imeiNum';
    NetworkHelper networkHelper = NetworkHelper(url);
    var response = await networkHelper.getData();
    return response;
  }

  Future<dynamic> checkMACAddress(String macaddress) async {
    var url = baseURL + 'MacAddress?MacAddress=$macaddress';
    NetworkHelper networkHelper = NetworkHelper(url);
    var response = await networkHelper.getDataFromPostUrl();
    return response;
  }

  // Globalvariables.apiserverUrl+"MacAddress?MacAddress="+macaddress;
}
