import 'package:flutter/material.dart';
import 'package:yourchat/consts.dart';

class Customformfield extends StatelessWidget {
  Customformfield(
      {super.key, this.hinttext, this.onChanged, this.obscureText = false});
  String? hinttext;
  Function(String)? onChanged;
  TextEditingController mycontroller = TextEditingController();
  bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      controller: mycontroller,
      validator: (data) {
        if (data!.isEmpty) {
          return "feild is required";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: hinttext,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: kSecoundPrimaryColor)),
          hintStyle: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.normal),
          contentPadding: const EdgeInsets.all(10),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.grey,
              ))),
      onChanged: onChanged,
    );
  }
}
