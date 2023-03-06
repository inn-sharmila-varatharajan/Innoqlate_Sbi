import 'dart:async';
import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innlite_mobile/Common/api_url.dart';
import 'package:innlite_mobile/Common/common_dart.dart';
import 'package:innlite_mobile/Common/http_request.dart';
import 'package:innlite_mobile/Common/utils.dart';
import 'package:innlite_mobile/View/video_player.dart';
import 'package:innlite_mobile/View/storedvideo_player.dart';

import 'package:shared_preferences/shared_preferences.dart';
String _chosensitename="",_chosenallcamera="Outdoor",_chosenpincamera="Pinhole",_chosenbackcamera="Backroom";

String videourl;
List<String> sitename= [],cameradetails=[],cameravalue=[];
List storedvideos=[];
bool allcameras=false,allcamerason=false,nopinhole=false,nobackroom=false,nopinholeon=false,nobackroomon=false;
List<siteValues> sitelist = List<siteValues>();
DateTime frm,to;
String _chosedfilename = "",cameraid;
SharedPreferences prefs ;
TextEditingController fromdate = TextEditingController();
TextEditingController fromtime = TextEditingController();
TextEditingController totime = TextEditingController();
List<String> allcam = ['Outdoor',"Lobby","Backroom","Pinhole"];
List<String> pincam = ['Outdoor',"Lobby","Backroom"];
List<String> backcam = ['Outdoor',"Lobby","Pinhole"];
final httpreq= HttpRequest();
final common= Common();
List<dynamic> _foundUsers = [];
Timer _timer;
TextEditingController Siteidcontroller= TextEditingController();
DateTime currentDate = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();
class VideoPage extends StatefulWidget {

  @override
  final List<String> sitename;
  VideoPage(this.sitename);
  _Videopage createState() => _Videopage();

}
Future<bool> getsharedprefence() async {
  prefs = await SharedPreferences.getInstance();
}



class _Videopage extends State<VideoPage> {
  @override
  bool checkvalue = false;
  void initState() {
    super.initState();
    cameradetails.clear();
    storedvideos.clear();
    getsharedprefence();
    setState(() {

      sitename =widget.sitename.toSet().toList();

     _chosensitename= sitename[0];

    });
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

  Future<void> _selectDate(BuildContext context,String from) async {
    final date = DateTime.now();
    currentDate=date;
    final DateTime pickedDate =
    await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(date.year, date.month , date.day+(-120)),
        lastDate: date);
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        if (from == "from") {
          frm = pickedDate;
          var date = DateTime.parse(pickedDate.toString());
          var formattedDate = "${date.day.toString().padLeft(2,"0")}-${date.month.toString().padLeft(2,"0")}-${date.year}";

          print (formattedDate);

          fromdate.text = formattedDate;
        }
      });
    }
  }
  _selectTime(BuildContext context,String from) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if(timeOfDay != null )
    {
      setState(() {
        selectedTime = timeOfDay;
        if(from=="from") {
          fromtime.text = selectedTime.hour.toString().padLeft(2,"0")+":"+selectedTime.minute.toString().padLeft(2,"0");
        }
        else
          totime.text= selectedTime.hour.toString().padLeft(2,"0")+":"+selectedTime.minute.toString().padLeft(2,"0");
      });
    }

  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.height;


    return
      Scaffold(
  resizeToAvoidBottomInset: false,
  appBar: AppBar(title: Text('Stored Video',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.nunito().fontFamily),),
    centerTitle: true,),
  body:
