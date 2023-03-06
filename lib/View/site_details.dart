import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// Flutter code sample for ExpansionPanelList.radio

// Here is a simple example of how to implement ExpansionPanelList.radio.
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innlite_mobile/Common/api_url.dart';
import 'package:innlite_mobile/Common/common_dart.dart';
import 'package:innlite_mobile/Common/http_request.dart';
import 'package:innlite_mobile/Common/utils.dart';
import 'package:innlite_mobile/View/popup.dart';
import 'package:innlite_mobile/View/popup_content.dart';
import 'package:innlite_mobile/View/singular_view.dart';
import 'package:innlite_mobile/View/livestreaming.dart';

import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global_page.dart';

SharedPreferences prefs;
final common = Common();
final global = Globalsearch();
final webview = WebViewLoad();
String _dropDownValue, prjtdropdown;
TabController _tabController;
VideoPlayerController _controller;
String siteadd, secondaryAtm;
List sitedetails1,sitedetails;
/// This is the main application widget.
int valueselected = 0;
String role ="";
bool stackvisible=false;
final httpreq = HttpRequest();
// stores ExpansionPanel state information
List<dynamic> _foundUsers = [];
TextEditingController Siteidcontroller= TextEditingController();
/// This is the stateful widget that the main application instantiates.
class SiteDeatils extends StatefulWidget {
  @override
  List sitedeatils, sensordetails, attendence, contact;
  String role;
  SiteDeatils(this.sitedeatils,String role);
  _SiteDeatils createState() => _SiteDeatils();
}

class _SiteDeatils extends State<SiteDeatils>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    getsharedprefence();
    super.initState();

    sitedetails = widget.sitedeatils;
    sitedetails1= widget.sitedeatils;
  }
  Future<bool> getsharedprefence() async {
    prefs = await SharedPreferences.getInstance();

  }
  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = [];
      setState(() {
        sitedetails=sitedetails1;
      });

    }

    else if(enteredKeyword.length>=4) {
      stackvisible=true;
      results =sitedetails
          .where((user) =>
          user["SiteName"].toString().toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      if(enteredKeyword.length>=4) {
        _foundUsers = results;
        if(_foundUsers.length!=0)
        sitedetails = _foundUsers;

      }
      else {
        _foundUsers.clear();
        sitedetails = sitedetails1;
        }
    });
  }
  bool value = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    yourWidth = width * 0.70;
if(_foundUsers.length==0)
  _foundUsers.clear();


    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: common.getColorFromHex('#F7F7F7'),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            sitedetails[0]['Status'].toString().toLowerCase() == "online"
                ? "Online Sites"
                : "Offline Sites",
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.nunito().fontFamily),
          ),
        ),
        body:

             Column(children: [
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        SizedBox(height: 10,),
                        Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),child:
                        Container(
                          decoration: BoxDecoration(  color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            border: Border.all(color:getColorFromHex('8D8D8D'),width: 2.0),),
                          child:

                          Padding(padding: EdgeInsets.fromLTRB(10,0,10,0),child:
                          TextField(
                            onChanged: (value) =>  _runFilter(value),
                            controller: Siteidcontroller,
                            decoration: const InputDecoration(
                                labelText: 'ATM Id' ,
                                suffixIcon: Icon(Icons.search)),
                          ),),),),
                        if(_foundUsers.length!=0)
                        /*Container(height: _foundUsers.length*60.toDouble(),child:*/
                          Stack(
                            children:[ _foundUsers.isNotEmpty
                                ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: _foundUsers.length,
                              itemBuilder: (context, index) =>

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      GestureDetector(
                                        onTap: () async{

                                          setState(() {

                                            Siteidcontroller.text=_foundUsers[index]['SiteName'].toString();



                                          });

                                          setState(() {
                                            _foundUsers.clear();
                                          });

                                        },
                                        child:
                                        Column(children: [
                                          Padding(padding: EdgeInsets.fromLTRB(20,0,0,0),child:
                                          Text(_foundUsers[index]['SiteName'].toString(),style: TextStyle(fontSize: 16),),),
                                        ],),), Divider(thickness: 2,)


                                    ],


                                  ),
                            )
                                : const Text(
                              'No results found',
                              style: TextStyle(fontSize: 24),
                            ),
                            ],),//),
SizedBox(height: 10,),
                         Container(
                           padding: EdgeInsets.all(5),
                           height:stackvisible? height*.62:height*.72,
                           width: double.infinity,
                           child:

                        Card(
                          color: Colors.white.withOpacity(0.9),
                          child:

                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Center(child: Text(
                                          'ATM ID',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Center(
                                            child: Text(
                                              'Address',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ),
                                      if (sitedetails[0]['Status']
                                          .toString()
                                          .toLowerCase() ==
                                          "offline"&& Glob().Userrole.toLowerCase()!="bank")
                                        Expanded(
                                          flex: 3,
                                          child: Center(
                                            child: Text(
                                              'Age',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: stackvisible? height*.50:height*.60,
                                      child:

                                  ListView.builder(

                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: sitedetails.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: getbodyText(
                                                      labeltext:
                                                          sitedetails[index]
                                                              ['SiteName'],
                                                      fontsize: 14.0,
                                                      weight:
                                                          FontWeight.normal),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  flex: 6,
                                                  child: Text(
                                                    sitedetails[index]
                                                        ['CompleteAddress'],
                                                    maxLines: 10,
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontFamily:
                                                          GoogleFonts.nunito()
                                                              .fontFamily,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                if (sitedetails[0]['Status']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    "offline"&& Glob().Userrole.toLowerCase()!="bank")
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      sitedetails[index]
                                                          ['Ageing'],
                                                      maxLines: 10,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontFamily:
                                                            GoogleFonts.nunito()
                                                                .fontFamily,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),
                                                Divider(
                                                  thickness: 2,
                                                )
                                              ],
                                            ),
                                            Divider(
                                              thickness: 3,
                                            )
                                          ],
                                        );
                                      }))
                                ]),
                          ),
                        )),
                      ])
              )
            ]));
  }


  @override
  void dispose() {

    _controller.dispose();
    _foundUsers.clear();
    sitedetails.clear();
    searchController.clear();
    searchController.text="";
    super.dispose();
  }
}
