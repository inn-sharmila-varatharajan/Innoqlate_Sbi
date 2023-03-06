

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innlite_mobile/Common/api_url.dart';
import 'package:innlite_mobile/Common/common_dart.dart';
import 'package:innlite_mobile/Common/http_request.dart';
import 'package:innlite_mobile/View/singular_view.dart';
import 'package:innlite_mobile/View/site_details.dart';


import 'package:shared_preferences/shared_preferences.dart';
List<dynamic> searchresult = [];
List<dynamic> sitelist=[];
String _dropDownValue;
SharedPreferences prefs;
List<String> sitename= [];
final common= Common();
final httpreq= HttpRequest();
TextEditingController searchController=  TextEditingController();
class Globalsearch extends StatefulWidget{

  @override
  _GlobalData createState() => _GlobalData();

}



class _GlobalData extends State<Globalsearch> {
  List<dynamic> _foundSites = [];
  @override




  void initState() {
    _foundSites=Glob().sites;
    super.initState();
    getsharedprefence();

  }

  Future<bool> getsharedprefence() async {
    prefs = await SharedPreferences.getInstance();

    return false;
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
      _foundSites = results;
    });
  }

  Widget build(BuildContext context) {
    // TODO: implement build

    double width = MediaQuery
        .of(context)
        .size
        .width;
    double yourWidth = width * 0.45;

    return Row(children: [
      SizedBox(width: 5,),
      Container(
        width: yourWidth,
        child:

        Text('NCR-SBI', style: TextStyle(fontFamily: GoogleFonts
            .nunito()
            .fontFamily, fontWeight: FontWeight.bold, fontSize: 18.0,),),),
      Icon(Icons.arrow_upward,color: common.getColorFromHex('#48da89')),
      Stack(
        alignment: AlignmentDirectional.topStart,
        children: <Widget>[
SizedBox(width: 10,),


          new Container(
    alignment: AlignmentDirectional.topCenter,
            child: Column(children: [
SizedBox(width: 5,),
              GestureDetector(onTap:(){ showupsites("online");} ,child:
              new
            Text(Glob().totalonlinesite, style: TextStyle(fontFamily: GoogleFonts
                .nunito()
                .fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.white)),)
    ],),
            decoration: new BoxDecoration (
                borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                color: common.getColorFromHex('#48da89')
            ),
            padding: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          ),
        ],
      ),


      Icon(Icons.arrow_downward,color: common.getColorFromHex('#ea5455')),
      Stack(
        alignment: AlignmentDirectional.topStart,
        children: <Widget>[
          SizedBox(width: 10,),

          /*Container(width: 50,height: 50,
child:
    SvgPicture.string(
              '''<svg viewBox="0 0 24 24" width="24" height="24" stroke="#ea5455" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round" class="css-i6dzq1"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>'''),
    ),*/
          new Container(
            alignment: AlignmentDirectional.topCenter,
            child: Column(children: [
              SizedBox(width: 5,),
GestureDetector(onTap:(){showupsites("offline");},child:
              new
              Text(Glob().totalofflinesite, style: TextStyle(fontFamily: GoogleFonts
                  .nunito()
                  .fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white)),),
            ],),
            decoration: new BoxDecoration (
                borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                color: common.getColorFromHex('#ea5455')
            ),
            padding: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          ),
        ],
      ),
/*
    SvgPicture.string('''<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24" fill="none" stroke="black" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-list"><line x1="8" y1="6" x2="21" y2="6"></line><line x1="8" y1="12" x2="21" y2="12"></line><line x1="8" y1="18" x2="21" y2="18"></line><line x1="3" y1="6" x2="3.01" y2="6"></line><line x1="3" y1="12" x2="3.01" y2="12"></line><line x1="3" y1="18" x2="3.01" y2="18"></line></svg>''')
*/
    ]);


  }


  void  showupsites(String status) async{
    List onlinesite=[],offlinesite=[];
    common.showloading(context);
    var count = (await httpreq.getdata(Glob().getallsitesstatus()+"/"+prefs.getString('bankcode'),prefs.getString('token'),context));
  var  allsites= count[1];
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
    common.Stoploading(context);


    common.navigateToSubPage(context, SiteDeatils(status=="online"? onlinesite:offlinesite,prefs.getString('role')));
  }

  Widget _popupBody() {
    return Container(
      color: Colors.white.withOpacity(0.9),
      child:
      Column(children: [
        Align(
            alignment: Alignment.topRight,
            child: GestureDetector(onTap: (){
              searchController.text="";
              Navigator.pop(context);

            }, child:   Icon(Icons.close,color: Colors.black,),)

        ),
      TextField(
        onChanged: (value) => _runFilter(value),
        controller: searchController,
        decoration: const InputDecoration(
            labelText: 'ATM Id' ,
            suffixIcon: Icon(Icons.search)),
      ),
        SizedBox(height: 10,),
        Expanded(
          child: _foundSites.isNotEmpty
              ? ListView.builder(
            shrinkWrap: true,
            itemCount: _foundSites.length,
            itemBuilder: (context, index) =>
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        searchController.text=_foundSites[index]['SiteName'].toString();
                        setState(() {
                          _foundSites.clear();
                        });
                      },
                      child:
                      Text(_foundSites[index]['SiteName'].toString(),style: TextStyle(fontSize: 16),),),
                    Divider(thickness: 2,)
                  ],


                ),
          )
              : const Text(
            'No results found',
            style: TextStyle(fontSize: 24),
          ),
        ),

      ]),
    );
  }
}