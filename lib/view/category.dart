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
import '../new_firebase/fav.dart';
import '../new_firebase/home.dart';
import '../new_firebase/models/categories.dart';
import '../utills/images_sources.dart';
import '../utills/constants.dart';

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

/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utills/colors_resources.dart';
import '../utills/images_sources.dart';
import 'collection.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  static List<String> fruitname = [
    'Apple',
    'Banana',
    'Mango',
    'Orange',
    'pineapple'
  ];
  static List<String> url = [
    'https://www.applesfromny.com/wp-content/uploads/2020/05/Jonagold_NYAS-Apples2.png',
    'https://cdn.mos.cms.futurecdn.net/42E9as7NaTaAi4A6JcuFwG-1200-80.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Hapus_Mango.jpg/220px-Hapus_Mango.jpg',
    'https://5.imimg.com/data5/VN/YP/MY-33296037/orange-600x600-500x500.jpg',
    'https://5.imimg.com/data5/GJ/MD/MY-35442270/fresh-pineapple-500x500.jpg'
  ];
  final List<FruitDataModel> Fruitdata = List.generate(
      fruitname.length,
      (index) => FruitDataModel('${fruitname[index]}', '${url[index]}',
          '${fruitname[index]} Description...'));
//////////////////////////////////////////////////////////////

  ///bottom Grid
  List<String> _text2 = ['تريد النجاح', 'اشعر'];
  List<String> list2 = [Images.grid_bottom, Images.grid_bottom];

  ///bottom Grid
  List<String> _text = [
    'تريد النجاح',
    'اشعر بالحزن',
    'كيف اتعامل مع الناس',
    'إرتكب خطيئة',
    'إشباع',
    'تريد النجاح',
    'إرتكب خطيئة',
    'إشباع',
    'تريد النجاح',
  ];
  List<String> list = [
    Images.grid_1,
    Images.grid_2,
    Images.grid_3,
    Images.grid_4,
    Images.grid_5,
    Images.grid_1,
    Images.grid_4,
    Images.grid_5,
    Images.grid_1,
  ];
  int _selectedTabIndex = 0;

  List _pages = [Text("sjk"), Text("sjk"), Text("sjk")];

  int value = 0;

  _changeIndex(int index) {
    setState(() {
      this.value = index;
      _selectedTabIndex = index;
      print("index..." + index.toString());
    });
    print(_selectedTabIndex);
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          backwardsCompatibility: false,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Image.asset(Images.splash_logo,
              height: 40, width: double.infinity),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: _changeIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: ColorResources.BOTTOM_BAR,
          selectedItemColor: ColorResources.WHITE,
          items: [
            BottomNavigationBarItem(
                label: "",
                icon: Container(
                  width: 90,
                  decoration: BoxDecoration(
                      color: value == 0
                          ? ColorResources.BOTTOM_BAR_SELECTED
                          : ColorResources.TRANSPARENT,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Column(
                    children: [
                      Text("شاركنا الثواب"),
                      Icon(Icons.reply_all_outlined),
                    ],
                  ),
                ) //Icon(Icons.reply_all_outlined),
                ),
            BottomNavigationBarItem(
              label: "",
              icon: Container(
                width: 90,
                // height: 50,
                decoration: BoxDecoration(
                    color: value == 1
                        ? ColorResources.BOTTOM_BAR_SELECTED
                        : ColorResources.TRANSPARENT,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Column(
                  children: [
                    Text("التصنيفات"),
                    Icon(Icons.account_tree),
                  ],
                ),
              ), //Icon(Icons.reply_all_outlined),
            ),
            BottomNavigationBarItem(
              label: "",
              icon: Container(
                width: 90,
                decoration: BoxDecoration(
                    color: value == 2
                        ? ColorResources.BOTTOM_BAR_SELECTED
                        : ColorResources.TRANSPARENT,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Column(
                  children: [
                    Text("الرئيسية"),
                    Icon(Icons.home),
                  ],
                ),
              ), //Icon(Icons.reply_all_outlined),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              // SizedBox(height: 40),

              Container(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.playlist_play_sharp)),
              Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    "كيف تشعر؟",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 18),
                  )),
              Container(
                  height: MediaQuery.of(context).size.height * 0.54,
                  child: GridView.count(
                    childAspectRatio: 1.9 / 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 0,
                    crossAxisCount: 3,
                    shrinkWrap: false,
                    children: List.generate(
                        list.length,
                        (index) => InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CollectionScreen(
                                        index: index,
                                        fruitDataModel: Fruitdata))),
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 60,
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          list[index],
                                          width: double.infinity,
                                          // height: 110,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Text(
                                              _text[index],
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12),
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ))),
                  )),
              Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    "مجموعتي",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 18),
                  )),

              /// bottom Grid
              Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: GridView.count(
                    childAspectRatio: 1.9 / 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 0,
                    crossAxisCount: 3,
                    shrinkWrap: false,
                    reverse: true,
                    children: List.generate(
                        list2.length,
                        (index) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12),
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ))),
                  )),
            ],
          ),
        ));
  }
}

class FruitDataModel {
  final String name, ImageUrl, desc;
  FruitDataModel(this.name, this.ImageUrl, this.desc);
}
*/
