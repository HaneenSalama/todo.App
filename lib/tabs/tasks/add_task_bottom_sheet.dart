import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/core/cache_helper.dart';
import 'package:todo/core/service_locator.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';
import 'package:todo/widgets/default_elevated_button.dart';
import 'package:todo/widgets/default_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextStyle titleMediumStyle = Theme.of(context).textTheme.titleMedium!;
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: settingsProvider.isDark ? AppTheme.blueBlack : AppTheme.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                appLocalizations.addNewTask,
                style: titleMediumStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                hintText: appLocalizations.enterTaskTitle,
                controller: titleController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                hintText: appLocalizations.enterTaskDescription,
                controller: descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(appLocalizations.selectDate,
                  style: titleMediumStyle.copyWith()),
              const SizedBox(height: 4),
              InkWell(
                onTap: () async {
                  DateTime? dateTime = await showDatePicker(
                    context: context,
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );

                  if (dateTime != null && dateTime != selectedDate) {
                    setState(() {
                      selectedDate = dateTime;
                    });
                  }
                },
                child: Text(
                  dateFormat.format(selectedDate),
                  style: titleMediumStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              DefaultElevatedButton(
                height: 48,
                width: MediaQuery.of(context).size.width,
                label: appLocalizations.addTask,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    addTask();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTask() {
    TaskModel task = TaskModel(
      title: titleController.text,
      description: descriptionController.text,
      date: selectedDate,
    );
    String userId = getIt<CacheHelper>().getData(key: 'id');
    FirebaseFunctions.addTaskToFirestore(task, userId).then(
      (_) {
        Navigator.of(context).pop();
        Provider.of<TasksProvider>(context, listen: false).getTasks(userId);
        Fluttertoast.showToast(
          msg: "Task added successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.green,
          textColor: AppTheme.white,
          fontSize: 16.0,
        );
      },
    ).catchError(
      (error) {
        debugPrint(error);
        Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.red,
          textColor: AppTheme.white,
          fontSize: 16.0,
        );
      },
    );
  }
}
