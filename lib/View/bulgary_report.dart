

import 'dart:collection';
import 'dart:math';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innlite_mobile/Common/http_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/api_url.dart';
import '../Common/common_dart.dart';
import '../Common/utils.dart';
String _chosedincident="";
TextEditingController fromdate = TextEditingController();
TextEditingController todate = TextEditingController();
DateTime currentDate = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();
DataTableSource _data;
DateTime frm,to,pickedfrm;
List<dynamic>  incidentdet,incilist=[];
List<dynamic> selectedatmid;
final httpreq = HttpRequest();
final common= Common();
TextEditingController Siteidcontroller= TextEditingController();
List<dynamic> _foundUsers = [];
SharedPreferences prefs;
List bulgaryreport;
bool showtable;
List<String> inciden;
class MyData extends DataTableSource {
  // Generate some made-up data
  final List<Map<String, dynamic>> _data = List.generate(
      bulgaryreport.length,
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
    if(bulgaryreport!=null)
    return DataRow(cells: [
      DataCell(Text(bulgaryreport[index]['TicketId'].toString())),
      DataCell(Text(bulgaryreport[index]["SiteName"])),
      DataCell(Text(bulgaryreport[index]["Msg"].toString())),
      DataCell(Text(bulgaryreport[index]["EventType"].toString())),
      DataCell(Text(bulgaryreport[index]["ClosedOn"].toString())),

      DataCell (Text(bulgaryreport[index]["ClosingReason"].toString())),

    ]);
  }
}
class Bulgary extends StatefulWidget {
  @override

  List incidentdeatils;


  Bulgary(this.incidentdeatils);

  _BulgaryReport createState() => _BulgaryReport();
}

class _BulgaryReport extends State<Bulgary> {
  void initState()  {
    currentDate= DateTime.now();
    super.initState();
    incidentdet=widget.incidentdeatils;
    for (int i=0;i<incidentdet.length;i++){
      String jj= incidentdet[i].toString();
      String j= jj.toString().substring(1,jj.length-1);
      var incilt = j.split(":");
      incilist.add(incilt[1]);
    }
    _chosedincident= incilist[0];
   // print(incidentdet[0]);
    getsharedprefence();

  }

  Future<bool> getsharedprefence() async {
    prefs = await SharedPreferences.getInstance();
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
  Future callurl() async{

  /*  if(selectedatmid==null){
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
      String valu;
      if(selectedatmid!=null)
       selec = selectedatmid.cast<String>();
      Map<String, dynamic> credentials = {
        "Todate": todate.text,
        "Fromdate": fromdate.text,
        "Bankcode": prefs.getString('bankcode'),
        "Incident": _chosedincident.trim(),
        "SiteName": selec
      };

      print(credentials);
      bulgaryreport = (await httpreq.postdata(
          Glob().getincidentreport(), credentials, ''));

      common.Stoploading(context);
      if (bulgaryreport.length == 0) {
        common.showAlert(context, "No data found");
        showtable=false;
      }
      else {
        setState(() {
          showtable=true;
          _data = MyData();
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Burglary"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child:
          Padding(padding: EdgeInsets.all(10.0), child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
            Text('Incident Category'),
              SizedBox(height: 5,),
            if(incilist.length!=0)
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
                        value: _chosedincident,
                        //elevation: 5,
                        style: TextStyle(color: Colors.white),
                        iconEnabledColor:Colors.black,
                        items: incilist.toSet().toList().cast<String>().map<DropdownMenuItem<String>>((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item,style:TextStyle(color:Colors.black),),
                          );
                        })?.toList(),
                        hint: Text(
                          incilist[0].toString(),
                          style:
                          TextStyle(color: Color(0xFF8B8B8B), fontSize: 15),
                        ),

                        onChanged: (String value) {
                          setState(() {
                            _chosedincident = value;
                          });
                        },
                      ),
                    )),
              ),
            ),
            SizedBox(height: 10,),
            getCustomButton(labeltext: 'Generate Report',onpressed:(){callurl(); }),
            if( bulgaryreport!=null && showtable )
            Container(child:
            PaginatedDataTable(
              source: _data,
              header: const Text('Closed Ticket'),
              columns: const [
                DataColumn(label: Text('Ticket Id')),
                DataColumn(label: Text('Site Name')),
                DataColumn(label: Text('Message')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Closed On')),
                DataColumn(label: Text('Closing Reason')),

              ],
              columnSpacing: 20,
              horizontalMargin: 10,
              rowsPerPage: bulgaryreport.length<50 ? bulgaryreport.length:50,
              showCheckboxColumn: false,
            ),),
            ],)),),
    );
  }
  @override
  void dispose() {
    fromdate.text="";
    todate.text="";
    bulgaryreport=null;
    currentDate=null;
    super.dispose();
  }
}