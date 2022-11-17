import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_app/new_firebase/providers/fav_categories_manager.dart';
import 'package:widget_app/new_firebase/category_gallery.dart';
import 'package:widget_app/utills/colors_resources.dart';
import 'package:widget_app/utills/images_sources.dart';
import 'models/categories.dart';
import 'theme_manager.dart';

class CategoryManager extends StatefulWidget {
  final String? category;
  int? index;

  CategoryManager({Key? key, @required this.category, this.index})
      : super(key: key);

  @override
  _CategoryManagerState createState() => _CategoryManagerState();
}

const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class _CategoryManagerState extends State<CategoryManager> {
  int currentIndex = 0;
  PageController? _controller;
  bool descTextShowFlag = false;
  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  ScrollPhysics? physics;

  void setScrollPhysics(ScrollPhysics physics) {
    setState(() {
      this.physics = physics;
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  bool? _hasBeenPressed = true;
  bool? _hasBeenPressed1 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: ColorResources.BOTTOM_BAR_SELECTED),
          elevation: 0,
          flexibleSpace: Image(
            image: AssetImage(Images.background_img),
            fit: BoxFit.cover,
          ),
          automaticallyImplyLeading: true,
          backwardsCompatibility: true),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              image: new DecorationImage(
                  // scale: 20,
                  // opacity: 90,
                  filterQuality: FilterQuality.high,
                  image: ExactAssetImage(Images.background_img, scale: 120),
                  fit: BoxFit.fitHeight)),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('wallpapers_2')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                // Get all wallpapers of widget.category.
                var wallpapers =
                    _getWallpapersOfCurrentCategory(snapshot.data!.docs);

                return PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: wallpapers.length,
                  controller: _controller,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    var favWallpaperManager =
                        Provider.of<FavCategoryManager>(context);

                    return Column(children: [
                      Container(
                          height: 45,
                          child: ListTile(
                              dense: true,
                              tileColor: ColorResources.BOTTOM_BAR_SELECTED,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              trailing: Container(
                                  width: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: ColorResources.WHITE)),
                                  child: Icon(Icons.add,
                                      color: ColorResources.WHITE)),
                              title: Container(
                                  // alignment: Alignment.topRight,
                                  child: Text(wallpapers.elementAt(index).name,
                                      textAlign: TextAlign.end,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'franklin_gothic',
                                          fontSize: 22,
                                          color: ColorResources.WHITE))),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => CategoriesGallery(
                                          wallpaperList: wallpapers,
                                          name: wallpapers
                                              .elementAt(index)
                                              .name
                                              .toString(),
                                          initialPage: index))))),
                      SizedBox(height: 12),
                      Expanded(
                          flex: 6,
                          child: SingleChildScrollView(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: FloatingActionButton(
                                heroTag: "f1",
                                elevation: 0,
                                mini: true,
                                backgroundColor: _hasBeenPressed1!
                                    ? ColorResources.BOTTOM_BAR
                                    : ColorResources.BOTTOM_BAR_SELECTED,
                                onPressed: () {
                                  setState(() {
                                    // _hasBeenPressed1 = !_hasBeenPressed1!;
                                    if (currentIndex ==
                                        wallpapers
                                                .elementAt(index)
                                                .name
                                                .length -
                                            1) {
                                      _controller!.page;
                                      wallpapers.elementAt(index).name;
                                    }
                                    _hasBeenPressed1 = !_hasBeenPressed1!;
                                    _controller!.previousPage(
                                      duration: Duration(milliseconds: 100),
                                      curve: Curves.easeIn,
                                    );
                                  });
                                },
                                child: Icon(Icons.arrow_back),
                              )),
                              SizedBox(width: 5),
                              Expanded(
                                  flex: 9,
                                  child: ExpandableNotifier(
                                    child: ScrollOnExpand(
                                      scrollOnExpand: false,
                                      child: Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        clipBehavior: Clip.antiAlias,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    top: 20),
                                                child: Expandable(
                                                  collapsed: Text(
                                                    wallpapers
                                                        .elementAt(index)
                                                        .complete_ayat,
                                                    maxLines: 12,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                        color: ColorResources
                                                            .BOTTOM_BAR_SELECTED,
                                                        fontSize: 20,
                                                        fontFamily:
                                                            'franklin_gothic',
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  expanded: Text(
                                                    wallpapers
                                                        .elementAt(index)
                                                        .complete_ayat,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                        color: ColorResources
                                                            .BOTTOM_BAR_SELECTED,
                                                        fontSize: 20,
                                                        fontFamily:
                                                            'franklin_gothic',
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Builder(
                                                  builder: (context) {
                                                    var controller =
                                                        ExpandableController.of(
                                                            context,
                                                            required: true)!;
                                                    return IconButton(
                                                        onPressed: () {
                                                          controller.toggle();
                                                        },
                                                        icon: controller
                                                                .expanded
                                                            ? Icon(
                                                                Icons
                                                                    .expand_less,
                                                                color: ColorResources
                                                                    .BOTTOM_BAR_SELECTED,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .expand_more,
                                                                color: ColorResources
                                                                    .BOTTOM_BAR_SELECTED));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                              SizedBox(width: 5),
                              Expanded(
                                  child: FloatingActionButton(
                                heroTag: "f2",
                                mini: true,
                                elevation: 0,
                                backgroundColor: _hasBeenPressed!
                                    ? ColorResources.BOTTOM_BAR
                                    : ColorResources.BOTTOM_BAR_SELECTED,
                                onPressed: () {
                                  setState(() {
                                    _hasBeenPressed = !_hasBeenPressed!;
                                    if (currentIndex ==
                                        wallpapers
                                                .elementAt(index)
                                                .name
                                                .length -
                                            1) {
                                      _controller!.page;
                                      wallpapers.elementAt(index).name;
                                    }
                                    _controller!.nextPage(
                                      duration: Duration(milliseconds: 100),
                                      curve: Curves.easeIn,
                                    );
                                  });
                                },
                                child: Icon(Icons.arrow_forward_outlined),
                              )),
                            ],
                          ))),
                      //    Buttom Icons..........
                      Expanded(
                        child: Row(
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
                              onPressed: () {},
                              mini: true,
                              backgroundColor: ColorResources.WHITE,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Icon(Icons.share,
                                  color: ColorResources.BOTTOM_BAR_SELECTED),
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                if (wallpapers.elementAt(index).isFavorite) {
                                  favWallpaperManager.removeFromFav(
                                    wallpapers.elementAt(index),
                                  );
                                } else {
                                  favWallpaperManager.addToFav(
                                    wallpapers.elementAt(index),
                                  );
                                }
                                wallpapers.elementAt(index).isFavorite =
                                    !wallpapers.elementAt(index).isFavorite;
                              },
                              mini: true,
                              backgroundColor: ColorResources.WHITE,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Icon(
                                wallpapers.elementAt(index).isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: ColorResources.BOTTOM_BAR_SELECTED,
                              ),
                            )
                          ],
                        ),
                      )
                    ]);
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
    );
  }

  List<CategoriesModel> _getWallpapersOfCurrentCategory(
      List<DocumentSnapshot> documents) {
    var list = List<CategoriesModel>.empty(growable: true);

    var favWallpaperManager = Provider.of<FavCategoryManager>(context);

    documents.forEach((document) {
      var wallpaper = CategoriesModel.fromDocumentSnapshot(document);

      if (wallpaper.category == widget.category) {
        if (favWallpaperManager.isFavorite(wallpaper)) {
          wallpaper.isFavorite = true;
        }

        list.add(wallpaper);
      }
    });

    return list;
  }
}
