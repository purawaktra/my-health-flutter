import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const InputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      cursorColor: kBlack,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.black54,
        ),
        hintText: hintText,
        border: InputBorder.none,
      ),
    );
  }
}
