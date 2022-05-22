import 'package:flutter/material.dart';

class SignupTextField extends StatelessWidget {
  final String? label, hint;
  final TextInputType? type;
  final TextInputAction? action;
  final Function? validator, onSaved, onSubmit;
  final FocusNode? focusNode;
  final bool? isPassword;
  const SignupTextField({
    Key? key,
    this.hint,
    this.label,
    this.action,
    this.onSubmit,
    this.onSaved,
    this.type,
    this.validator,
    this.focusNode,
    this.isPassword,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        onChanged: onSaved as void Function(String?)?,
        keyboardType: type,
        focusNode: focusNode,
        onFieldSubmitted: onSubmit as void Function(String)?,
        validator: validator as String? Function(String?)?,
        obscureText: isPassword == null ? false : isPassword!,
        textInputAction: action,
        decoration: InputDecoration(
          hintText: label,
          border: InputBorder.none,
          fillColor: const Color(0xfff3f3f4),
          filled: true,
        ),
      ),
    );
  }
}
