import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/home_page.dart';
import 'package:flutter_trip/pages/my_page.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/pages/travel_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigator createState() {
    return _TabNavigator();
  }
}

class _TabNavigator extends State<TabNavigator> {
  final PageController _controller = PageController(initialPage: 0);
  final Color _defaultColor = Colors.grey;
  final Color _activeColor = Colors.blue;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [
          HomePage(),
          SearchPage(),
          TravelPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          _createBottomNavigatorBarItem(Icons.home, '首页', 0),
          _createBottomNavigatorBarItem(Icons.search, '搜索', 1),
          _createBottomNavigatorBarItem(Icons.camera_alt, '旅拍', 2),
          _createBottomNavigatorBarItem(Icons.account_circle, '我的', 3),
        ],
      ),
    );
  }

  _createBottomNavigatorBarItem(icon, title, index) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ),
        label: title);
  }
}