SingleChildScrollView(child:
      Padding(padding: EdgeInsets.fromLTRB(10,0,10,0),child:
  Column(
    children: <Widget>[
      SizedBox(height: 10,),
      Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),child:
      Container(
        decoration: BoxDecoration(  color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3)),
          border: Border.all(color:getColorFromHex('8D8D8D'),width: 2.0),),
        child:

        Padding(padding: EdgeInsets.fromLTRB(10,0,10,0),child:
        TextField(
          onChanged: (value) => _runFilter(value),
          controller: Siteidcontroller,
          decoration: const InputDecoration(
              labelText: 'ATM Id' ,
              suffixIcon: Icon(Icons.search)),
        ),),),),

    if(_foundUsers.length!=0)


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
                    Siteidcontroller.text=_foundUsers[index]['SiteName'].toString();
                    setState(() {
                      _foundUsers.clear();

                    });
                  },
                  child:
                  Column(children: [
                    Padding(padding: EdgeInsets.fromLTRB(20,0,0,0),child:
                    Text(_foundUsers[index]['SiteName'].toString(),style: TextStyle(fontSize: 16),),),
                  ],),), Divider(thickness: 2,)                      ],


            ),
      )
        : const Text(
    'No results found',
    style: TextStyle(fontSize: 24),
    ),
    ],),

    SizedBox(height: 10,),
        Padding(
        padding: const EdgeInsets.only(
            left: 0, right: 0, bottom: 0, top: 0),
        child:
        Container(
          height: 45,
          //gives the height of the dropdown button
          width: MediaQuery.of(context).size.width,
          //gives the width of the dropdown button
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(3)),
            border: Border.all(color:getColorFromHex('8D8D8D'),width: 2.0),

          ),
          // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
          child: Theme(
              data: Theme.of(context).copyWith(
                  canvasColor: getColorFromHex('8D8D8D'),
                  // background color for the dropdown items
                  buttonTheme: ButtonTheme.of(context).copyWith(
                    alignedDropdown:
                    true, //If false (the default), then the dropdown's menu will be wider than its button.
                  )),
              child: DropdownButtonHideUnderline(
                // to hide the default underline of the dropdown button
                child: DropdownButton<String>(
                  focusColor:Colors.white,
                  value: _chosenallcamera,
                  //elevation: 5,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor:Colors.black,
                  items: allcam.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style:TextStyle(color:Colors.black),),
                    );
                  })?.toList(),

                  hint: Text(
                    'Outdoor',
                    style:
                    TextStyle(color: Color(0xFF8B8B8B), fontSize: 15),

                  ),

                  onChanged: (String value) {
                    setState(() {
                      _chosenallcamera = value;
                    });
                  },
                ),
              )),
        ),
      ),

      SizedBox(height: 10,),
Column(children: [

  GestureDetector(
    child:
    TextField(
        controller: fromdate,
        enabled: false,
        decoration: InputDecoration(
            fillColor: Colors.black.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.calendar_today_sharp),
            hintText: 'From',
            hintStyle: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: EdgeInsets.zero
        )),onTap: ()=> _selectDate(context,"from"), ),

],),
      SizedBox(height: 10,),
      Row(children: [

        Expanded(flex:5,
          child:
          GestureDetector(
            child:
            TextField(
                controller:fromtime ,
                enabled: false,
                decoration: InputDecoration(
                    fillColor: Colors.black.withOpacity(0.1),
                    filled: true,
                    prefixIcon: Icon(Icons.timer),
                    hintText: 'From Time',
                    hintStyle: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.zero
                )),onTap: ()=> _selectTime(context,"from"), ),),
        SizedBox(width: 10,),
        Expanded(flex:5,
          child:
          GestureDetector(
            child:
            TextField(
                controller:totime ,
                enabled: false,
                decoration: InputDecoration(
                    fillColor: Colors.black.withOpacity(0.1),
                    filled: true,
                    prefixIcon: Icon(Icons.timer),
                    hintText: 'To Time',
                    hintStyle: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.zero
                )),onTap: ()=> _selectTime(context,"to"), ),),
      ],),
getCustomButton(labeltext: 'Submit',onpressed:(){ CallUrl(false);}),
      SizedBox(height: 20,),
      if(storedvideos.length!=0)
Container(

        child:
      ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: storedvideos.length,
          itemBuilder: (context, index) {
            return Column(children: [
              Row(children: [
              Expanded(flex:8,child:
              getbodyText(labeltext:storedvideos[index]['Filename'].toString(),fontsize: 16.0,weight: FontWeight.normal),),

              
              Expanded(flex:2,child:
              GestureDetector(onTap:(){
                _chosedfilename= storedvideos[index]['Filename'];
                CallVideo();
                },
                child:  SvgPicture.string('''<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24" fill="none" stroke="#00cfe8" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-eye"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>''')
                ,
              ),),

            ]),
            Divider(),
            ],);

          }),),


    ],
  ),),),

);
  }


