import 'package:flutter/material.dart';
import 'package:myhealth/constants.dart';

class PasswordField extends StatefulWidget {
  final String hintText;

  const PasswordField({
    Key? key,
    required this.hintText,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState(
        hintText: hintText,
      );
}

class _PasswordFieldState extends State<PasswordField> {
  final String hintText;

  _PasswordFieldState({
    required this.hintText,
  }) : super();

  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscured,
      cursorColor: kBlack,
      focusNode: textFieldFocusNode,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.black54,
        ),
        suffixIcon: GestureDetector(
          onTap: _toggleObscured,
          child: Icon(
            _obscured ? Icons.visibility_rounded : Icons.visibility_off_rounded,
          ),
        ),
        border: InputBorder.none,
      ),
    );
  }
}
