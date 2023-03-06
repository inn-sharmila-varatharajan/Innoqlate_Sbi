import 'dart:async';



import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innlite_mobile/Common/api_url.dart';
import 'package:innlite_mobile/Common/common_dart.dart';
import 'package:innlite_mobile/Common/http_request.dart';
import 'package:innlite_mobile/Common/utils.dart';
import 'package:innlite_mobile/View/bulgary_report.dart';
import 'package:innlite_mobile/View/camera_ageing.dart';
import 'package:innlite_mobile/View/customer_grievance.dart';
import 'package:innlite_mobile/View/sticky_header.dart';
import 'package:innlite_mobile/View/storedvideo_player.dart';

import 'package:innlite_mobile/View/global_page.dart';

import 'package:innlite_mobile/View/login_page.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:innlite_mobile/View/singular_view.dart';
import 'package:innlite_mobile/View/livestreaming.dart';
import 'package:innlite_mobile/View/stored_video.dart';
import 'package:innlite_mobile/View/videotag.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'location_webview.dart';
String _dropDownValue, prjtdropdown;
double itemHeight = 0, itemWidth = 0;
final common = Common();
List counts=new List();
List lowcounts=new List();
SharedPreferences prefs;
final httpreq= HttpRequest();
final global= Globalsearch();
List soslist = [];
List criticallist=[];
List lowlist=[];
List projects =  [

];
List onlinesite=[],offlinesite=[],allsites=[];
List<String> sitename= [];
bool allcameras=false,allcamerason=false,nopinhole=false,nobackroom=false,nopinholeon=false,nobackroomon=false;

List<String> sitevalues= [],cameradetails=[],cameravalue;
Timer _timer;
List  totalTicket = [];
String role="";
int _start = 0;

class MyDashboardPage extends StatefulWidget {

  @override
  final String username;
  var tcktcount;
  MyDashboardPage(this.username,this.tcktcount);



  _MyDashboard createState() => _MyDashboard();

}
String getcriticalcount(String id){
  String coun = id.toString().replaceAll(
      new RegExp(r'[^\w\s]+'), '');
  coun = coun.substring(6, coun.length);
  return coun;

}

String getsiteid(int id){
  int siteidloc = Glob().sites.indexWhere((f) => f['siteId'] == id);
  String sitename = Glob().sites[siteidloc]['siteName'];
  Glob().selectedprojectid=Glob().sites[siteidloc]['siteId'].toString();
  Glob().selectedbankname=Glob().sites[siteidloc]['siteName'].toString();
  //same with this ['color'] not x.color
  return sitename;
}

class _MyDashboard extends State<MyDashboardPage> with WidgetsBindingObserver {
  @override
  void initState()  {
    super.initState();

getsharedprefence();

  }

