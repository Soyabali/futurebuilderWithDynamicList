import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/LeaveData.dart';


class HrmsreimbursementLogRepo {
  //List<dynamic> hrmsleavebalacev2List = [];
  var hrmsleavebalacev2List = [];
  Future<List<LeaveData>> hrmsReimbursementLog(BuildContext context) async
  {
    // print('---date----13---$dDate');
    //showLoader();
    int currentYear = DateTime.now().year;
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //String? sToken = prefs.getString('sToken');


    // var baseURL = BaseRepo().baseurl;
    // var endPoint = "hrmsReimbursementLog/hrmsReimbursementLog";
    var hrmsReimbursementLogApi = "https://upegov.in/hrmstestApis/api/hrmsLeaveBalanceV2/hrmsLeaveBalanceV2";
   // print('------------17---hrmsReimbursementLogApi---$hrmsReimbursementLogApi');

    // showLoader();

    try {
      var headers = {
        'token': '01F9B7AF-9516-4A42-97C9-BD6073FD8EF8',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$hrmsReimbursementLogApi'));
      request.body = json.encode({
        "dYTDMonth":"30/Sep/2024",
        "iLeaveYear":"2024",
        "sEmpCode":"7814104309"
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        // hideLoader();
        // Convert the response stream to a string
        String responseBody = await response.stream.bytesToString();

        // Decode the response body
        List jsonResponse = jsonDecode(responseBody);
        print('---46--$jsonResponse');
        // Return the list of LeaveData
        return jsonResponse.map((data) => LeaveData.fromJson(data)).toList();
        // var data = await response.stream.bytesToString();
        // print('---43---$data');
        // //print('--74---xxx---${jsonDecode(data)}');
        // // Map<String, dynamic> parsedJson = jsonDecode(data);
        // //distList = parsedJson['Data'];
        // // distList = jsonDecode(data);
        // hrmsleavebalacev2List = jsonDecode(data);
        // print('----49---$hrmsleavebalacev2List');
        // return hrmsleavebalacev2List;
      } else {
        // hideLoader();
        throw Exception('Failed to load leave data');
      }
    } catch (e) {
      // hideLoader();
      throw (e);
    }
  }
}