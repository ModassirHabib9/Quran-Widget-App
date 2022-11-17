import 'package:cloud_firestore/cloud_firestore.dart';
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

class _CategoryManagerState extends State<CategoryManager> {
  int currentIndex = 0;
  PageController? _controller;

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
        backwardsCompatibility: true,
      ),
      body: Container(
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
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 20),
                          height: 40,
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
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
                              child: Text(
                                wallpapers.elementAt(index).name,
                                textAlign: TextAlign.end,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'franklin_gothic',
                                    fontSize: 22,
                                    color: ColorResources.WHITE),
                              ),
                            ),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CategoriesGallery(
                                    wallpaperList: wallpapers,
                                    name: wallpapers
                                        .elementAt(index)
                                        .name
                                        .toString(),
                                    initialPage: index),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FloatingActionButton(
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
                              ),
                              Expanded(
                                  child: Scrollbar(
                                child: Column(
                                  children: [
                                    Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(
                                              top: 8.0, left: 5.0, right: 5.0),
                                          height: 450,
                                          child: Text(
                                            wallpapers
                                                .elementAt(index)
                                                .complete_ayat,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'franklin_gothic',
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
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Icon(Icons.settings,
                                              color: ColorResources
                                                  .BOTTOM_BAR_SELECTED),
                                        ),
                                        FloatingActionButton(
                                          onPressed: () {
                                            /* Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AppHomeScreenSetup()));*/
                                          },
                                          mini: true,
                                          backgroundColor: ColorResources.WHITE,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Icon(Icons.share,
                                              color: ColorResources
                                                  .BOTTOM_BAR_SELECTED),
                                        ),
                                        FloatingActionButton(
                                          onPressed: () {
                                            if (wallpapers
                                                .elementAt(index)
                                                .isFavorite) {
                                              favWallpaperManager.removeFromFav(
                                                wallpapers.elementAt(index),
                                              );
                                            } else {
                                              favWallpaperManager.addToFav(
                                                wallpapers.elementAt(index),
                                              );
                                            }
                                            wallpapers
                                                    .elementAt(index)
                                                    .isFavorite =
                                                !wallpapers
                                                    .elementAt(index)
                                                    .isFavorite;
                                          },
                                          mini: true,
                                          backgroundColor: ColorResources.WHITE,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Icon(
                                            wallpapers
                                                    .elementAt(index)
                                                    .isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: ColorResources
                                                .BOTTOM_BAR_SELECTED,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                              FloatingActionButton(
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
                              ),
                            ],
                          ))
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
