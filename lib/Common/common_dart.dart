import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:innlite_mobile/View/popup.dart';
import 'package:innlite_mobile/View/popup_content.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs ;
var key = "null";
String encryptedS,decryptedS;
var password = "null";
BuildContext dialogContext;
bool islogin;
class Common {
  Future<bool> getsharedprefence(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    islogin= prefs.getBool('isloggedin');
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
  String getage(String date){
    String totaldays="";
    int difference;
    date =date.replaceAll("T", " ");


    var inputFormat = DateFormat('MM/dd/yyyy HH:mm');
    var inputDate = inputFormat.parse(date);

    var parsedDate = DateTime.parse(inputDate.toString());
    final birthday = parsedDate;
    final date2 = DateTime.now();
    difference = date2.difference(birthday).inDays;
    if(difference>1){
      totaldays= difference.toString();
      totaldays= (totaldays + "d").toString();
    }
    else{
      difference = date2.difference(birthday).inHours;
      totaldays = difference.toString();
      totaldays= (totaldays+"H").toString();
    }
    return totaldays;
  }

  String getstandardage(String date){
    String totaldays="";
    int difference;
    List<String> ff= date.split("T");
    date =date[0];
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(ff[0]);
    var parsedDate = DateTime.parse(inputDate.toString());
    final birthday = parsedDate;
    final date2 = DateTime.now();
    difference = date2.difference(birthday).inDays;
    if(difference>1){
      totaldays= difference.toString();
      totaldays= (totaldays + "d").toString();
    }
    else{
      difference = date2.difference(birthday).inHours;
      totaldays = difference.toString();
      totaldays= (totaldays+"H").toString();
    }
    return totaldays;
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if( result.isNotEmpty && result[0].rawAddress.isNotEmpty){
        return true;
      };
    } on SocketException catch (_) {
      return false;
    }
  }


   Future navigateToSubPage(context, Page) async {
     Navigator.push(context, MaterialPageRoute(builder: (context) => Page),);
   }
   Color getColorFromHex(String hexColor) {
     hexColor = hexColor.toUpperCase().replaceAll('#', '');

     if (hexColor.length == 6) {
       hexColor = 'FF' + hexColor;
     }

     return Color(int.parse(hexColor, radix: 16));
   }




  showloading(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Loading" )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
dialogContext=context;
        return alert;
      },
    );
  }







  Stoploading(BuildContext context){
    Navigator.pop(dialogContext);
  }


  showPopup(BuildContext context, Widget widget, String title,Widget _popupBody,
      {BuildContext popupContext}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Navigator.push(
        context,
        PopupLayout(
          child: PopupContent(
              content:

              _popupBody
          ),
        )
    );
  }


}