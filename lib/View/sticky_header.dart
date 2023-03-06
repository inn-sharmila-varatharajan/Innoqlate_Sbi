import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innlite_mobile/Common/api_url.dart';
import 'package:innlite_mobile/Common/utils.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      return StickyHeader(
        header: Container(
          height: 50.0,
          color: Colors.blueGrey[700],
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: Text('Header',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        content: Container(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

             Column(
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

                  'SiteName',
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
                'CompleteAddress',
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

            Expanded(
              flex: 3,
              child: Text(
                'Ageing',
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
        )
                ]),
          ),
        ),
      );
    });
  }
}