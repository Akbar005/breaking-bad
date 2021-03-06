import 'package:flutter/material.dart';

import '../../constants.dart';
import '../cenema_screen/cenema_screen.dart';
import '../map_screen/map_screen.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  AnimationController _controller;

  final List _tabIcons = List.unmodifiable([
    {'icon': Icons.hail, 'title': 'Cenema'},
    {'icon': Icons.map, 'title': 'Map'}
  ]);

  final List<Widget> _tabs =
      List.unmodifiable([const CenemaScreen(), const MapScreen()]);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 1,
      upperBound: 1.3,
    );
  }

  void onTabChanged(int index) {
    setState(() => currentIndex = index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[currentIndex],
      bottomNavigationBar: navbar(
        _tabIcons,
        currentIndex,
        onTabChanged,
      ),
    );
  }

  navbar(List _tabIcons, int activeIndex, ValueChanged<int> onTabChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            color: kShadowColor.withOpacity(0.14),
            blurRadius: 25,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_tabIcons.length, (index) {
          return navbaritem(
            index,
            activeIndex,
            _tabIcons[index],
            onTabChanged,
          );
        }),
      ),
    );
  }

  navbaritem(int index, int activeIndex, dynamic icon,
      ValueChanged<int> onTabChanged) {
    return InkWell(
      onTap: () {
        if (index != activeIndex) {
          onTabChanged(index);
          _controller.forward().then((value) => _controller.reverse());
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ScaleTransition(
            scale: _controller,
            child: Icon(icon['icon'],
                color: activeIndex == index ? kPrimaryColor : null),
          ),
          Text(
            icon['title'],
            style:
                TextStyle(color: activeIndex == index ? kPrimaryColor : null),
          ),
        ],
      ),
    );
  }
}
