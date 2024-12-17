import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/core/cache_helper.dart';
import 'package:todo/core/service_locator.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/tabs/tasks/update_task_screen.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    TextTheme textTheme = Theme.of(context).textTheme;
    String userId = getIt<CacheHelper>().getData(key: 'id');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                FirebaseFunctions.deleteTaskFromFirestore(task.id, userId).then(
                  (_) {
                    Provider.of<TasksProvider>(context, listen: false)
                        .getTasks(userId);
                  },
                );
              },
              borderRadius: BorderRadius.horizontal(
                left: settingsProvider.languageCode == 'en'
                    ? const Radius.circular(15)
                    : Radius.zero,
                right: settingsProvider.languageCode == 'ar'
                    ? const Radius.circular(15)
                    : Radius.zero,
              ),
              backgroundColor: AppTheme.red,
              foregroundColor: AppTheme.white,
              icon: Icons.delete,
              label: appLocalizations.delete,
            ),
            SlidableAction(
              onPressed: (_) {
                Navigator.of(context).pushNamed(
                  UpdateTaskScreen.routeName,
                  arguments: task,
                );
              },
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: appLocalizations.edit,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color:
                settingsProvider.isDark ? AppTheme.blueBlack : AppTheme.white,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                height: 62,
                width: 4,
                color: task.isDone ? AppTheme.green : AppTheme.primary,
                margin: const EdgeInsetsDirectional.only(end: 12),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: textTheme.titleMedium!.copyWith(
                        color: task.isDone ? AppTheme.green : AppTheme.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: textTheme.titleMedium!.copyWith(
                        color: task.isDone ? AppTheme.green : AppTheme.primary),
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  FirebaseFunctions.updateTaskFromFirestore(
                          task.id, userId, task.copyWith(isDone: !task.isDone))
                      .then((_) {
                    Provider.of<TasksProvider>(context, listen: false)
                        .getTasks(userId);
                  });
                },
                child: task.isDone
                    ? Text(
                        appLocalizations.doneTask,
                        style: textTheme.titleMedium!
                            .copyWith(fontSize: 24, color: AppTheme.green),
                      )
                    : Container(
                        height: 34,
                        width: 69,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppTheme.white,
                          size: 32,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
