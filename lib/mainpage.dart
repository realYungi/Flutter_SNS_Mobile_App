import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/global_variables.dart';
import 'package:uridachi/pages/home_page.dart';
import 'package:uridachi/screen/add_post.dart';
import 'package:uridachi/static/colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();

  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();

  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);

  }

  void onPageChanged (int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,


      ),
      bottomNavigationBar: CupertinoTabBar(
      
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? selectedColor : unselectedColor,
            ),
            label: 'Homepage',
            
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              color: _page == 1 ? selectedColor : unselectedColor,
            ),
            label: 'Chat',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box,               color: _page == 2 ? selectedColor: unselectedColor,
),
            label: 'Add Post',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank,               color: _page == 3 ? selectedColor: unselectedColor,
),
            label: 'Gourmet',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,               color: _page == 4 ? selectedColor: unselectedColor,
),
            label: 'Profile',
            backgroundColor: Colors.white,
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
