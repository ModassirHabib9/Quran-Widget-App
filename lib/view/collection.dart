import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:widget_app/utills/colors_resources.dart';

import 'category.dart';
import 'inside_collection/app_homeScreen.dart';

class CollectionScreen extends StatefulWidget {
  final List<FruitDataModel> fruitDataModel;
  int index;
  CollectionScreen({required this.fruitDataModel, required this.index});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: ColorResources.BOTTOM_BAR_SELECTED),
          elevation: 0,
          automaticallyImplyLeading: true,
          backwardsCompatibility: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    child: ListTile(
                      tileColor: ColorResources.BOTTOM_BAR_SELECTED,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      trailing: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: ColorResources.WHITE)),
                          child: Icon(Icons.add, color: ColorResources.WHITE)),
                      title: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "أضف هذه الفئة إلى القطعة",
                          style: TextStyle(
                              fontSize: 16, color: ColorResources.WHITE),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FloatingActionButton(
                        heroTag: "f1",
                        elevation: 0,
                        mini: true,
                        backgroundColor: ColorResources.BOTTOM_BAR_SELECTED,
                        onPressed: () {
                          setState(() {
                            if (widget.index != 0) {
                              widget.index--;
                            }
                          });
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                alignment: Alignment.center,
                                height: 450,
                                child: Text(
                                  widget.fruitDataModel[widget.index].desc,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              )),
                          //    Buttom Icons..........
                          Row(
                            children: [
                              FloatingActionButton(
                                onPressed: () {},
                                mini: true,
                                backgroundColor: ColorResources.WHITE,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Icon(Icons.settings,
                                    color: ColorResources.BOTTOM_BAR_SELECTED),
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AppHomeScreenSetup()));
                                },
                                mini: true,
                                backgroundColor: ColorResources.WHITE,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Icon(Icons.share,
                                    color: ColorResources.BOTTOM_BAR_SELECTED),
                              ),
                              FloatingActionButton(
                                onPressed: () {},
                                mini: true,
                                backgroundColor: ColorResources.WHITE,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Icon(Icons.favorite,
                                    color: ColorResources.BOTTOM_BAR_SELECTED),
                              )
                            ],
                          )
                        ],
                      )),
                      FloatingActionButton(
                        heroTag: "f2",
                        mini: true,
                        elevation: 0,
                        backgroundColor: ColorResources.BOTTOM_BAR_SELECTED,
                        onPressed: () {
                          setState(() {
                            if (widget.index !=
                                widget.fruitDataModel.length - 1) {
                              widget.index++;
                            }
                          });
                        },
                        child: Icon(Icons.arrow_forward_outlined),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
