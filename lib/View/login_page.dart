import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innlite_mobile/Common/api_url.dart';
import 'package:innlite_mobile/Common/common_dart.dart';
import 'package:innlite_mobile/Common/http_request.dart';
import 'package:innlite_mobile/Common/utils.dart';
import 'package:innlite_mobile/View/dashboard_view.dart';
import 'package:innlite_mobile/View/forgot_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
final common=Common();
final httpreq= HttpRequest();
var tcktscount,sitecount;
List onlinesite=[],offlinesite=[];
int loginclickcount = 0;
 SharedPreferences prefs;
class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getsharedprefence();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  MyLoginPage createState() => MyLoginPage();

}
Future<bool> getsharedprefence() async{
 prefs= await SharedPreferences.getInstance();
  return  false;
}
void callurl(BuildContext context) async{
  sitecount = (await httpreq.getdata(Glob().getSites()+"/"+prefs.getString('bankcode'),prefs.getString('token'),context));
  List<dynamic> overalllist = sitecount['Table'];
  Glob().sites= overalllist;
  tcktscount = (await httpreq.getdata(Glob().getTicketCount()+"/"+prefs.getString('bankcode'),prefs.getString('token'),context));
  var count = (await httpreq.getdata(Glob().getallsitesstatus()+"/"+prefs.getString('bankcode'),prefs.getString('token'),context));
  List<dynamic> counts= count[0];
  var offlinecount=counts.asMap();
  Glob().totalofflinesite= (offlinecount[0]['TotalOfflineSiteCount']).toString();
  Glob().totalonlinesite= (offlinecount[0]['TotalOnlineSitecount']).toString();
  common.Stoploading(context);
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MyDashboardPage(prefs.getString('username'),tcktscount)),
          (route) => false);
}
class MyLoginPage extends State<LoginPage>  {

  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController pwdcontroller = new TextEditingController();
  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  final FocusNode _user = FocusNode();
  final FocusNode _pwd = FocusNode();
  bool _obscureText = true,passwordshown=true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    getsharedprefence();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          reverse: true,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child:
          Container(
            margin: EdgeInsets.only(top:100),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                  Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),child:
                  Image.asset(
                    "icons/logo.png",
                    height: 250,
                  ),),
                  Padding(padding: EdgeInsets.all(10),
                      child:     Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),


                          child:
                          Column(
                            children: <Widget>[
                              getCustomTextField(
                                  hintValue: 'Username',
                                  controller: usernamecontroller,
                                  action: TextInputAction.next,
                                  iconname: null),
                              getCustomTextField(
                                  hintValue: 'Password',
                                  controller: pwdcontroller,
                                  action: TextInputAction.done,
                                  iconname:  passwordshown? Icon(Icons.remove_red_eye_outlined):  Icon(Icons.remove_red_eye_sharp),
                                  toggle: () => toggle(),
                                  obscuretext: _obscureText),
                              getCustomButton(
                                  labeltext: 'Login', onpressed: () => LoginPage()),
                              /*getCustomText(
                          labeltext: 'Forgot Password?',
                          ontap: () => forgotpassword()),*/
                            ],))), ]),

          ),
    ));
  }

  LoginPage() async {
    if (usernamecontroller.text.trim().isEmpty) {
      Fluttertoast.showToast(
          msg: "Username is invalid",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else if (!isEmail(usernamecontroller.text.trim())) {
      Fluttertoast.showToast(
          msg: "Email is invalid",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else if (pwdcontroller.text.trim().isEmpty) {
      Fluttertoast.showToast(
          msg: "password is invalid",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    else if (usernamecontroller.text.trim().isNotEmpty  &&
        pwdcontroller.text.trim().isNotEmpty) {
      common.showloading(context);
      Map<String, String> credentials = {
        'usreid': usernamecontroller.text,
        'password': pwdcontroller.text
      };
      List<dynamic> logindata = (await httpreq.postdata(
          Glob().getLoginUrl(), credentials, '')) as List<dynamic>;

      usernamecontroller.text = "";
      pwdcontroller.text = "";
      if (logindata.length != 0) {
        prefs.setBool('isloggedin', true);
        prefs.setString('username', logindata[0]['Username'].toString());
        prefs.setString('role', logindata[0]['UserRole']);

        prefs.setString('level', logindata[0]['UserLevel']);
        prefs.setString('bankcode', logindata[0]['BankCode'].toString());
        prefs.setString('token', '');
        callurl(context);
      }

else{
  common.Stoploading(context);
         Fluttertoast.showToast(
             msg: "Invalid Credentials",
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.CENTER,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.red,
             textColor: Colors.white,
             fontSize: 16.0
         );

       }
    }  else {
         usernamecontroller.text = "";
        pwdcontroller.text = "";
        loginclickcount = 0;
        forgotpassword();
      }
  }


  forgotpassword() {
    common.navigateToSubPage(context, Forgotpassword());
  }
  toggle() {
    setState(() {
      passwordshown= !passwordshown;
      _obscureText = !_obscureText;
    });
  }
}
