import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_app/new_firebase/providers/fav_categories_manager.dart';

import '../utills/colors_resources.dart';
import '../utills/images_sources.dart';
import 'models/categories.dart';
import 'category_gallery.dart';

class Favorite extends StatefulWidget {
  final List<CategoriesModel>? wallpapersList;

  Favorite({Key? key, this.wallpapersList}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    var wallpapers = widget.wallpapersList!
        .where((wallpaper) => wallpaper.isFavorite)
        .toList();

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
        child: ListView.builder(
          itemCount: wallpapers.length,
          itemBuilder: (BuildContext context, int index) {
            var favWallpaperManager = Provider.of<FavCategoryManager>(context);

            return ListTile(
              title: InkResponse(
                onTap: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CategoriesGallery(
                          wallpaperList: wallpapers, initialPage: index),
                    ),
                  );
                },
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: 40.0,
                  decoration: ShapeDecoration(
                    color: ColorResources.BOTTOM_BAR_SELECTED,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    /*image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          wallpapers.elementAt(index).url),
                    ),*/
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      color: Color(
                          Theme.of(context).textTheme.caption!.color!.value ^
                              0xffffff),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              wallpapers.elementAt(index).isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
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
                          ),
                          Text(
                            wallpapers.elementAt(index).name,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontStyle: FontStyle.italic,
                                color: ColorResources.BOTTOM_BAR_SELECTED,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