  @override
  void dispose() {
    if(_timer!=null) {
      _timer.cancel();
    }
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getsharedprefence();
    }
  }
  Future<bool> getsharedprefence() async{

    prefs= await SharedPreferences.getInstance();
    islogin= prefs.getBool('isloggedin');
    var tcktscount= widget.tcktcount;
     counts = tcktscount['Table'];

    soslist =tcktscount['Table2'];
    criticallist=tcktscount['Table1'];
    setState(() {
      counts=counts;
        soslist= soslist;
        criticallist= criticallist;
        lowcounts=tcktscount['Table3'];
      lowlist= tcktscount['Table4'];
    });
    _timer = Timer.periodic(Duration(seconds: 30), (Timer t) => callurl());
    return islogin ;

  }

  void callurl() async{

    sitecount = (await httpreq.getdata(Glob().getSites()+"/"+prefs.getString('bankcode'),prefs.getString('token'),context));
     Glob().totalsites=sitecount.length.toString();

    tcktscount = (await httpreq.getdata(Glob().getTicketCount()+"/"+prefs.getString('bankcode'),prefs.getString('token'),context));

    var count = (await httpreq.getdata(Glob().getallsitesstatus()+"/"+prefs.getString('bankcode'),prefs.getString('token'),context));
    counts= count[0];
     allsites= count[1];
    Glob().sites= allsites;
    onlinesite.clear();
    offlinesite.clear();
    for(int i=0;i<allsites.length;i++){
      String jj= allsites[i]['Status'];
      if(jj.toLowerCase()=="online"){
onlinesite.add(allsites[i]);
      }
      else{
        offlinesite.add(allsites[i]);
      }
    }
    var offlinecount=counts.asMap();
     Glob().totalofflinesite= (offlinecount[0]['TotalOfflineSiteCount'].toString());
    Glob().totalonlinesite= (offlinecount[0]['TotalOnlineSitecount'].toString());

    setState(() {
      counts = tcktscount['Table'];
      soslist =tcktscount['Table2'];
      criticallist=tcktscount['Table1'];
        counts=counts;
        soslist= soslist;
        criticallist= criticallist;
        lowcounts=tcktscount['Table3'];
        lowlist= tcktscount['Table4'];
      Glob().totalofflinesite= (offlinecount[0]['TotalOfflineSiteCount'].toString());
      Glob().totalonlinesite= (offlinecount[0]['TotalOnlineSitecount'].toString());

    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    itemHeight = (size.height - kToolbarHeight - 24) / 2;
    itemWidth = size.width / 2;

   role= prefs.getString('role');
   Glob().Userrole= role;
   print(role);
void settotalticket(){

  setState(() {

  });


}

void openlinphone() async {
  await LaunchApp.openApp(
      androidPackageName:'org.linphone');
}


    return Scaffold(
        resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: Text('Open Ticket Dashboard',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.nunito().fontFamily),),
        centerTitle: true,
        actions: [ GestureDetector(onTap:(){callurl();}, child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),child:  Icon(Icons.refresh),
        )),]
       /* Container(height: 50,width: 50,child:Padding(padding: EdgeInsets.fromLTRB(0,0,10,0,),child:
        Image.asset('icons/pnblogo.png')))],*/
      ),
      drawer: Drawer(
          child: new ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text("Welcome",style:TextStyle(fontFamily: GoogleFonts.nunito().fontFamily,fontSize: 20.0,),),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.red,
                )),
                ListTile(
                  title: Text('Singular View',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.nunito().fontFamily),),
                  onTap: () {
                    Navigator.pop(context);
                    _singularlist();

                  },
                ),

                ListTile(
                  title: Text('Live Streaming',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.nunito().fontFamily),),
                  onTap: () {
                    Navigator.pop(context);
                    common.navigateToSubPage(context, WebViewLoad());
                  },
                ),

                ListTile(
                  title: Text('Stored Video',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.nunito().fontFamily),),
                  onTap: () {
                    Navigator.pop(context);
                    // common.navigateToSubPage(context, SamplePlayer());
                    _ticketlist();

                  },
                ),
