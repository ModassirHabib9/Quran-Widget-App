import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../utills/colors_resources.dart';
import '../utills/images_sources.dart';
import 'models/categories.dart';
import 'providers/fav_categories_manager.dart';

class CategoriesGallery extends StatefulWidget {
  final List<CategoriesModel>? wallpaperList;
  final String? name;
  final int? initialPage;

  CategoriesGallery(
      {Key? key,
      @required this.wallpaperList,
      @required this.initialPage,
      this.name})
      : super(key: key);

  @override
  _CategoriesGalleryState createState() => _CategoriesGalleryState();
}

class _CategoriesGalleryState extends State<CategoriesGallery> {
  late PageController _pageController;
  late int _currentIndex;
  int value = 0;
  bool positive = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage!);
    _currentIndex = widget.initialPage!;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            image: new DecorationImage(
              // scale: 20,
              // opacity: 90,
              filterQuality: FilterQuality.high,
              image: ExactAssetImage(Images.background_img, scale: 120),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Builder(
            builder: (BuildContext context) {
              /*widget.wallpaperList!.elementAt(_currentIndex).name,*/
              var favWallpaperManager =
                  Provider.of<FavCategoryManager>(context);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 50,
                        width: 50,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Image.asset(Images.drawer_img)),
                        )),
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
                                visualDensity:
                                    VisualDensity(horizontal: 0, vertical: 1),
                                tileColor: ColorResources.BOTTOM_BAR,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                leading: Container(
                                  child: AnimatedToggleSwitch<bool>.dual(
                                    current: positive,
                                    first: false,
                                    second: true,
                                    dif: 0.0,
                                    borderColor: Colors.transparent,
                                    borderWidth: 8.0,
                                    height: 32,
                                    onChanged: (b) =>
                                        setState(() => positive = b),
                                    colorBuilder: (b) => b
                                        ? ColorResources.BOTTOM_BAR_SELECTED
                                        : ColorResources.BOTTOM_BAR_SELECTED,
                                    /*iconBuilder: (value) => value
                              ? Icon(Icons.coronavirus_rounded)
                              : Icon(Icons.tag_faces_rounded),*/
                                    textBuilder: (value) => value
                                        ? Center(child: Text(''))
                                        : Center(child: Text('')),
                                  ),
                                ),
                                trailing: Text("أداة الشاشة",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            ColorResources.BOTTOM_BAR_SELECTED),
                                    textDirection: TextDirection.rtl),
                              )),
                          Text("    فئة القطعة",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: ColorResources.BOTTOM_BAR_SELECTED),
                              textDirection: TextDirection.rtl),
                          Container(
                              decoration: BoxDecoration(
                                  color: ColorResources.WHITE,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 1,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              child: Column(children: [
                                Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: ListTile(
                                      dense: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -1),
                                      tileColor: ColorResources.WHITE,
                                      leading: Image.asset(
                                        Images.share,
                                        width: 20,
                                        height: 17,
                                      ),
                                      trailing: Text("إشباع",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: ColorResources
                                                  .BOTTOM_BAR_SELECTED),
                                          textDirection: TextDirection.rtl),
                                    )),
                                Container(
                                    // height: 60,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorResources
                                              .BOTTOM_BAR_SELECTED,
                                          fontWeight: FontWeight.bold),
                                      widget.wallpaperList!
                                          .elementAt(_currentIndex)
                                          .complete_ayat,
                                      // "يمكنك اختيار التصنيف الذي تريده من خلال الذهاب الى صفحة التصنيفات ثم الضغط على التصنيف والضغط على زر ",
                                      textAlign: TextAlign.center,
                                    )),
                              ])),
                          Text("موضوع القطعة",
                              style: TextStyle(
                                fontSize: 25,
                                color: ColorResources.BOTTOM_BAR_SELECTED,
                              ),
                              textDirection: TextDirection.rtl),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
