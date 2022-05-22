import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../providers/providers.dart';
import '../../../models/models.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final double height;
  LoginForm({
    required this.formKey,
    required this.height,
  });
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _devModeSwitchValue = false;
  final _passwordFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final LoginAPIBody loginValues = LoginAPIBody();

  Widget _textField(
    String title, {
    bool isPassword = false,
    String? hintText,
    String? Function(String?)? validator,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    void Function(String?)? onSaved,
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
            onSaved: onSaved,
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

  Widget _loginButton(void Function()? onPressed) {
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
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  void changeDevModeValue(bool value) {
    setState(() {
      _devModeSwitchValue = value;
    });
  }

  Widget _emailPasswordWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _textField(
          "Email id",
          focusNode: _usernameFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          hintText: 'JohnDoe@example.com',
          keyboardType: TextInputType.emailAddress,
          onSaved: (value) {
            loginValues.username = value;
          },
          validator: (value) {
            if (value!.isEmpty) return 'Please Enter the Email';
            if (!TextHelper().validateEmail(value)) return 'Enter Valid Email';
            return null;
          },
        ),
        _textField(
          "Password",
          isPassword: true,
          focusNode: _passwordFocusNode,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          onSaved: (value) {
            loginValues.password = value;
          },
          validator: (value) {
            if (value!.isEmpty) return 'Please enter the password';
            return null;
          },
        ),
      ],
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'flutter',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: const [
            TextSpan(
              text: 'base',
              style: TextStyle(color: Colors.black54, fontSize: 30),
            ),
            TextSpan(
              text: 'plate',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: const <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        context.push('/signup');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Signup',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void performLogin(
        Function assignToken, Function changeFirstLoginStatus) async {
      if (widget.formKey.currentState == null) {
        debugPrint('emptyformkey');
      } else if (widget.formKey.currentState!.validate()) {
        widget.formKey.currentState!.save();
        DIOResponseBody response;
        if (_devModeSwitchValue) {
          response = await API().userLogin(Constants.devUser);
        } else {
          response = await API().userLogin(loginValues);
        }
        if (response.success) {
          assignToken(response.data['accessToken']);
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.data),
            ),
          );
        }
      }
    }

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: widget.height * .2),
          _title(),
          const SizedBox(height: 50),
          _emailPasswordWidget(),
          const SizedBox(height: 20),
          Consumer<UserStateProvider>(
            builder: (_, data, __) => _loginButton(
              () {
                if (Constants.bypassBackend) {
                  data.assignAccessToken(Constants.devAccessToken);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  return;
                }
                performLogin(
                    data.assignAccessToken, data.changeFirstLoginStatus);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerRight,
            child: const Text('Forgot Password ?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          _divider(),
          SizedBox(height: widget.height * .055),
          _createAccountLabel(),
        ],
      ),
    );
  }
}