if(Glob().Userrole.toString().toLowerCase()=="bank")
                ListTile(
                  title: Text('Customer Grievance',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.nunito().fontFamily),),
                  onTap: () {
                    Navigator.pop(context);

                    common.navigateToSubPage(context, Searchlist());
                  },
                ),
                if(Glob().Userrole.toString().toLowerCase()=="bank")
                ExpansionTile(

                  title: Text('Report',style:TextStyle(fontSize: 18)),children: [
   Container(child:  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Align(
    alignment: Alignment.topLeft,
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
                   GestureDetector(onTap: (){ _bulgaryreport();},child: Text('Burglary',style:TextStyle(fontSize: 18),)),SizedBox(height: 10,),
    GestureDetector(onTap: (){
      _Cameraageing();
},child: Text('Camera Ageing',style:TextStyle(fontSize: 18))),SizedBox(height: 10,),]),),),),]),
                ListTile(
                  title: Text('VOIP Link',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.nunito().fontFamily),),
                  onTap: () {
                    openlinphone();
                  },
                ),


                ListTile(
                  title: Text('Logout',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.nunito().fontFamily),),
                  onTap: () {
                    Navigator.pop(context);
                     prefs.setBool('isloggedin',false);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                            (route) => false);
                  },
                ),
          ])),
      backgroundColor: common.getColorFromHex('#F7F7F7'),
      body:
           Column(
            mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Padding(padding: EdgeInsets.all(10.0),child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            Row(
              children: [
                global,

              ],
            ),
            SizedBox(height: 20,),
            Container(
              height: MediaQuery.of(context).size.height*.75,
              child:
            SingleChildScrollView(child:
            Column(children: [
            Column(            mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SizedBox(height: 10.0,),
            Text('Ticket Dashboard',style: TextStyle(fontFamily: GoogleFonts.nunito().fontFamily,fontWeight: FontWeight.bold,fontSize: 18.0),),

            SizedBox(height: 10.0,),
            Container(height: 80,
              child:
            Card(
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                    SizedBox(height: 10,),
              Row(children: [
                SizedBox(width: 20,),

                if(counts.length!=0)
              Expanded(flex: 8,child:

              Text( getcriticalcount(counts[0].toString()),style: TextStyle(color:common.getColorFromHex('#6e6b7b'),fontSize: 18.0,fontFamily: GoogleFonts.montserrat().fontFamily,fontWeight: FontWeight.bold),),
              ),                                Expanded(flex: 2,child:
                SvgPicture.string('''	
<svg xmlns="http://www.w3.org/2000/svg" width="21px" height="21px" viewBox="0 0 24 24" fill="none" stroke="#6e6b7b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-trending-up"><polyline color="#7367f0" points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline><polyline points="17 6 23 6 23 12" color="#7367f0"></polyline></svg>'''),
                ),                        ],),
                  SizedBox(height: 10,),

                  Expanded(child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0),child:

                      Text('Total SOS Ticket',style: TextStyle(height:.7,fontSize: 16.0,fontFamily: GoogleFonts.montserrat().fontFamily,fontWeight: FontWeight.normal),),)
                  ],),
                  ),],),
            )
            ),
                SizedBox(height: 10.0,),
              Container(height: 80,child:
              Card(child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 10.0,),
                  Row(children: [
                    SizedBox(width: 20,),

                    if(counts.length!=0)
                Expanded(flex: 8,child:

                Text(getcriticalcount(counts[2].toString()),style: TextStyle(color:common.getColorFromHex('#ffb976'), fontSize: 18.0,fontFamily: GoogleFonts.montserrat().fontFamily,fontWeight: FontWeight.bold),),
                ),                  Expanded(flex: 2,child:                   SvgPicture.string('''	<svg xmlns="http://www.w3.org/2000/svg" width="21px" height="21px" viewBox="0 0 24 24" fill="none" stroke="#ffb976" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-aperture">
    <circle color="#28c76f" cx="12" cy="12" r="10"></circle>
    <line color="#28c76f" x1="14.31" y1="8" x2="20.05" y2="17.94"></line>
    <line color="#28c76f" x1="9.69" y1="8" x2="21.17" y2="8"></line>
    <line color="#28c76f" x1="7.38" y1="12" x2="13.12" y2="2.06"></line>
    <line color="#28c76f" x1="9.69" y1="16" x2="3.95" y2="6.06"></line>
    <line color="#28c76f" x1="14.31" y1="16" x2="2.83" y2="16"></line>
    <line color="#28c76f" x1="16.62" y1="12" x2="10.88" y2="21.94"></line>
</svg>''')
                    )                        ],),

                  SizedBox(height: 10,),
                          Expanded(child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0),child:

                          Text('Total Critical Ticket',style: TextStyle( height:.7,fontSize: 16.0,fontFamily: GoogleFonts.montserrat().fontFamily,fontWeight: FontWeight.normal),)
              ),],),


          ),],),
      )
    ),

              SizedBox(height: 10.0,),
              Container(height: 80,child:
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[


                        SizedBox(height: 10.0,),
                        Row(children: [
                          SizedBox(width: 20,),
                  if(counts.length!=0)

                  Expanded(flex: 8,child:
                            Text(getcriticalcount(counts[1].toString()),style: TextStyle(color: common.getColorFromHex('#f08182'), fontSize: 18.0,fontFamily: GoogleFonts.montserrat().fontFamily,fontWeight: FontWeight.bold),),),
Expanded(flex: 2,child:
                          SvgPicture.string('''<svg xmlns="http://www.w3.org/2000/svg" width="21px" height="21px" viewBox="0 0 24 24" fill="none" stroke="#f08182" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-codesandbox">
    <path color="#ea5455" d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>
    <polyline color="#ea5455" points="7.5 4.21 12 6.81 16.5 4.21"></polyline>
    <polyline color="#ea5455" points="7.5 19.79 7.5 14.6 3 12"></polyline>
    <polyline color="#ea5455" points="21 12 16.5 14.6 16.5 19.79"></polyline>
    <polyline color="#ea5455" points="3.27 6.96 12 12.01 20.73 6.96"></polyline>
    <line color="#ea5455" x1="12" y1="22.08" x2="12" y2="12"></line>
</svg>''')),

                        ],),
                        SizedBox(height: 10,),

                        Expanded(  child:
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0),child:
  Text('Total Medium Ticket',softWrap: false, style: TextStyle(height:.7,fontSize: 16.0,fontFamily: GoogleFonts.montserrat().fontFamily,fontWeight: FontWeight.normal),)
)],),


              ),],),
                      )
                 ),//),
              SizedBox(height: 10.0,),
                if(role!="AI")
              Container(height: 80,child:
              Card(child: Column(

                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 10.0,),
                  Row(

                      children: <Widget>[
                        SizedBox(width: 20.0,),
                        if(counts.length!=0)
                Expanded(flex: 8,child:

                Text(getcriticalcount(counts[3].toString()),style: TextStyle(fontSize: 18.0,fontFamily: GoogleFonts.montserrat().fontFamily,fontWeight: FontWeight.bold,color: getColorFromHex('#48da89')),),
                ),
                        Expanded(flex: 2,child:
    SvgPicture.string('''<svg xmlns="http://www.w3.org/2000/svg" width="21px" height="21px" viewBox="0 0 24 24" fill="none" stroke="#48da89" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-zap">
<polygon color="##ff9f43" points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>''')
    ),
                      ],),
                  SizedBox(height: 10,),
                  Expanded(child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0),child:
  Text('Total Ticket',style: TextStyle(height:.7,fontSize: 16.0,fontFamily: GoogleFonts.montserrat().fontFamily,fontWeight: FontWeight.normal),),),]),




      ),],),
    )
    ),


                if(role=="AI")
                Container(height: 80,child:
                Card(child: Column(

                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 10.0,),

                  Row(
                    children: <Widget>[
                SizedBox(width: 20,),
                if(counts.length!=0)
                Expanded(flex: 8,child:
                Text(getcriticalcount(lowcounts.toString()),style: TextStyle(fontSize: 18.0,fontFamily: GoogleFonts.montserrat().fontFamily,fontWeight: FontWeight.bold,color: getColorFromHex('#48da89')),),
                ),
                Expanded(flex: 2,child:
                SvgPicture.string('''<svg xmlns="http://www.w3.org/2000/svg" width="21px" height="21px" viewBox="0 0 24 24" fill="none" stroke="#48da89" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-zap">
<polygon color="##ff9f43" points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>''')
                ),
                ],),
SizedBox(height: 10,),
                Expanded(child:
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0),child:
                Text('Total Low Ticket',style: TextStyle(height:.7,fontSize: 16.0,fontFamily: GoogleFonts.montserrat().fontFamily,fontWeight: FontWeight.normal),),),]),




                ),],),
                )
                ),

    ]),
              Column(            mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0,),
                  Container(
                    child:
                    Card(

                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10,),
                                Text('Last 5 Sos Tickets',style: TextStyle(fontSize: 20.0,fontFamily: GoogleFonts.montserrat().fontFamily,fontWeight: FontWeight.normal),),
                              ],),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(30,10,10,10),child:
                          Row(

                            children: [
                              Expanded(flex: 2,
                                child:

                                Text('Ticket',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,fontFamily: GoogleFonts.nunito().fontFamily),),),
                              SizedBox(width: 5,),
                              Expanded(flex: 3,
                                  child:
                                  Text('Detail',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,fontFamily: GoogleFonts.nunito().fontFamily),)),
                              SizedBox(width: 5,),
                              Expanded(flex: 2,
                                  child:
                                  Text('Opened At',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,fontFamily: GoogleFonts.nunito().fontFamily),)),

                            ],
                          ),),
                          if(soslist.length!=0)
                          Padding(padding: EdgeInsets.fromLTRB(30,10,10,10),child:
    ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
    itemCount: soslist.length,
    itemBuilder: (context, index) {
      return
      Column(children: [
        Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5),child:
                          Row(

                            children: [
                              Expanded(flex: 2,
                                   child:
                                   Text(soslist[index]['TicketId'].toString(),style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14.0,fontFamily: GoogleFonts.nunito().fontFamily),),),
                              SizedBox(width: 5,),
                              Expanded(flex: 3,
                                  child:
                                  Text(soslist[index]['Ticket'].toString(),style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14.0,fontFamily: GoogleFonts.nunito().fontFamily),)),
                              SizedBox(width: 5,),
                              Expanded(flex: 2,
                                  child:
                                  Text(soslist[index]['Opened At'].toString(),style:
                                  TextStyle(fontWeight: FontWeight.normal,fontSize: 14.0,fontFamily: GoogleFonts.nunito().fontFamily),)),
                              SizedBox(height: 5,)

                            ],
                          ),),
      SizedBox(height: 5,)]);
        })
                          ),
                       ],
                      ),),),

                ],),
              Column(            mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0,),
                  Container(
                    child:
                    Card(

                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10,),
                                Text('Last 5 Critical Tickets',style: TextStyle(fontSize: 20.0,fontFamily: GoogleFonts.montserrat().fontFamily,fontWeight: FontWeight.normal),),
                              ],),
                          ),

                          Padding(padding: EdgeInsets.fromLTRB(30,10,10,10),child:
                          Row(

                            children: [
                              Expanded(flex: 2,
                                child:

                                Text('Ticket',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,fontFamily: GoogleFonts.nunito().fontFamily),),),
                              SizedBox(width: 5,),
                              Expanded(flex: 3,
                                  child:
                                  Text('Detail',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,fontFamily: GoogleFonts.nunito().fontFamily),)),
                              SizedBox(width: 5,),
                              Expanded(flex: 2,
                                  child:
                                  Text('Opened At',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,fontFamily: GoogleFonts.nunito().fontFamily),)),

                            ],
                          ),),
                          if(criticallist.length!=0)
                          Padding(padding: EdgeInsets.fromLTRB(30,10,10,10),child:
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                              itemCount: criticallist.length,
                              itemBuilder: (context, index) {
                                return
                                  Column(children: [
                                    Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5),child:
                                    Row(

                                      children: [
                                        Expanded(flex: 2,

                                          child:

                                          Text(criticallist[index]['TicketId'].toString(),style: TextStyle(   fontWeight: FontWeight.normal,fontSize: 14.0,fontFamily: GoogleFonts.nunito().fontFamily),),),

                                      SizedBox(width: 5,),
                                        Expanded(flex: 3,
                                            child:
                                            Text(criticallist[index]['Ticket'].toString(),style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14.0,fontFamily: GoogleFonts.nunito().fontFamily),)),
                                        SizedBox(width: 5,),
                                        Expanded(flex: 2,
                                            child:
                                            Text(criticallist[index]['Opened At'].toString(),style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14.0,fontFamily: GoogleFonts.nunito().fontFamily),)),
                                        SizedBox(height: 5,)

                                      ],
                                    ),
                                    ),
                             /*       Align(
                                        alignment: Alignment.topRight,
                                        child:      Padding(padding: EdgeInsets.fromLTRB(0, 0, 20, 0),child:
                                Text(criticallist[index]['Opened At'].toString(),style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14.0,fontFamily: GoogleFonts.nunito().fontFamily),)),
                                    ),

                                    
*/
                                    SizedBox(height: 5,),
  /*                                  Divider(),
  */                                ]);


                              })

                          ),

                        ],
                      ),),),

                ],),
              if(role=="AI")
              Column(            mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0,),
                  Container(
                    child:
                    Card(

                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10,),
                                Text('Last 5 Low Tickets',style: TextStyle(fontSize: 20.0,fontFamily: GoogleFonts.montserrat().fontFamily,fontWeight: FontWeight.normal),),
                              ],),
                          ),

                          Padding(padding: EdgeInsets.fromLTRB(30,10,10,10),child:
                          Row(

                            children: [
                              Expanded(flex: 2,
                                child:

                                Text('Ticket',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,fontFamily: GoogleFonts.nunito().fontFamily),),),
                              SizedBox(width: 5,),
                              Expanded(flex: 3,
                                  child:
                                  Text('Detail',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,fontFamily: GoogleFonts.nunito().fontFamily),)),
                              SizedBox(width: 5,),
                              Expanded(flex: 2,
                                  child:
                                  Text('Opened At',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,fontFamily: GoogleFonts.nunito().fontFamily),)),

                            ],
                          ),),
                          if(criticallist.length!=0)
                            Padding(padding: EdgeInsets.fromLTRB(30,10,10,10),child:
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: lowlist.length,
                                itemBuilder: (context, index) {
                                  return
                                    Column(children: [
                                      Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5),child:
                                      Row(

                                        children: [
                                          Expanded(flex: 2,
                                            child:
                                            Text(lowlist[index]['TicketId'].toString(),style: TextStyle(   fontWeight: FontWeight.normal,fontSize: 14.0,fontFamily: GoogleFonts.nunito().fontFamily),),),

                                          SizedBox(width: 5,),
                                          Expanded(flex: 3,
                                              child:
                                              Text(lowlist[index]['Ticket'].toString(),style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14.0,fontFamily: GoogleFonts.nunito().fontFamily),)),
                                          SizedBox(width: 5,),
                                          Expanded(flex: 2,
                                              child:
                                              Text(lowlist[index]['Opened At'].toString(),style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14.0,fontFamily: GoogleFonts.nunito().fontFamily),)),
                                          SizedBox(height: 5,)

                                        ],
                                      ),),
                                      SizedBox(height: 5,)]);
                                })
                            ),

                        ],
                      ),),),

                ],),
            ],)),)

          ],))]));
  }
  void _singularlist() async{
      List sitedetails=(await httpreq.getdata(Glob().getsitedetails()+Glob().sites[0]['SiteId'].toString(),prefs.getString('token'),context)) as List;

      if(sitedetails.length!=0||sitedetails!=null) {
        common.showloading(context);
        List sensordetails = (await httpreq.getdata(
            Glob().getsensordetails() + Glob().sites[0]['SiteName'].toString(),
            prefs.getString('token'),context)) as List;
        List attendednce = (await httpreq.getdata(Glob().getattendencedeatils() +
            Glob().sites[0]['SiteName'].toString(),
            prefs.getString('token'),context)) as List;
        List contact = (await httpreq.getdata(
            Glob().getcontactdetails() + Glob().sites[0]['SiteName'].toString(),
            prefs.getString('token'),context)) as List;
        List appliance = (await httpreq.getdata(
            Glob().getappliance() + Glob().sites[0]['SiteName'].toString(),
            prefs.getString('token'),context)) as List;
List sitestatus= (await httpreq.getdata(
    Glob().getsitestatus() + Glob().sites[0]['SiteName'].toString(),
    prefs.getString('token'),context)) as List;
        List counts= (await httpreq.getdata(
            Glob().getsitetcktcount() + Glob().sites[0]['SiteName'].toString()+"/"+Glob().Userrole,
            prefs.getString('token'),context)) as List;

        common.Stoploading(context);
        common.navigateToSubPage(
            context, SingluarView(sitedetails, sensordetails, attendednce, contact,appliance,sitestatus,counts));
      }else{
        common.showAlert(context, 'Please enter correct Site ID');
      }
    }

    void _bulgaryreport() async{
      var bulg= (await httpreq.getdata(
          Glob().getincidentdetails() ,
          prefs.getString('token'),context));
      print(bulg);
      Navigator.pop(context);

      common.navigateToSubPage(context, Bulgary(bulg));
    }

  void _Cameraageing() async {

/*
    var camera= (await httpreq.getdata(
        Glob().getcameraageing() + "/" + prefs.getString('bankcode'),
        prefs.getString('token'),context));
    print(camera);
*/
    Navigator.pop(context);

    common.navigateToSubPage(context, CameraAgeing());
  }
  void _ticketlist() async{
    sitename.clear();

    sitecount = (await httpreq.getdata(
        Glob().getCameraDetails() + "/" + prefs.getString('bankcode'),
        prefs.getString('token'),context));
    for (int i = 0; i < sitecount.length; i++) {
      sitename.add(sitecount[i]['SiteName']);
      String outdoorde = sitecount[i]['OutdoorCamera'] != "" ? 'Outdoor' : '';
      String lobbyde = sitecount[i]['LobbyCamera'] != "" ? 'Lobby' : '';
      String backroomde = sitecount[i]['BackroomCamera'] != ""
          ? 'Backroom'
          : '';
      String pinholede = sitecount[i]['PinholeCamera'] != "" ? 'pinhole' : '';
      if (outdoorde != "" && lobbyde != "" && backroomde != "" &&
          pinholede != "") {
        allcameras = true;
        nopinhole = false;
        nobackroom = false;
      }
      else if (outdoorde != "" && lobbyde != "" && backroomde != "" &&
          pinholede == "") {
        nopinhole = true;
        allcameras = false;
        nobackroom = false;
      }
      else if (outdoorde != "" && lobbyde != "" && backroomde == "" &&
          pinholede != "") {
        nobackroom = true;
        allcameras = false;
        nopinhole = false;
      }
      if (allcameras) {
        cameradetails.add('all');
      }
      else if (nopinhole) {
        cameradetails.add('pin');
      }
      else if (nobackroom) {
        cameradetails.add("back");
      }
    }

    common.navigateToSubPage(context, VideoPage(sitename));
  }

}
