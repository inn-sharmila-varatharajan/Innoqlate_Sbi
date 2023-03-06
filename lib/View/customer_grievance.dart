import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innlite_mobile/Common/api_url.dart';
import 'package:innlite_mobile/Common/common_dart.dart';
import 'package:innlite_mobile/Common/http_request.dart';
import 'package:innlite_mobile/Common/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
TextEditingController Siteidcontroller= TextEditingController();
TextEditingController complaintcontroller= TextEditingController();
Common common= Common();
final httpreq= HttpRequest();
String _chosenallcamera;
SharedPreferences prefs;
List<String> sensorList=[];

class Searchlist extends StatefulWidget {


  @override
  _Searchlist createState() => _Searchlist();
}

class _Searchlist extends State<Searchlist> {
  List<dynamic> _foundUsers = [];

  @override
  initState() {
    // at the beginning, all users are shown
    _foundUsers = [];
    super.initState();
    getsharedprefence();
  }
  Future<bool> getsharedprefence() async{
    prefs= await SharedPreferences.getInstance();
    return  false;
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = [];
    } else {
      results = Glob().sites
          .where((user) =>
          user["SiteName"].toString().toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Grievance'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child:
      Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
                decoration: BoxDecoration(  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  border: Border.all(color:getColorFromHex('8D8D8D'),width: 2.0),),
                child:

                Padding(padding: EdgeInsets.fromLTRB(15,0,0,0),child:
            TextField(
              onChanged: (value) => _runFilter(value),
              controller: Siteidcontroller,
              decoration: const InputDecoration(
                  labelText: 'ATM Id' ,
                  suffixIcon: Icon(Icons.search)),
            ),),),
            const SizedBox(
              height: 20,
            ),

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
                              sensorList.clear();
                              List<dynamic> sensorlist = (await httpreq.getdata(
                                  Glob().getSensorDetailslist() +Siteidcontroller.text ,
                                  prefs.getString('token'),context)) ;
                              setState(()  {
                                _foundUsers.clear();
                                sensorList = sensorlist.cast<String>();
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
            if(sensorList.length!=0)
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
                  border: Border.all(color:common.getColorFromHex('8D8D8D'),width: 2.0),

                ),
                // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
                child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: common.getColorFromHex('8D8D8D'),
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
                        items: sensorList.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,style:TextStyle(color:Colors.black),),
                          );
                        })?.toList(),

                        hint: Text(
                          sensorList[0],
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
            /*MultiSelect(
              //--------customization selection modal-----------
                buttonBarColor: Colors.red,
                cancelButtonText: "Exit",
                titleText: "Sensors",
                checkBoxColor: Colors.black,
                selectedOptionsInfoText: "(tap to remove)",
                selectedOptionsBoxColor: Colors.grey,
                maxLength: 5,
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
                  print('The saved values are $value');
                }),*/
            SizedBox(height: 10,),
            Container(
              height:120,
              decoration: BoxDecoration(  color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(3)),
                border: Border.all(color:getColorFromHex('8D8D8D'),width: 2.0),),
              child:
Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0),child:
            TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
              maxLength: 500,
              controller:  complaintcontroller,
              decoration: InputDecoration(
                  filled: false,
    hintText: 'Type here..',
    hintStyle: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide.none),
    contentPadding: EdgeInsets.zero
    ) ),),),
            SizedBox(height: 10,),
            getCustomButton(labeltext: 'Submit',width: 200,onpressed:(){ callurl();}),










    ],
        ),
      ),)
    );


  }
  void callurl() async{
    if(Siteidcontroller.text==""){
      common.showAlert(context, 'Select ATM id');
    }
    else if(_chosenallcamera==""||_chosenallcamera==null){
      common.showAlert(context, 'Select a Sensor');
    }
    else if(complaintcontroller.text==""){
      common.showAlert(context, 'Enter a complaint message');
    }
else {
      common.showloading(context);
      Map<String, String> credentials = {
        'SiteName': Siteidcontroller.text,
        'ItemName': _chosenallcamera,
        'UserName': prefs.getString('username'),
        'Compliant': complaintcontroller.text,
      };
      print(credentials);
      String logindata = (await httpreq.postdata(
          Glob().postcomplaint(), credentials, ''));
      common.Stoploading(context);
      common.showAlert(context, logindata);
      print(logindata);
      complaintcontroller.text="";
    }
  }
  @override
  void dispose() {
    Siteidcontroller.text="";
    complaintcontroller.text="";
    sensorList.clear();
    Glob().currentpage="";
    super.dispose();


  }

}