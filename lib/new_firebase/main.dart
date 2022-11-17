import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:widget_app/new_firebase/providers/fav_categories_manager.dart';
import 'package:widget_app/new_firebase/theme_manager.dart';
import 'package:widget_app/new_firebase/category_gallery.dart';
import 'package:widget_app/utills/colors_resources.dart';

import '../firebase_options.dart';
import '../utills/images_sources.dart';
import '../utills/constants.dart';
import 'fav.dart';
import 'home.dart';
import 'models/categories.dart';

Future<void> main() async {
  await _initApp();

  runApp(MyHomePage(
    title: 'That Wallpaper App!',
  ));
}

Future _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();

  var docDir = await getApplicationDocumentsDirectory();
  Hive.init(docDir.path);

  var favBox = await Hive.openBox(FAV_BOX);
  if (favBox.get(FAV_LIST_KEY) == null) {
    favBox.put(FAV_LIST_KEY, List<dynamic>.empty(growable: true));
  }

  var settings = await Hive.openBox(SETTINGS);
  if (settings.get(DARK_THEME_KEY) == null) {
    settings.put(DARK_THEME_KEY, false);
  }
}

final pageController = PageController(initialPage: 1);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentSelected = 1;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => FavCategoryManager(),
      child: ValueListenableBuilder(
        valueListenable: ThemeManager.notifier,
        child: _buildScaffold(),
        builder: (BuildContext? context, ThemeMode? themeMode, Widget? child) {
          return MaterialApp(
            title: widget.title!,
            theme: ThemeData.light(),
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData.dark(),
            themeMode: themeMode,
            home: child,
          );
        },
      ),
    );
  }

  Scaffold _buildScaffold() {
    return Scaffold(
        /* appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_5),
            onPressed: () {
              if (ThemeManager.notifier.value == ThemeMode.dark) {
                ThemeManager.setTheme(ThemeMode.light);
              } else {
                ThemeManager.setTheme(ThemeMode.dark);
              }
            },
          )
        ],
      ),*/
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          backwardsCompatibility: false,
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: Image(
            image: AssetImage(Images.background_img),
            fit: BoxFit.cover,
          ),
          title: Image.asset(Images.splash_logo,
              height: 40, width: double.infinity),
        ),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('wallpapers_2').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              var wallpapersList = List<CategoriesModel>.empty(growable: true);
              var favWallpaperManager =
                  Provider.of<FavCategoryManager>(context);

              snapshot.data!.docs.forEach((documentSnapshot) {
                var wallpaper =
                    CategoriesModel.fromDocumentSnapshot(documentSnapshot);

                if (favWallpaperManager.isFavorite(wallpaper)) {
                  wallpaper.isFavorite = true;
                }

                wallpapersList.add(wallpaper);
              });

              return PageView.builder(
                controller: pageController,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return _getPageAtIndex(index, wallpapersList);
                },
                onPageChanged: (int index) {
                  setState(() {
                    currentSelected = index;
                  });
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Color(0xFFFC6D02),
              primaryColor: Colors.white,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: TextStyle(color: Colors.grey))),
          child: _buildBottomNavigationBar(),
        ));
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentSelected,
      selectedItemColor: ColorResources.BLACK,
      backgroundColor: ColorResources.BOTTOM_BAR,
      unselectedItemColor: ColorResources.BLACK,
      items: [
        BottomNavigationBarItem(
          backgroundColor: ColorResources.BOTTOM_BAR_SELECTED,
          icon: Image.asset(
            Images.bottom_bar_1,
            height: 25,
            width: 30,
          ),
          label: 'شاركنا الثواب',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            Images.bottom_bar_2,
            height: 25,
            width: 30,
            color: ColorResources.BOTTOM_BAR_SELECTED,
          ),
          label: 'التصنيفات',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            Images.bottom_bar_3,
            height: 25,
            width: 30,
          ),
          label: 'الرئيسية',
        ),
      ],
      onTap: (int index) {
        setState(() {
          currentSelected = index;
          pageController.animateToPage(
            currentSelected,
            curve: Curves.fastOutSlowIn,
            duration: Duration(milliseconds: 400),
          );
        });
      },
    );
  }

  Widget _getPageAtIndex(int index, List<CategoriesModel> wallpaperList) {
    switch (index) {
      case 0:
        return CategoriesGallery(
            wallpaperList: wallpaperList,
            name: wallpaperList.elementAt(index).name.toString(),
            initialPage: index);
        break;
      case 1:
        return Home(
          wallpapersList: wallpaperList,
        );
        break;
      case 2:
        return Favorite(
          wallpapersList: wallpaperList,
        );
        break;
      default:
        // Should never get hit.
        return CircularProgressIndicator();
        break;
    }
  }
}