Future CallVideo() async{

  Map<String,dynamic> credentials = {
    "Date": fromdate.text,
    "CameraId": cameraid,
    "SiteName": Siteidcontroller.text,
    "FileNames":[_chosedfilename]
  };
  common.showloading(context);
 var result = (await httpreq.postdata(
      Glob().getVideoDownload(), credentials, ''));

    if(result!=""){
      Timer(Duration(seconds: 10), () =>
      {
        CallUrl(true),
        common.Stoploading(context),
      });
    }
}

Future CallUrl(bool callvideo) async{
    storedvideos.clear();
    if(_chosensitename==""){
      common.showAlert(context, 'Select Site');
    }
    else  if(fromdate.text==""){
      common.showAlert(context,'Select date');
    }
    else  if(fromtime.text==""){
      common.showAlert(context,'Select from time');
    }
    else  if(totime.text==""){
      common.showAlert(context,'Select to time');
    }
    else {
      common.showloading(context);

/*
      if(_chosenallcamera!=""){
        _chosedcamera=_chosenallcamera;
      }
      else if(_chosenbackcamera!=""){
        _chosedcamera =_chosenbackcamera;
      }
      else if(_chosenpincamera!=""){
        _chosedcamera =_chosenpincamera;
      }
*/
      if(_chosenallcamera=="Outdoor") cameraid="0701";
      else if(_chosenallcamera=="Backroom") cameraid="0703";
      else if(_chosenallcamera=="Lobby") cameraid="0702";
      else if(_chosenallcamera=="Pinhole") cameraid="0704";
      Map<String, String> credentials = {
        "Date": fromdate.text,
        "CameraId": cameraid,
        "SiteName": Siteidcontroller.text,
        "FromTime": fromtime.text,
        "ToTime": totime.text,
        "UserId": prefs.getString('username'),
      };
      storedvideos = (await httpreq.postdata(
          Glob().getVideoDetails(), credentials, ''));
    //  print(storedvideos);
      common.Stoploading(context);
      setState(() {
        if(storedvideos.length==0){
          common.showAlert(context, "No Video Exists");

        }
        storedvideos = storedvideos;

if(callvideo){

    for (int i = 0; i < storedvideos.length; i++) {
      String filename = storedvideos[i]['Filename'];
      if (_chosedfilename == filename) {
        var filevboxid;
        var hh= storedvideos[i]['VideoStatus'];

        if(hh=="1"||hh=="0") {
          filevboxid = filename.split("_");
          var date = fromdate.text.split("-");
         String date1 =date[2]+date[1]+date[0];
          String url = 'https://ncrsbiinnoculate.aparinnosys.com/View/VideoStorage/' +
              filevboxid[0] + "/" + date1 + '/' + cameraid + '/' +
              filename;

          videourl = url;
          Glob().pickkedvideo=videourl;
          common.navigateToSubPage(context, FlickPlayer());
        }
      }

  }
}

      });
    }
  }




  @override
  void dispose() {
    super.dispose();
fromtime.text="";
totime.text="";
fromdate.text="";
    currentDate=null;
    Siteidcontroller.text="";
    storedvideos.clear();

  }




}
class siteValues {
   String OutdoorCamera;
   String LobbyCamera;
   String BackroomCamera;
   String PinholeCamera;

  siteValues({this.OutdoorCamera,this.LobbyCamera,this.BackroomCamera,this.PinholeCamera});

  factory siteValues.fromJson(Map<String, dynamic> json) {
    return new siteValues(
      OutdoorCamera: json['OutdoorCamera'],
      LobbyCamera: json['LobbyCamera'],
      BackroomCamera: json['BackroomCamera'],
      PinholeCamera: json['PinholeCamera'],
    );
  }
}