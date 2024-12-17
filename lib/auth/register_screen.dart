import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/login_screen.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/core/cache_helper.dart';
import 'package:todo/core/service_locator.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/home_screen.dart';
import 'package:todo/widgets/default_elevated_button.dart';
import 'package:todo/widgets/default_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
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
                hintText: 'Name',
                validator: (value) {
                  if (value == null || value.trim().length < 5) {
                    return 'Name can not be less than 5 characters';
                  } else {
                    return null;
                  }
                },
                controller: nameController,
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                hintText: 'Email',
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
                hintText: 'Password',
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
                label: 'Register',
                onPressed: register,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
                child: const Text("Don't have an account"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    if (formKey.currentState!.validate()) {
      FirebaseFunctions.register(
        name: nameController.text,
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
