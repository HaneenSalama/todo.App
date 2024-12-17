import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

class UpdateTaskScreen extends StatefulWidget {
  const UpdateTaskScreen({super.key});
  static const routeName = 'updateTaskScreen';

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TaskModel task = ModalRoute.of(context)?.settings.arguments as TaskModel;

    if (selectedDate == null) {
      selectedDate = task.date;
    }
    titleController.text = task.title;
    descriptionController.text = task.description;
    TextStyle titleMediumStyle = Theme.of(context).textTheme.titleMedium!;
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        title: Text(
          appLocalizations.todoList,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppTheme.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: size.width,
                  height: size.height * 0.1,
                  color: AppTheme.primary,
                ),
                Center(
                  child: Container(
                    height: size.height * 0.7,
                    width: size.width * 0.88,
                    margin: EdgeInsets.only(top: 25),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: settingsProvider.isDark
                          ? AppTheme.blueBlack
                          : AppTheme.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            appLocalizations.updateTask,
                            style: titleMediumStyle,
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
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
                          Text(
                            appLocalizations.selectDate,
                            style: titleMediumStyle.copyWith(),
                          ),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () async {
                              DateTime? dateTime = await showDatePicker(
                                context: context,
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                                initialDate: selectedDate,
                                firstDate: selectedDate!,
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );

                              if (dateTime != null &&
                                  dateTime != selectedDate) {
                                setState(() {
                                  selectedDate = dateTime;
                                });
                              }
                            },
                            child: Text(
                              dateFormat.format(selectedDate!),
                              style: titleMediumStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Spacer(flex: 2),
                          DefaultElevatedButton(
                            height: 48,
                            width: size.width,
                            label: appLocalizations.confirmUpdateTask,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                updateTask(
                                  task.copyWith(
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    date: selectedDate,
                                    isDone: false,
                                  ),
                                );
                              }
                            },
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void updateTask(TaskModel task) {
    String userId = getIt<CacheHelper>().getData(key: 'id');
    FirebaseFunctions.updateTaskFromFirestore(task.id, userId, task).then(
      (_) {
        Navigator.of(context).pop();
        Provider.of<TasksProvider>(context, listen: false).getTasks(userId);
        Fluttertoast.showToast(
          msg: "Task updated successfully",
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
