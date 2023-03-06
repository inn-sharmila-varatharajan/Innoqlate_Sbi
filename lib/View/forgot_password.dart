import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innlite_mobile/Common/api_url.dart';
import 'package:innlite_mobile/Common/utils.dart';

import 'login_page.dart';



bool ispasswordnotsent = true, passwordsent = false;

class Password extends StatelessWidget {
  @override
  Widget build(BuildContext context) {}
}

class Forgotpassword extends StatefulWidget {
  @override
  MyPassword createState() => MyPassword();
}


class MyPassword extends State<Forgotpassword> {
  TextEditingController usernamecontroller = new TextEditingController();
  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  final FocusNode _user = FocusNode();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,

        appBar:getcustomappbar(context: context, centertitle: true,title: 'Forgot Password',automaticallyImplyLeading: true,leadingwidth: 18.0,),

        body: SingleChildScrollView(
          reverse: true,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                  if (ispasswordnotsent)
                  Image.asset(
                    "icons/pnblogo.png",
                    height: 250,
                  ),

                  if (ispasswordnotsent)
                    getCustomTextField(hintValue: 'Username',action: TextInputAction.next,controller: usernamecontroller,),

                  if (ispasswordnotsent)
                    getCustomButton(labeltext: 'Send reset link',onpressed: ()=> Sendverificationlink()),

                  if(passwordsent)

                    IconButton(
                      iconSize: 250.0,
                      icon:Icon(Icons.check_circle_outline,
                      color: Colors.green,
                      size: 50,

                    ),),
                  if (passwordsent)
                    getCustomText(labeltext: "Verification link sent to your Email-Id.Please reset your password to continue.",
                        ),
                  if (passwordsent)
                    getCustomButton(labeltext: 'Login',onpressed: ()=> loginclick()),

                ]),
          ),
        ));
  }
   loginclick(){
    ispasswordnotsent=true;
    passwordsent=false;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
            (route) => false);
    //  navigateToSubPage(context, Login());
  }
Sendverificationlink(){
 if (!isEmail(usernamecontroller.text.trim())) {
    Fluttertoast.showToast(
        msg: "Email is invalid",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }else {
    passwordsent = true;
    ispasswordnotsent = false;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    callapi();
 }
}
  void callapi() async{
    Map<String,String> credentials= {
      'username': 'varun.suresh@aparinnosys.com',
    };
  //  Map<String,dynamic> logindata = (await httpreq.postdata(Glob().getForgpotPassword(),credentials,'')) as Map<String,dynamic>;
  }
}
