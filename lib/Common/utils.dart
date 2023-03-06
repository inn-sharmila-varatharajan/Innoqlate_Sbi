import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:innlite_mobile/Common/common_dart.dart';

import 'common_dart.dart';
//Color code for all text,button
String _dropDownValue="";
final common= Common();
Color getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');

  if (hexColor.length == 6) {
    hexColor = 'FF' + hexColor;
  }

  return Color(int.parse(hexColor, radix: 16));
}
// Text with click detection
Padding getCustomText({ String labeltext="",GestureTapCallback ontap}) {

  Padding textpad = Padding(
    padding: EdgeInsets.all(20.0),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        GestureDetector(
        onTap: () {
  {ontap();}
  }
  ,child:

  Text(
    labeltext,
    style: GoogleFonts.nunito(fontSize: 16.0,),
  ),
  ),]));

  return textpad;

}

Padding getbodyText({ String labeltext="",GestureTapCallback ontap,double fontsize,FontWeight weight,Color color}) {

  Padding textpad = Padding(
padding: EdgeInsets.all(0.0),

      child:

      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                {ontap();}
              }
              ,child:


            Text(
              labeltext, maxLines: 2,overflow: TextOverflow.ellipsis,softWrap: false,
              style: GoogleFonts.nunito(fontSize: fontsize,fontWeight: weight ,height: 1.2,color: color),
            ),
            ),]));

  return textpad;

}


//Button click
Container getCustomButton({String labeltext="",GestureTapCallback onpressed,double width,double height,MaterialColor color}){
 Container buttoncontainer= Container(
margin: EdgeInsets.all(5.0),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(15),
),
child: SizedBox(
width: width==null? double.infinity:width,
child: ElevatedButton(
  style: ElevatedButton.styleFrom(
padding: const EdgeInsets.all(10),
    onPrimary:  Colors.white,
    backgroundColor:  color==null? getColorFromHex('0e8dff'):color),
onPressed: () {
{onpressed();}
},
child: Text(
  labeltext,
style: GoogleFonts.nunito(fontSize: 18.0,),
),
)));
return buttoncontainer;

}
//Textfield click for entering the texts.
Container getCustomTextField({String labelValue = "",
    String hintValue = "",
    bool validation,
    TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    TextStyle textStyle,bool obscuretext=false,
    TextInputAction action,GestureTapCallback toggle,
    String validationErrorMsg,Icon iconname}) {
   Container container=    Container(
      margin: EdgeInsets.fromLTRB(20.0,10.0,20.0,10.0),
      padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 20.0),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color:getColorFromHex('8D8D8D'),width: 2.0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: <Widget>[
          new Expanded(child: TextFormField(
            obscureText: obscuretext,
            autofocus: false,
            controller: controller,
            toolbarOptions: null,
            textInputAction: action,
            decoration: new InputDecoration.collapsed(

                hintText: hintValue,
                hintStyle:   GoogleFonts.nunito(fontSize: 20.0,), ),
            onEditingComplete: () {
              // Move the focus to the next node explicitly.
            },

          )),

          if(iconname!=null)
          IconButton(
            icon:iconname,
            onPressed: (toggle) ,

          ),

        ],
      ),
    );
    return container;
  }
bool isEmail(String em) {
  String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(em);
}

//Appbar

AppBar getcustomappbar({BuildContext context,bool centertitle=false,String title= "" , bool automaticallyImplyLeading =false,
double leadingwidth=0,}) {
  AppBar appbar= AppBar(
    centerTitle: centertitle,
    leadingWidth: leadingwidth,
    title: Text(
      title,
      style: GoogleFonts.nunito(textStyle:Theme.of(context).textTheme.headline1,fontSize: 25.0,fontWeight: FontWeight.w700,color: Colors.white)   //TextStyle(fontFamily: 'Nunitobold', fontSize: 30.0),

    ),
    backgroundColor: getColorFromHex('0e8dff'),
  );
  return appbar;
}

//getcustomdropdown



