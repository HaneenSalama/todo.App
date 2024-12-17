import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/core/cache_helper.dart';
import 'package:todo/core/service_locator.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/task_item.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  bool shouldGetTasks = true;
  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    String userId = getIt<CacheHelper>().getData(key: 'id');
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    if (shouldGetTasks) {
      tasksProvider.getTasks(userId);
      shouldGetTasks = false;
    }

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.2,
              color: AppTheme.primary,
            ),
            PositionedDirectional(
              top: 20,
              start: 12,
              child: SafeArea(
                child: Text(
                  appLocalizations.todoList,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: settingsProvider.isDark
                          ? AppTheme.backgroundDark
                          : AppTheme.white),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.15),
              child: EasyInfiniteDateTimeLine(
                locale: settingsProvider.languageCode,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                focusDate: tasksProvider.selectedDate,
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChange: (selectedDate) {
                  tasksProvider.getSelectedDateTasks(selectedDate, userId);
                },
                showTimelineHeader: false,
                dayProps: EasyDayProps(
                  height: 79,
                  width: 58,
                  dayStructure: DayStructure.dayStrDayNum,
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: settingsProvider.isDark
                          ? AppTheme.blueBlack
                          : AppTheme.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    dayStrStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                    dayNumStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: settingsProvider.isDark
                          ? AppTheme.blueBlack
                          : AppTheme.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: settingsProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: settingsProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                  ),
                  todayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: settingsProvider.isDark
                          ? AppTheme.blueBlack
                          : AppTheme.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: settingsProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: settingsProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => TaskItem(
              task: tasksProvider.tasks[index],
            ),
            itemCount: tasksProvider.tasks.length,
          ),
        ),
      ],
    );
  }
}
