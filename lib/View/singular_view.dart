import 'package:flutter/cupertino.dart';
/// Flutter code sample for ExpansionPanelList.radio

// Here is a simple example of how to implement ExpansionPanelList.radio.

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innlite_mobile/Common/api_url.dart';
import 'package:innlite_mobile/Common/common_dart.dart';
import 'package:innlite_mobile/Common/http_request.dart';
import 'package:innlite_mobile/Common/utils.dart';
import 'package:innlite_mobile/View/popup.dart';
import 'package:innlite_mobile/View/popup_content.dart';
import 'package:innlite_mobile/View/livestreaming.dart';

import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global_page.dart';
import 'location_webview.dart';

SharedPreferences prefs;
final common= Common();
final global = Globalsearch();
final webview = WebViewLoad();
String _dropDownValue, prjtdropdown;
TabController _tabController;
VideoPlayerController _controller;
String siteadd,secondaryAtm;
String latitude,longitude;
/// This is the main application widget.
int valueselected = 0;
TextEditingController Siteidcontroller1= TextEditingController();
List ticklist,sitedetails,sensordetails;
List<String> StatusValues = ['open', 'close'];
List<String> ticketsubstatus = [
  'Dispatched with Live Monitoring',
];
List<String> tattype = [
  'Closed within TAT',
];
List<String> dependency = [
  'Apar Dependency',
];
List<String> incident = [
  'No Critical Issue',
];
List<String> tickts ;
List<dynamic> applicancelist=new List<dynamic>();
List<String> statuslist=new List<String>();
TextEditingController mobileNo = new TextEditingController();
List eventvideo,contactdetails,attendence,todayattendence,lastattendence,contact,sitestatus,count;
double yourWidth;
Map<String,dynamic> applicance;
List sensors;
final httpreq= HttpRequest();
// stores ExpansionPanel state information
class Item {
  Item({
    this.id,
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  int id;
  String expandedValue;
  String headerValue;
  bool isExpanded;
}

/// This is the stateful widget that the main application instantiates.
class SingluarView extends StatefulWidget {
  @override
List sitedeatils,sensordetails,attendence,contact,appliance,sitestatus,counts;
  SingluarView(this.sitedeatils,this.sensordetails,this.attendence,this.contact,this.appliance,this.sitestatus,this.counts);
  _SingularView createState() => _SingularView();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SingularView extends State<SingluarView>
    with SingleTickerProviderStateMixin {
  List<dynamic> _foundUsers = [];
  @override
  void initState() {
    _foundUsers=[];
    super.initState();
    Glob().currentpage="singular";
    getsharedprefence();

sitedetails= widget.sitedeatils;


latitude=sitedetails[0]['Latitude'];
    longitude=sitedetails[0]['Longitude'];
sensordetails= widget.sensordetails;
attendence = widget.attendence;
todayattendence= attendence[0];
lastattendence= attendence[1];
contact = widget.contact;
applicancelist= widget.appliance;
print(applicancelist);
sitestatus=widget.sitestatus;
count=widget.counts;
  }

  Future<bool> getsharedprefence() async{
    prefs= await SharedPreferences.getInstance();
    return  false;
  }
  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = [];
    } else {
      results = Glob().sites
          .where((user) =>
          user["SiteName"].toString().toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      if(enteredKeyword.length>=4) {
        _foundUsers = results;
      }
      if(enteredKeyword.length<=3){
        _foundUsers.clear();
      }

    });
  }
  void _handleTabSelection() {
    setState(() {});
  }
  bool value = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    yourWidth = width * 0.70;
    return WillPopScope( onWillPop: () {
      Navigator.pop(context);
    },
        child:
        Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: common.getColorFromHex('#F7F7F7'),
            appBar: AppBar(
              centerTitle: true,

              title: Text(
                'Singular View',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.nunito().fontFamily),
              ),
            ),
            body: SingleChildScrollView(
                child: Stack(

       children:[
       Column(children: [
         SizedBox(height: 10,),
         Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),child:
         Container(
             decoration: BoxDecoration(  color: Colors.white,
               borderRadius: BorderRadius.all(Radius.circular(3)),
               border: Border.all(color:getColorFromHex('8D8D8D'),width: 2.0),),
             child:

             Padding(padding: EdgeInsets.fromLTRB(10,0,10,0),child:
         TextField(
           onChanged: (value) => _runFilter(value),
           controller: Siteidcontroller1,
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
                           Siteidcontroller1.text=_foundUsers[index]['SiteName'].toString();

                            List sitedetails1=(await httpreq.getdata(Glob().getsitedetails()+_foundUsers[index]['SiteId'].toString(),prefs.getString('token'),context)) as List;

                          latitude= sitedetails1[0]['Latitude'];
                           longitude= sitedetails1[0]['Longitude'];
                             if(sitedetails1.length!=0||sitedetails1!=null) {
                               common.showloading(context);
                               List sensordetails1 = (await httpreq.getdata(
                                   Glob().getsensordetails() + _foundUsers[index]['SiteName'].toString(),
                                   prefs.getString('token'),context)) as List;
                               List attendednce1 = (await httpreq.getdata(Glob().getattendencedeatils() +
        _foundUsers[index]['SiteName'].toString(),
                                   prefs.getString('token'),context)) as List;
                               List contact1 = (await httpreq.getdata(
                                   Glob().getcontactdetails() +_foundUsers[index]['SiteName'].toString(),
                                   prefs.getString('token'),context)) as List;
                               List appliance = (await httpreq.getdata(
                                   Glob().getappliance() +_foundUsers[index]['SiteName'].toString(),
                                   prefs.getString('token'),context)) as List;
                               List sitestatus= (await httpreq.getdata(
                                   Glob().getsitestatus() + _foundUsers[index]['SiteName'].toString(),
                                   prefs.getString('token'),context)) as List;
                               List counts= (await httpreq.getdata(
                                   Glob().getsitetcktcount() + _foundUsers[index]['SiteName'].toString()+"/"+Glob().Userrole,
                                   prefs.getString('token'),context)) as List;

                               common.Stoploading(context);
                               setState(() {
                                 sitedetails = sitedetails1;
                                 sensordetails=sensordetails1;
                                 attendence = attendednce1;
                                 todayattendence= attendence[0];
                                 lastattendence= attendence[1];
                                 contact= contact1;
                                 applicancelist= appliance;
                                 sitestatus= sitestatus;
                                 count=counts;
                                 FocusScope.of(context).requestFocus(FocusNode());
                               });
                              }else{
                               common.showAlert(context, 'Please enter correct Site ID');
                             }



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

         Padding(padding: EdgeInsets.all(10.0),child:
       Column(

                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        /*  global,*/
                          SizedBox(
                            height: 10.0,
                          ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Card(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child:
                                          Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                Row(children: [
                                                Expanded(flex:8,child:
                                                Text(
                                                  'Site Details',
                                                  style: TextStyle(
                                                      fontSize: 22.0,
                                                      color: Colors.black,
                                                      fontFamily: GoogleFonts.montserrat().fontFamily,
                                                      fontWeight: FontWeight.normal),
                                                ),),
                                                ],),
                                                SizedBox(height: 15,),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: getbodyText(labeltext: 'Site ID',fontsize: 16.0,weight: FontWeight.bold),
                                                    ),
                                                    Expanded(
                                                      flex: 6,
                                                      child: getbodyText(
                                                          labeltext: sitedetails[0]['SiteId'],fontsize: 14.0),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: getbodyText(labeltext: 'Site Name',fontsize: 16.0,weight: FontWeight.bold),
                                                    ),
                                                    Expanded(
                                                      flex: 6,
                                                      child: getbodyText(
                                                          labeltext: sitedetails[0]['Sitename'],fontsize: 14.0),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: getbodyText(
                                                          labeltext: 'Bank Name',fontsize: 16.0,weight: FontWeight.bold),
                                                    ),
                                                    Expanded(
                                                      flex: 6,
                                                      child: getbodyText(
                                                          labeltext:
                                                         sitedetails[0]['BankName'],fontsize: 14.0),
                                                    ),
                                                  ],
                                                ),


                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [

                                                    Expanded(
                                                      flex: 4,
                                                      child: Text('Address',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                                                    ),
                                                    Expanded(
                                                      flex: 6,
                                                      child:
                                                      Container(
                                                        width: yourWidth,
                                                        child:
                                                        Text(
                                                          sitedetails[0]['Address'],
                                                          maxLines: 14,

                                                          style:
                                                          TextStyle(
                                                              fontSize: 14.0,
                                                              fontFamily: GoogleFonts.nunito().fontFamily,
                                                              fontWeight: FontWeight.w500,
                                                              ),
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow.visible,

                                                        ),) /*getbodyText(
                                                          labeltext: siteadd,fontsize: 16.0),*/
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [

                                                    Expanded(
                                                      flex: 4,
                                                      child: Text('Site Location',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                                                    ),
                                                    Expanded(
                                                        flex: 6,
                                                        child:
                                                        Container(
                                                          width: yourWidth,
                                                          child:
                                                              GestureDetector(onTap: (){
                                                                common.navigateToSubPage(context, Location(latitude,longitude));
                                                              },
                                                                child:
                                                          Text('click here to view Map',

                                                            style:
                                                            TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors.blue,
                                                              decoration: TextDecoration.underline,
                                                              fontFamily: GoogleFonts.nunito().fontFamily,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                            textAlign: TextAlign.start,
                                                            overflow: TextOverflow.visible,

                                                          ),)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ))),
                                  SizedBox(height: 5,),





                                ],
                              ),



                          SizedBox(height: 10,),
                          _showcontact(),
                          SizedBox(height: 5,),
                          Card(child:
                          Padding(padding: EdgeInsets.all(5),child:

                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Expanded(flex:8,child:
                                  Text(
                                    'Site Status',
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        color: Colors.black,
                                        fontFamily: GoogleFonts.montserrat().fontFamily,
                                        fontWeight: FontWeight.normal),
                                  ),),
                                ],),
                                SizedBox(height: 15,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child:
                                    Card(

                                      child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),

                                          child:Padding(padding: EdgeInsets.all(5),child:
                                          Column(children: [

                                            getbodyText(labeltext: sitestatus[0]['MainPower'].toString(),fontsize: 24),
                                            getbodyText(labeltext: 'Main Power',fontsize:16)

                                          ],),)
                                      ),),),
                                    /*  SizedBox(width: 5,),
                                  Card(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.transparent,
                                          ),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),

                                        child:Padding(padding: EdgeInsets.all(5),child:
                                        Column(children: [

                                          getbodyText(labeltext: '35',fontsize: 24),
                                          getbodyText(labeltext: 'Humidity',fontsize:16)

                                        ],),)
                                    ),),
                                  SizedBox(width: 5,),
                                  Card(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.transparent,
                                          ),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),

                                        child:Padding(padding: EdgeInsets.all(5),child:
                                        Column(children: [

                                          getbodyText(labeltext: '34',fontsize: 24),
                                          getbodyText(labeltext: 'Temperature',fontsize:16)

                                        ],),)
                                    ),),*/
                                  ],)


                              ] ),),),
                          SizedBox(height: 10,),
                          Card(
                            margin: EdgeInsets.all(0.0),
                            child:
                            Padding(padding: EdgeInsets.all(10.0),child:
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Attendance',
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        color: Colors.black,
                                        fontFamily: GoogleFonts.montserrat().fontFamily,
                                        fontWeight: FontWeight.normal),
                                  ),

                                  getbodyText(labeltext: 'Attendance based on keypad entry',fontsize: 14,color: Colors.grey),
                                  SizedBox(height:10,),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: getbodyText(
                                            labeltext: 'PERSON',fontsize: 16.0,weight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: getbodyText(
                                            labeltext:
                                            'TODAY',fontsize: 16.0,weight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: getbodyText(
                                            labeltext:
                                            'LAST',fontsize: 16.0,weight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Divider(thickness: 1,),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: todayattendence.length,
                                      itemBuilder: (context, index) {
                                        return

                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 4,
                                                child: getbodyText(
                                                    labeltext: todayattendence[index]['Username'],
                                                    fontsize: 14.0,
                                                    weight: FontWeight.normal),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Container( width:100,child:
                                                  getbodyText(
                                                      labeltext:

                                                      todayattendence[index]['Attendance']=="Not Attended"?"Not Attended":
                                                      todayattendence[index]['Attendance'], fontsize: 14.0),

                                                ),

                                              ),
                                              Expanded(
                                                flex: 5,
                                                child:
                                                Container( width: 100,child:
                                                  getbodyText(
                                                      labeltext:
                                                      lastattendence[index]['Attendance'], fontsize: 14.0),

                                                ),

                                              ),
                                            ],
                                          );
                                      })
                                /*  DataTable(
                                    columnSpacing: 20.0,
                                    columns: [
                                      DataColumn(
                                        label:Expanded(flex:1,child:  Text(
                                            'PERSON',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                                        )),),
                                      DataColumn(label:Expanded(flex:1,child: Text(
                                          'TODAY',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                                      )),),
*//*
                                      DataColumn(label: Expanded(flex:4,child:Text(
                                          'TODAY',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                                      )),),
*//*
                                      DataColumn(label: Expanded(flex:4,child:Text(
                                          'LAST',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                                      )),),

                                    ],
                                    rows:

                                    List.generate(

                                      todayattendence.length, (index) =>


                                        DataRow(

                                          cells: <DataCell>[
                                            DataCell(
                                                Text(todayattendence[index]['Username'])),

*//*                                          DataCell(Text(attendence[index]['todayDateTime'])),*//*

                                            DataCell(
                                                Checkbox(
                                                    value: todayattendence[index]['Attendance']=="Attended"?true: this.value,
                                                    onChanged: (bool value) {
                                                      setState(() {
                                                       // common.showAlert(context,"lastAttendendedDateTime : "+attendence[index]['lastAttendendedDateTime']);
                                                      });})),
                                            DataCell( Container(
                                              width: 100,
                                              child:
                                              Text(
                                                lastattendence[index]['Attendance'],
                                                maxLines: 5,

                                                style:
                                                TextStyle(
                                                    fontSize: 12.0,
                                                    fontFamily: GoogleFonts.montserrat().fontFamily,
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.black),
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.visible,

                                              ),),

                                            ),
                                           *//* DataCell( Container(
                                              width: 90,
                                              child:
                                              Text(
                                                lastattendence[index]['Attendance'],
                                                maxLines: 5,

                                                style:
                                                TextStyle(
                                                    fontSize: 10.0,
                                                    fontFamily: GoogleFonts.montserrat().fontFamily,
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.black),
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.visible,

                                              ),),

                                            )*//*],
                                        ),
                                    ),

                                  ),*/
                                ]),),
                          ),
                          SizedBox(height: 5,),

                          Card(child:
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Expanded(flex:8,child:
                                    Text(
                                      'Site Open Ticket Count',
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          color: Colors.black,
                                          fontFamily: GoogleFonts.montserrat().fontFamily,
                                          fontWeight: FontWeight.normal),
                                    ),),
                                  ],),
                                  SizedBox(height: 15,),
                                  SizedBox(
height: 70,
child:                                  Row(

                                    children: [
                                    Expanded(flex: 3,child:
                                    Card(
                                      color:common.getColorFromHex('#f08182'),
                                      child:
                                      Container(

                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),

                                          child:Padding
                                            (padding: EdgeInsets.all(2),child:
                                          Column(children: [

                                            getbodyText(labeltext: count[0]['SOS'].toString(),fontsize: 24,color: Colors.white),
                                            getbodyText(labeltext: 'SOS',fontsize:16,color: Colors.white)

                                          ],),)
                                      ),),),
                                    Expanded(flex: 3,child:
                                    Card(
                                      color:common.getColorFromHex('#ffb976'),
                                      child:
                                      Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),

                                          child:Padding(padding: EdgeInsets.all(2),child:
                                          Column(children: [

                                            getbodyText(labeltext: count[0]['Critical'].toString(),fontsize: 24,color: Colors.white),
                                            getbodyText(labeltext: 'Critical',fontsize:16,color: Colors.white)

                                          ],),)
                                      ),),),
                                    Expanded(flex: 3,child:
                                    Card(
                                      color:common.getColorFromHex('#48da89'),
                                      child:
                                      Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),

                                          child:Padding(padding: EdgeInsets.all(2),child:
                                          Column(children: [

                                            getbodyText(labeltext: count[0]['Medium'].toString(),fontsize: 24,color: Colors.white),
                                            getbodyText(labeltext: 'Medium',fontsize:16,color: Colors.white)

                                          ],),)
                                      ),),),
                                    if( Glob().Userrole.toLowerCase()!="bank")
                                      Expanded(flex: 3,child:
                                      Card(
                                        color:common.getColorFromHex('#6e6b7b'),
                                        child:
                                        Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color:common.getColorFromHex('#6e6b7b'),
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),

                                            child:Padding(padding: EdgeInsets.all(2),child:
                                            Column(children: [

                                              getbodyText(labeltext: count[0]['Low'].toString(),fontsize: 24,color: Colors.white),
                                              getbodyText(labeltext: 'Low',fontsize:16,color: Colors.white)

                                            ],),)
                                        ),),),

                                  ],)),


                                ] ),
                          ),),

                          SizedBox(height: 10,),
                          Card(
                              child:
                              Padding(padding: EdgeInsets.all(10.0),child:
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(children: [
                                      Text(
                                        'Announcements',
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.black,
                                            fontFamily: GoogleFonts.montserrat().fontFamily,
                                            fontWeight: FontWeight.normal),
                                      ),



                                    ],),

                                    SizedBox(height: 10,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(flex: 2,
                                          child:getCustomButton(labeltext: 'Crowd',onpressed:(){ postannouncement('Crowd');}),
                                        ),
                                        Expanded(flex: 2,
                                          child:getCustomButton(labeltext: 'Helmet',color: Colors.green,onpressed:(){ postannouncement('Helmet');}),
                                        ),
                                        Expanded(flex: 2,
                                          child:getCustomButton(labeltext: 'Mobile',color:Colors.red,onpressed:(){ postannouncement('Mobile');}),
                                        ),
                                      ],),

                                  ]),
                              )
                          ),
                          SizedBox(height: 10,),
                          Card(
                            margin: EdgeInsets.all(0.0),
                            child:
                            Padding(padding: EdgeInsets.all(10.0),child:
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Appliance Control',
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        color: Colors.black,
                                        fontFamily: GoogleFonts.montserrat().fontFamily,
                                        fontWeight: FontWeight.normal),
                                  ),


                                  SizedBox(height:10,),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: getbodyText(
                                            labeltext: 'Item Name',fontsize: 16.0,weight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: getbodyText(
                                            labeltext:
                                            'Status',fontsize: 16.0,weight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: getbodyText(
                                            labeltext:
                                            'Action',fontsize: 16.0,weight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Divider(thickness: 1,),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: applicancelist.length,
                                      itemBuilder: (context, index) {
                                        return

                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child:Wrap(
                                                  spacing: 10,

                                                  children: [
                                                  getbodyText(
                                                      labeltext: applicancelist[index]['ChannelName'],
                                                      fontsize: 16.0,
                                                      weight: FontWeight.bold),
                                                   /* SizedBox(height: 5,),
                                                    Center(child:Text(applicancelist[index]['CommandStatus'],style: TextStyle(fontSize: 12.0),)),
*/
                                                ],)
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container( width:100,child:
                                            Wrap(
                                        spacing:10.0,
                                        children:[
                                          Center(child:
                                                getbodyText(
                                                    labeltext:

                                                    applicancelist[index]['Status'], fontsize: 14.0,weight: FontWeight.bold),),
                                       /* Center(child:Text(applicancelist[index]['CommandStatus'],style: TextStyle(fontSize: 12.0),)),*/
                                       ]),
                                        )
                                                ),


                                              Expanded(
                                                flex: 5,
                                                child:
                                              Row(children:[
                                                ButtonTheme(
                                                minWidth: 20.0,
                                                height: 20.0,

                                                  child:    ElevatedButton(
                                                    style: ElevatedButton.styleFrom(primary:
                                                    common.getColorFromHex('#3293d1')),
                                                    // color: common.getColorFromHex('#3293d1'),
                                                    onPressed: () {Oncommand(index,'ON');},
                                                    child: Text("ON"),
                                                  ),
                                                ),
                                                SizedBox(width: 2,),
                                                ButtonTheme(
                                                  minWidth: 20.0,
                                                  height: 20.0,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(primary:
                                                    common.getColorFromHex('#a90329')),
                                                    //style:
                                                    //common.getColorFromHex('#a90329'),
                                                    onPressed: () {Oncommand(index,'OFF');},
                                                    child: Text("OFF"),
                                                  ),
                                                ),


                                        ]),


                                        ),
                                          ]);


                                      }),

                                ]), ),


                          ),
                          SizedBox(height: 10,),
         Card(
             child:
             Padding(padding: EdgeInsets.all(10.0),child:
             Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(children: [
                     Text(
                       'Sensor Status',
                       style: TextStyle(
                           fontSize: 22.0,
                           color: Colors.black,
                           fontFamily: GoogleFonts.montserrat().fontFamily,
                           fontWeight: FontWeight.normal),
                     ),

                   ],),
                   SizedBox(height: 20,),


                   Row(
                     children: [
                       Expanded(
                         flex: 6,
                         child: getbodyText(
                             labeltext: 'Sensor',fontsize: 20.0,weight: FontWeight.bold),
                       ),
                       Expanded(
                         flex: 4,
                         child: getbodyText(
                             labeltext:
                             'Status',fontsize: 20.0,weight: FontWeight.bold),
                       ),
                     ],
                   ),
                   if(sensordetails.length!=0)
                     ListView.builder(
                         shrinkWrap: true,
                         physics: NeverScrollableScrollPhysics(),
                         itemCount: sensordetails.length,
                         itemBuilder: (context, index) {
                           return

                             Row(
                               children: [
                                 Expanded(
                                   flex: 6,
                                   child: getbodyText(
                                       labeltext: sensordetails[index]['SensorName'],
                                       fontsize: 14.0,
                                       weight: FontWeight.normal),
                                 ),
                                 Expanded(
                                   flex: 4,
                                   child: Row(children: [
                                     Icon(Icons.brightness_1_rounded,color: sensordetails[index]['Status'].toString().toLowerCase()=="silent"?Colors.red:Colors.green),
                                     getbodyText(
                                         labeltext:
                                         sensordetails[index]['Status'], fontsize: 14.0),

                                   ],),

                                 ),
                               ],
                             );
                         })])


             )),



                        ]),

             )])]))));
  }


