import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:widget_app/utills/colors_resources.dart';
import 'package:widget_app/utills/images_sources.dart';

import 'category_gallery.dart';
import 'category_manager.dart';
import 'fav.dart';
import 'models/categories.dart';

class Home extends StatefulWidget {
  final List<CategoriesModel>? wallpapersList;
  int? index;

  Home({Key? key, this.wallpapersList, this.index}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final categories = List<String>.empty(growable: true);
  final categoryImages = List<String>.empty(growable: true);

  @override
  void initState() {
    super.initState();

    widget.wallpapersList!.forEach(
      (wallpaper) {
        var category = wallpaper.category;

        if (!categories.contains(category)) {
          categories.add(category);
          categoryImages.add(wallpaper.url);
        }
      },
    );
  }

  bool? _hasBeenPressed1 = true;

  ///bottom Grid
  List<String> _text2 = ['تريد النجاح'];
  List<String> list2 = [Images.grid_bottom];
  List<CategoriesModel>? wallpaperList;
  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 50,
                width: 50,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Image.asset(Images.drawer_img)),
                )),
            Container(
                alignment: Alignment.topRight,
                child: Text(
                  "كيف تشعر؟",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      fontFamily: 'franklin_gothic',
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      color: ColorResources.BOTTOM_BAR_SELECTED),
                )),
            Expanded(
              flex: 3,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: GridView.builder(
                  shrinkWrap: false,
                  reverse: false,
                  primary: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.6 / 2,
                      mainAxisSpacing: 7,
                      crossAxisSpacing: 5,
                      crossAxisCount: 3),
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkResponse(
                        onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CategoryManager(
                                  category: categories.elementAt(index));
                            })),
                        child: Card(
                            elevation: 10,
                            color: _hasBeenPressed1!
                                ? ColorResources.WHITE
                                : ColorResources.BOTTOM_BAR_SELECTED,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  Container(
                                      width: 50,
                                      height: 50,
                                      child: Image.network(
                                          categoryImages.elementAt(index) ==
                                                  null
                                              ? "https://firebasestorage.googleapis.com/v0/b/arabic-9b31b.appspot.com/o/Categories%2Fgird_2.png?alt=media&token=5380c906-8753-4f92-a114-07fba1078039"
                                              : categoryImages.elementAt(index),
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;

                                            return Center(
                                                child: CircularProgressIndicator(
                                                    color: ColorResources
                                                        .BOTTOM_BAR_SELECTED));
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  CircularProgressIndicator(
                                                      color: ColorResources
                                                          .BOTTOM_BAR_SELECTED),
                                          fit: BoxFit.fitWidth)),
                                  Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 10),
                                      child: Text(
                                        categories.elementAt(index).toString(),
                                        // textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: TextStyle(
                                            fontFamily: 'franklin_gothic',
                                            fontSize: 12,
                                            color: ColorResources
                                                .BOTTOM_BAR_SELECTED),
                                      ))
                                ]))));
                  },
                ),
              ),
            ),
            Container(
                alignment: Alignment.topRight,
                child: Text(
                  "مجموعتي",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'franklin_gothic',
                      fontSize: 25,
                      color: ColorResources.BOTTOM_BAR_SELECTED),
                )),
            Expanded(
              child:

                  /// bottom Grid
                  Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: GridView.count(
                    childAspectRatio: 1.9 / 2,
                    mainAxisSpacing: 7,
                    crossAxisSpacing: 5,
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    reverse: false,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(
                        list2.length,
                        (index) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: InkResponse(
                                onTap: () => Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Favorite(
                                        wallpapersList: wallpaperList,
                                      );
                                    })),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 60,
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              list2[index],
                                              width: double.infinity,
                                              // height: 110,
                                              fit: BoxFit.fitWidth,
                                            ),
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  _text2[index],
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'franklin_gothic',
                                                      fontSize: 12,
                                                      color: ColorResources
                                                          .BOTTOM_BAR_SELECTED),
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )))),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
