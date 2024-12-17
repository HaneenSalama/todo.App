import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/login_screen.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/core/cache_helper.dart';
import 'package:todo/core/service_locator.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/tabs/settings/language.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  List<Language> languages = [
    Language(name: 'English', code: 'en'),
    Language(name: 'العربية', code: 'ar')
  ];

  // List<DropdownMenuItem<dynamic>> dropdownMenuItem = [
  //   DropdownMenuItem(value: true, child: Text('Dark')),
  //   DropdownMenuItem(value: false, child: Text('light')),
  // ];

  bool isDarkTheme = false;
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width,
          height: size.height * 0.2,
          color: AppTheme.primary,
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              top: 20,
              start: 12,
            ),
            child: SafeArea(
              child: Text(
                appLocalizations.todoList,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppTheme.white),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appLocalizations.logout,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    onPressed: () {
                      FirebaseFunctions.logout();
                      getIt<CacheHelper>().removeData(key: 'id');
                      Provider.of<TasksProvider>(context, listen: false)
                          .reset();
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
                    icon: Icon(
                      Icons.logout,
                      size: 32,
                      color: settingsProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                appLocalizations.language,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: settingsProvider.isDark
                      ? AppTheme.backgroundDark
                      : Colors.white,
                  border: Border.all(
                    color: AppTheme.primary,
                    width: 1.5,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Language>(
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    value: languages.firstWhere(
                      (language) =>
                          language.code == settingsProvider.languageCode,
                    ),
                    items: languages
                        .map(
                          (language) => DropdownMenuItem(
                            value: language,
                            child: Text(
                              language.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      settingsProvider.changeLanguage(value!.code);
                    },
                    iconEnabledColor: AppTheme.primary,
                    icon: Icon(Icons.arrow_drop_down_rounded),
                    iconSize: 42,
                    dropdownColor: settingsProvider.isDark
                        ? AppTheme.blueBlack
                        : AppTheme.white,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Text(
                appLocalizations.theme,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: settingsProvider.isDark
                      ? AppTheme.backgroundDark
                      : Colors.white,
                  border: Border.all(
                    color: AppTheme.primary,
                    width: 1.5,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    value: settingsProvider.isDark,
                    items: [
                      DropdownMenuItem(
                          value: true, child: Text(appLocalizations.dark)),
                      DropdownMenuItem(
                          value: false, child: Text(appLocalizations.light)),
                    ],
                    onChanged: (isDark) {
                      settingsProvider.changeTheme(
                          isDark! ? ThemeMode.dark : ThemeMode.light);
                    },
                    iconEnabledColor: AppTheme.primary,
                    icon: Icon(Icons.arrow_drop_down_rounded),
                    iconSize: 42,
                    dropdownColor: settingsProvider.isDark
                        ? AppTheme.blueBlack
                        : AppTheme.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