Widget _showcontact(){

 return Container(
   color: Colors.white,
   child:Padding(
     padding:EdgeInsets.all(20),child:
  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            'Key Contact Details',
            style: TextStyle(
                fontSize: 22.0,
                color: Colors.black,
                fontFamily: GoogleFonts.montserrat().fontFamily,
                fontWeight: FontWeight.normal),
          ),

        ],),
        SizedBox(height:15,),
  ListView.builder(
      physics: NeverScrollableScrollPhysics(),
  shrinkWrap: true,
  itemCount: contact.length,
  itemBuilder: (context, index) {
  return
  Column(children: [
  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //RoundedLetter.withBlueCircle("ST", 40, 20),

            Expanded(flex:3,child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                getbodyText(labeltext:contact[index]['ContactName'],fontsize: 16.0,weight: FontWeight.bold),
                getbodyText(labeltext:contact[index]['ResponderType'],fontsize: 14.0)
              ],),),
            SizedBox(width: 10,),
            Expanded(flex:5,child:
            Column(                            mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getbodyText(labeltext:contact[index]['EmailId'],fontsize: 16.0,weight: FontWeight.bold),
                getbodyText(labeltext:contact[index]['ContactNumber'],fontsize: 16.0)
              ],)),

          ],
    ),
    Divider(thickness: 1,),

  ],);

  }),

      ]),));
}

