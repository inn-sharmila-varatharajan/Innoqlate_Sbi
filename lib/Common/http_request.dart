import 'dart:convert';


import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:innlite_mobile/Common/api_url.dart';
import 'package:innlite_mobile/Common/common_dart.dart';

import 'package:shared_preferences/shared_preferences.dart';
SharedPreferences prefs;
final common = Common();
class  HttpRequest  {

  Future<bool> getsharedprefence() async{
    prefs= await SharedPreferences.getInstance();
    return  false;
  }

  void fetchData() async {
    String url = Glob().getLoginUrl();
    final http.Request request = http.Request('POST', Uri.parse(url));
    final http.StreamedResponse response = await http.Client().send(request);
    final int statusCode = response.statusCode;
    final String responseData = await response.stream.transform(utf8.decoder).join();

  }

  Future getdata(String Url,String token,BuildContext context) async{
    bool isonline;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      isonline= true;
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isonline=true;
      // I am connected to a wifi network.
    } else if(connectivityResult == ConnectivityResult.none){
      isonline=false;
    }
    if(isonline==false){
      common.showAlert(context, 'Please check internet connection');
    }
    else {
      final response = await http.get(
        Uri.parse(Url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        return jsonDecode(response.body);
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        throw Exception('Failed to create album.');
      }
    }
  }

  Future putdata(String Url,Map<String, String> body,String token) async{
    if(prefs==null)getsharedprefence();
    final response = await http.put(
        Uri.parse(Url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body)
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }

  }

  Future postdata(String Url,Map<String, dynamic> body,String token) async{
    if(prefs==null)getsharedprefence();
    final response = await http.post(
      Uri.parse(Url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body)
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
     return jsonDecode(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }

  }
  void showAlert(BuildContext context, String bodytext) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
                content: Text(bodytext),
                actions: [
                  ElevatedButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  )
                ]
            ));
  }
}