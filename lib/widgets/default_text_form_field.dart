import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/tabs/settings/settings_provider.dart';

class DefaultTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPass;
  final String? initialValue;
  const DefaultTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.isPass = false,
    this.initialValue,
  });

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  late bool isObscure = widget.isPass;
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return TextFormField(
      initialValue: widget.initialValue,
      cursorColor: AppTheme.primary,
      style: TextStyle(
        color: settingsProvider.isDark ? AppTheme.white : AppTheme.black,
        fontWeight: FontWeight.w700,
      ),
      controller: widget.controller,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: settingsProvider.isDark ? AppTheme.gray : Color(0xff707070),
        ),
        suffixIcon: widget.isPass
            ? IconButton(
                onPressed: () {
                  isObscure = !isObscure;
                  setState(() {});
                },
                icon: Icon(
                  isObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: settingsProvider.isDark
                      ? AppTheme.gray
                      : Color(0xff707070),
                ),
              )
            : null,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.primary,
          ),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: isObscure,
    );
  }
}
