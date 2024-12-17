import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/register_screen.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/core/cache_helper.dart';
import 'package:todo/core/service_locator.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/home_screen.dart';
import 'package:todo/widgets/default_elevated_button.dart';
import 'package:todo/widgets/default_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations.login,
          style:
              Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 26),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextFormField(
                hintText: appLocalizations.email,
                validator: (value) {
                  if (value == null || value.trim().length < 5) {
                    return 'Email can not be less than 5 characters';
                  } else {
                    return null;
                  }
                },
                controller: emailController,
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                hintText: appLocalizations.password,
                isPass: true,
                validator: (value) {
                  if (value == null || value.trim().length < 8) {
                    return 'Password can not be less than 8 characters';
                  } else {
                    return null;
                  }
                },
                controller: passwordController,
              ),
              const SizedBox(height: 32),
              DefaultElevatedButton(
                height: 56,
                width: MediaQuery.of(context).size.width,
                label: appLocalizations.login,
                onPressed: () {
                  login();
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(RegisterScreen.routeName);
                },
                child: const Text("Don't have an account"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void login() {
    if (formKey.currentState!.validate()) {
      FirebaseFunctions.login(
        email: emailController.text,
        password: passwordController.text,
      ).then(
        (user) {
          getIt<CacheHelper>().saveData(key: 'id', value: user.id);
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        },
      ).catchError(
        (error) {
          String? message;
          if (error is FirebaseAuthException) {
            message = error.message;
          }
          Fluttertoast.showToast(
            msg: message ?? "Something went wrong",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: AppTheme.red,
          );
        },
      );
    }
  }
}