void postannouncement(String commandname) async{
    common.showloading(context);
  Map<String, dynamic> credentials = {
    'SiteId': sitedetails[0]['Sitename'],
    'CommandName': commandname,
    'UserName':prefs.getString('username'),

  };
  var applianceresult = (await httpreq.postdata(
      Glob().getAnnouncement(), credentials, '')) ;
  common.Stoploading(context);
    common.showAlert(context, commandname+" command sent");


  print(applianceresult);

}


void Oncommand(int index,String command) async{
var name= applicancelist[index]['ChannelName'];
if(name.toString().toLowerCase()=="lobby lights"){
  name= "LL-1";
}
else if(name.toString().toLowerCase()=="signage"){
  name= "GS-1";
}
else if(name.toString().toLowerCase()=="siren"){
  name= "SIREN-1";
}

  Map<String, dynamic> credentials = {
    'SiteID': sitedetails[0]['Sitename'],
    'CommandName': command,
    'UserName':prefs.getString('username'),
    'Channelname':name,
  };
  String applianceresult = (await httpreq.postdata(
      Glob().getappliancecontrol(), credentials, '')) ;
  print(applianceresult);
  common.showAlert(context,"Sent");
List appliance = (await httpreq.getdata(
    Glob().getappliance() + sitedetails[0]['Sitename'].toString(),
    prefs.getString('token'),context)) as List;
setState(() {
  applicancelist= appliance;
  print(applicancelist);
});
  }

  @override
  void dispose() {
    Siteidcontroller1.text="";
    Glob().currentpage="";
    super.dispose();
  }

}
