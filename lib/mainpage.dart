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
    int _selectedIndex = 0;


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

 void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
  pageController.animateToPage(
    index,
    duration: Duration(milliseconds: 300), // Duration of the animation
    curve: Curves.easeInOut, // The animation curve
  );
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: PageView(
      children: homeScreenItems,
      controller: pageController,
      onPageChanged: onPageChanged,
    ),
    bottomNavigationBar: Container(
      decoration: BoxDecoration(
        color: Colors.white, // Set the background color of the navbar to white
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Adjust the opacity as needed
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '日韓SNS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'メッセージ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_sharp),
          
            label: 'アプロード',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_rounded),
            label: 'グルメ辞書',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'プロフィール',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 138, 255, 114),
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent, // Make the BottomNavigationBar's background transparent
        type: BottomNavigationBarType.fixed, // Prevents the navbar from shifting
        elevation: 0, // Removes any existing elevation shadow
      ),
    ),
  );
}
}