import 'package:flutter/material.dart';

import '../../../providers/providers.dart';
import '../../../helpers/helpers.dart';
import '../../../models/models.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  ChangePasswordFormState createState() => ChangePasswordFormState();
}

class ChangePasswordFormState extends State<ChangePasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _currentPassword = '', _newPassword = '';

  Widget _textField(
    String title, {
    bool isPassword = false,
    String? hintText,
    String? Function(String?)? validator,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    void Function(String?)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            onChanged: onChanged,
            keyboardType: keyboardType,
            focusNode: focusNode,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
            obscureText: isPassword,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              fillColor: const Color(0xfff3f3f4),
              filled: true,
            ),
          )
        ],
      ),
    );
  }

  Future<void> changePassword(bool skip) async {
    ChangePasswordAPIBody apiBody = ChangePasswordAPIBody(
      skip: skip,
      oldPassword: _currentPassword,
      newPassword: _newPassword,
    );
    DIOResponseBody response = await API().changePassword(apiBody);
    if (response.success) {
      Provider.of<UserProfileProvider>(context, listen: false).getUserProfile();
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.data)));
    }
  }

  Widget _changeButton(void Function()? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: const Text(
          'Change Password',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _skipLabel() {
    return InkWell(
      onTap: () {
        changePassword(true);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Skip',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'Change Password',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),

          _textField(
            'Current Password',
            isPassword: true,
            keyboardType: TextInputType.visiblePassword,
            onChanged: (value) {
              _currentPassword = value ?? '';
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Current password empty';
              }
              return null;
            },
          ), //current password
          _textField(
            'New Password',
            isPassword: true,
            keyboardType: TextInputType.visiblePassword,
            onChanged: (value) {
              _newPassword = value ?? '';
            },
            validator: (value) {
              if (value == null || value.isEmpty) return 'New password empty';
              return null;
            },
          ), //new password
          _textField(
            'Confirm Password',
            isPassword: true,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirm password empty';
              }
              if (value != _newPassword) return "Passwords don't match";
              return null;
            },
          ), //confirm password
          const SizedBox(height: 20),
          _changeButton(() {
            if (_formKey.currentState != null) {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                changePassword(false);
              }
            }
          }),
          _skipLabel(),
        ],
      ),
    );
  }
}
