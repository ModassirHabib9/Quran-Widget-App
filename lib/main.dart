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
import 'package:widget_app/view/onbording_screen/onboarding.dart';

import '../firebase_options.dart';
import '../utills/images_sources.dart';
import '../utills/constants.dart';
import 'new_firebase/fav.dart';
import 'new_firebase/home.dart';
import 'new_firebase/models/categories.dart';

Future<void> main() async {
  await _initApp();

  runApp(MyHomePage(
    title: 'That Quran App!',
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
  bool? isDrawerToBeOpen;
  final _selectedItemColor = Colors.white;
  final _unselectedItemColor = ColorResources.BOTTOM_BAR_SELECTED;
  final _selectedBgColor = ColorResources.BOTTOM_BAR_SELECTED;
  final _unselectedBgColor = ColorResources.BOTTOM_BAR;
  int _selectedIndex = 1;
  // int currentSelected = 1;
  Color _getBgColor(int index) =>
      _selectedIndex == index ? _selectedBgColor : _unselectedBgColor;

  Color _getItemColor(int index) =>
      _selectedIndex == index ? _selectedItemColor : _unselectedItemColor;
  List<Widget> _widgetOptions = <Widget>[];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      isDrawerToBeOpen = false;
      _widgetOptions = [];
    });
  }

  Widget _buildIcon(Image iconData, String text, int index) => Container(
        width: 85,
        height: 47,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6.0),
                bottomRight: Radius.circular(6.0)),
            color: _getBgColor(index),
          ),
          child: InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  iconData,
                  Text(text,
                      style:
                          TextStyle(fontSize: 12, color: _getItemColor(index))),
                ],
              ),
              onTap: () => _onItemTapped(index)),
        ),
      );

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        backwardsCompatibility: false,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: Image(
          image: AssetImage(Images.background_img),
          fit: BoxFit.cover,
        ),
        title:
            Image.asset(Images.splash_logo, height: 40, width: double.infinity),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('wallpapers_2').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var wallpapersList = List<CategoriesModel>.empty(growable: true);
            var favWallpaperManager = Provider.of<FavCategoryManager>(context);

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
                  _selectedIndex = index;
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
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        backgroundColor: ColorResources.BOTTOM_BAR,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            pageController.animateToPage(
              _selectedIndex,
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 400),
            );
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(
                Image.asset(
                  Images.bottom_bar_1,
                  height: 20,
                  color: _selectedIndex == 0
                      ? Colors.white
                      : ColorResources.BOTTOM_BAR_SELECTED,
                ),
                'شاركنا الثواب',
                0),
            label: '',
            backgroundColor: Color(0xFF038EC2),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
                Image.asset(
                  Images.bottom_bar_2,
                  height: 20,
                  color: _selectedIndex == 1
                      ? Colors.white
                      : ColorResources.BOTTOM_BAR_SELECTED,
                ),
                'التصنيفات',
                1),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
                Image.asset(
                  Images.bottom_bar_3,
                  height: 20,
                  color: _selectedIndex == 2
                      ? Colors.white
                      : ColorResources.BOTTOM_BAR_SELECTED,
                ),
                'الرئيسية',
                2),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _selectedItemColor,
        unselectedItemColor: _unselectedItemColor,
      ),
      /*
      bottomNavigationBar: Container(
        // height: 70,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentSelected,
          backgroundColor: ColorResources.BOTTOM_BAR,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 0,
          items: [
            BottomNavigationBarItem(
              backgroundColor: ColorResources.BOTTOM_BAR,
              activeIcon: Container(
                  // height: 20,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Icon(
                        Icons.home,
                        size: 9,
                        color: Theme.of(context).canvasColor,
                      ),
                      Text("data"),
                    ],
                  )),
              icon: Image.asset(
                Images.bottom_bar_1,
                height: 25,
                width: 30,
              ),
              label: 'شاركنا الثواب',
            ),
            BottomNavigationBarItem(
              activeIcon: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Icon(
                        Icons.home,
                        size: 9,
                        color: Theme.of(context).canvasColor,
                      ),
                      Text("data")
                    ],
                  )),
              backgroundColor: ColorResources.BLACK,
              icon: Image.asset(
                Images.bottom_bar_2,
                height: 25,
                width: 30,
                color: ColorResources.BOTTOM_BAR_SELECTED,
              ),
              label: 'التصنيفات',
            ),
            BottomNavigationBarItem(
              activeIcon: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(15)),
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
        ),
      ),*/
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

class MyNavigationBar extends StatefulWidget {
  final bool openDrawer;
  MyNavigationBar(this.openDrawer);
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  bool? isDrawerToBeOpen;
  final _selectedItemColor = Colors.white;
  final _unselectedItemColor = Color(0xff8fd5f0);
  final _selectedBgColor = Color(0xff038EC2);
  final _unselectedBgColor = Color(0xff00A0DC);
  int _selectedIndex = 1;
  @override
  void initState() {
    // TODO: implement initState
    isDrawerToBeOpen = widget.openDrawer;
    _widgetOptions = [
      OnbordingScreen(),
      OnbordingScreen(),
      OnbordingScreen(),
    ];
    super.initState();
  }

  List<Widget> _widgetOptions = <Widget>[];

  // List<Widget> _widgetOptions = <Widget>[
  //   ProfileMessageSendingScreen(),
  //   HomePage(false),
  //   HomePage(false),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      isDrawerToBeOpen = false;
      _widgetOptions = [
        OnbordingScreen(),
        OnbordingScreen(),
        OnbordingScreen(),
      ];
    });
  }

  Color _getBgColor(int index) =>
      _selectedIndex == index ? _selectedBgColor : _unselectedBgColor;

  Color _getItemColor(int index) =>
      _selectedIndex == index ? _selectedItemColor : _unselectedItemColor;

  Widget _buildIcon(Image iconData, String text, int index) => Container(
        width: 85,
        height: 47,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: _getBgColor(index),
          ),
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                iconData,
                // Text(text,
                //     style:
                //         TextStyle(fontSize: 12, color: _getItemColor(index))),
              ],
            ),
            onTap: () => _onItemTapped(index),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        backgroundColor: Color(0xff00A0DC),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(
                Image.asset(
                  Images.bottom_bar_1,
                  height: 20,
                  color: _selectedIndex == 0 ? Colors.white : Color(0xff8fd5f0),
                ),
                'Cart',
                0),
            label: '',
            backgroundColor: Color(0xFF038EC2),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF038EC2),
            icon: _buildIcon(
                Image.asset(
                  Images.bottom_bar_1,
                  height: 20,
                  color: _selectedIndex == 1 ? Colors.white : Color(0xff8fd5f0),
                ),
                'Home',
                1),
            label: 'jhjh',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF038EC2),
            icon: _buildIcon(
                Image.asset(
                  Images.bottom_bar_1,
                  height: 20,
                  color: _selectedIndex == 2 ? Colors.white : Color(0xff8fd5f0),
                ),
                'School',
                2),
            label: 'nn',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _selectedItemColor,
        unselectedItemColor: _unselectedItemColor,
      ),
    );
  }
}
*/
