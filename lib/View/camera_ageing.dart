import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innlite_mobile/Common/api_url.dart';
import 'package:innlite_mobile/Common/common_dart.dart';
import 'package:innlite_mobile/Common/http_request.dart';
import 'package:innlite_mobile/Common/utils.dart';
import 'package:innlite_mobile/View/singular_view.dart';
import 'package:innlite_mobile/View/livestreaming.dart';

import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global_page.dart';
 DataTableSource _data;
List camerareport;
TextEditingController fromdate = TextEditingController();
TextEditingController todate = TextEditingController();
DateTime currentDate = DateTime.now();
DateTime frm,to,pickedfrm;
class MyCameradetails extends DataTableSource {
  // Generate some made-up data
  final List<Map<String, dynamic>> _data = List.generate(
      camerareport.length,
          (index) => {
      });

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(camerareport[index]['Sitename'].toString())),
      DataCell(Text(camerareport[index]["Siteadress"])),
      DataCell(Text(camerareport[index]["Outdoor Camera"].toString())),
      DataCell(Text(camerareport[index]["Lobby Camera"].toString())),
      DataCell(Text(camerareport[index]["Backroom Camera"].toString())),
      DataCell(Text(camerareport[index]["Pinhole Camera"].toString())),

    ]);
  }
}
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
List<dynamic> selectedatmid=[];
final httpreq = HttpRequest();
// stores ExpansionPanel state information
List<dynamic> _foundsites = [];
bool showtable=false;
/// This is the stateful widget that the main application instantiates.
class CameraAgeing extends StatefulWidget {
  @override
  List sitedeatils, sensordetails, attendence, contact;
  String role;
  CameraAgeing();
  _CameraDetails createState() => _CameraDetails();
}

class _CameraDetails extends State<CameraAgeing>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    getsharedprefence();
    super.initState();
  }
  Future<bool> getsharedprefence() async {
    prefs = await SharedPreferences.getInstance();
  }
  Future callurl() async{

/*    if(selectedatmid==null){
      common.showAlert(context, "Select ATM Id");
    }
    else*/ if(fromdate.text==""){
      common.showAlert(context, "Select from date");
    }
    else if(todate.text==""){
      common.showAlert(context, "Select to date");
    }

    else {
      common.showloading(context);
      List<String> selec=[];
      if(selectedatmid!=null)
       selec = selectedatmid.cast<String>();
      Map<String, dynamic> credentials = {
        "Todate": todate.text,
        "Fromdate": fromdate.text,
        "Bankcode": prefs.getString('bankcode'),
          "SiteName":  selec,
      };

      print(credentials);
      camerareport = (await httpreq.postdata(
          Glob().getcameraageing(), credentials, ''));

      common.Stoploading(context);
      if (camerareport.length == 0) {
        common.showAlert(context, "No data found");
        showtable=false;
      }
      else {
        setState(() {
          showtable=true;
          _data = MyCameradetails();
        });
      }
    }
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
          user["Sitename"].toString().toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      if(enteredKeyword.length>=5) {
        _foundsites = results;
        if(_foundsites.length!=0)
          sitedetails = _foundsites;

      }
      else {
        _foundsites.clear();
        sitedetails = sitedetails1;
      }
    });
  }
  Future<void> _selectDate(BuildContext context,String from) async {
    final date = DateTime.now();
    final DateTime pickedDate =
    await showDatePicker(
        context: context,
        initialDate:from.toLowerCase()=="to"? currentDate:DateTime.now(),
        firstDate: from.toLowerCase()=="from"?DateTime(date.year, date.month , date.day+(-120)):pickedfrm,
        lastDate: date);
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        if (from == "from") {
          frm = pickedDate;
          pickedfrm= pickedDate;
          var date = DateTime.parse(pickedDate.toString());
          var formattedDate = "${date.year.toString()}-${date.month.toString().padLeft(2,"0")}-${date.day.toString().padLeft(2,"0")}";

          print (formattedDate);

          fromdate.text = formattedDate;
          if(todate.text=="")
            todate.text = formattedDate;
        }
        else  if (from == "to") {
          frm = pickedDate;
          var date = DateTime.parse(pickedDate.toString());
          var formattedDate = "${date.year.toString()}-${date.month.toString().padLeft(2,"0")}-${date.day.toString().padLeft(2,"0")}";
          print (formattedDate);
          todate.text = formattedDate;
        }
      });
    }
  }
  bool value = false;
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    yourWidth = width * 0.70;
    if(_foundsites.length==0)
      _foundsites.clear();


    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: common.getColorFromHex('#F7F7F7'),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
           "Camera Ageing",
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.nunito().fontFamily),
          ),
        ),
        body:
SingleChildScrollView(child:
        Column(children: [
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    SizedBox(height: 10,),
                      MultiSelect(
              //--------customization selection modal-----------
                buttonBarColor: Colors.white,
                cancelButtonText: "Exit",
                saveButtonText: 'Submit',
                clearButtonColor: Colors.grey,
                titleText: "ATM Id",
                checkBoxColor: Colors.black,
                selectedOptionsInfoText: "(tap to remove)",
                selectedOptionsBoxColor: Colors.white,
                maxLength: 10,
                // optional
                //--------end customization selection modal------------
                validator: (dynamic value) {
                  if (value == null) {
                    return 'Please select one or more option(s)';
                  }
                  return null;
                },
                errorText: 'Please select one or more option(s)',
                dataSource: Glob().sites,
                textField: 'SiteName',
                valueField: 'SiteName',
                filterable: true,
                required: true,

                onSaved: (value) {
                  selectedatmid = value ;

                },
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
                    Column(children: [

                      GestureDetector(
                        child:
                        TextField(
                            controller: todate,
                            enabled: false,
                            decoration: InputDecoration(
                                fillColor: Colors.black.withOpacity(0.1),
                                filled: true,
                                prefixIcon: Icon(Icons.calendar_today_sharp),
                                hintText: 'To',
                                hintStyle: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.zero
                            )),onTap: ()=> _selectDate(context,"to"), ),

                    ],),
                    SizedBox(height: 10,),
                    getCustomButton(labeltext: 'Generate Report',onpressed:(){callurl(); }),

                    if( camerareport!=null && showtable )
                    Container(
                        padding: EdgeInsets.all(5),
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
                                  Container(child:
                                  PaginatedDataTable(
                                    source: _data,
                                    columns: const [
                                      DataColumn(label: Text('Atm Id')),
                                      DataColumn(label: Text('Site Address')),
                                      DataColumn(label: Text('Outdoor Camera')),
                                      DataColumn(label: Text('Lobby Camera')),
                                      DataColumn(label: Text('Backroom Camera')),
                                      DataColumn(label: Text('Pinhole Camera')),
                                    ],
                                    columnSpacing: 20,
                                    horizontalMargin: 10,
                                    rowsPerPage: camerareport.length<50 ? camerareport.length:50,
                                    showCheckboxColumn: false,
                                  ),),
                                ]),
                          ),
                        )),

                  ]))
        ])));
  }


  @override
  void dispose() {


      fromdate.text="";
      todate.text="";
      currentDate=null;
      showtable=false;
 _foundsites.clear();
 camerareport.clear();
    sitedetails.clear();
    searchController.clear();
    searchController.text="";
    super.dispose();
  }
}
