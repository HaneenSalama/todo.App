import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/settings/settings_tab.dart';
import 'package:todo/tabs/tasks/add_task_bottom_sheet.dart';
import 'package:todo/tabs/tasks/tasks_tab.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs = [
    TasksTab(),
    SettingsTab(),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: settingsProvider.isDark ? AppTheme.blueBlack : AppTheme.white,
        padding: EdgeInsets.zero,
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: currentIndex,
          onTap: (selectedIndex) {
            currentIndex = selectedIndex;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                size: 32,
              ),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 32,
              ),
              label: 'Settings',
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => AddTaskBottomSheet(),
        ),
        child: Icon(
          Icons.add,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
