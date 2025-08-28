import 'package:expense_tracker/views/charts_screen.dart';
import 'package:expense_tracker/views/home_screen.dart';
import 'package:expense_tracker/views/insights_screen.dart';
import 'package:flutter/material.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int currentPageIndex = 0;
  final List<Map<String, dynamic>> tabs = [
    {'title': 'Home', 'screen': HomeScreen()},
    {'title': 'Insights', 'screen': InsightsScreen()},
    {'title': 'Charts', 'screen': ChartsScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     tabs[currentPageIndex]["title"],
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      //   ),
      // ),
      body: tabs[currentPageIndex]["screen"],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (value) {
          setState(() {
            currentPageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights_outlined),
            label: "Insights",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: "Charts",
          ),
        ],
      ),
    );
  }
}
