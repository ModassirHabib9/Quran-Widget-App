import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:widget_app/utills/colors_resources.dart';

import '../../utills/images_sources.dart';

class AppHomeScreenSetup extends StatefulWidget {
  const AppHomeScreenSetup({Key? key}) : super(key: key);

  @override
  State<AppHomeScreenSetup> createState() => _AppHomeScreenSetupState();
}

class _AppHomeScreenSetupState extends State<AppHomeScreenSetup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
            Image.asset(Images.splash_logo, height: 40, width: double.infinity),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 250,
            child: Image.asset(Images.app_screen),
          ),

          /// Box blue color
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: ListTile(
                      dense: true,
                      visualDensity: VisualDensity(horizontal: 0, vertical: 1),
                      tileColor: ColorResources.BOTTOM_BAR_SELECTED,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      leading: Icon(Icons.add_card_sharp),
                      trailing: Text("إشباع", textDirection: TextDirection.rtl),
                    )),
                Text("    فئة القطعة", textDirection: TextDirection.rtl),
                Container(
                    decoration: BoxDecoration(
                        color: ColorResources.WHITE,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            // spreadRadius: 5,
                            blurRadius: 1,
                            // offset: Offset(9, 9), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(children: [
                      ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: 1),
                        tileColor: ColorResources.WHITE,
                        leading: Icon(Icons.add_card_sharp),
                        trailing:
                            Text("إشباع", textDirection: TextDirection.rtl),
                      ),
                      Container(
                          height: 60,
                          child: Text(
                              "يمكنك اختيار التصنيف الذي تريده من خلال الذهاب الى صفحة التصنيفات ثم الضغط على التصنيف والضغط على زر ")),
                    ])),
                Text("موضوع القطعة", textDirection: TextDirection.rtl),
              ],
            ),
          )
        ],
      ),
    );
  }
}
