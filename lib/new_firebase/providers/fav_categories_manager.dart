import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../utills/constants.dart';
import '../models/categories.dart';

class FavCategoryManager extends ChangeNotifier {
  void addToFav(CategoriesModel wallpaper) {
    var list = Hive.box(FAV_BOX).get(FAV_LIST_KEY);

    if (!list.contains(wallpaper.id)) {
      list.add(wallpaper.id);
      Hive.box(FAV_BOX).put(FAV_LIST_KEY, list);

      notifyListeners();
    }
  }

  void removeFromFav(CategoriesModel wallpaper) {
    var list = Hive.box(FAV_BOX).get(FAV_LIST_KEY);

    if (list.remove(wallpaper.id)) {
      Hive.box(FAV_BOX).put(FAV_LIST_KEY, list);

      notifyListeners();
    }
  }

  bool isFavorite(CategoriesModel wallpaper) {
    return Hive.box(FAV_BOX).get(FAV_LIST_KEY).contains(wallpaper.id);
  }
}
