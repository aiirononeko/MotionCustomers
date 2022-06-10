import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motion_customers/service/validators.dart';
import 'package:motion_customers/ui/home_screen/home_screen.dart';

import '../../service/hex_color.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(resizeToAvoidBottomInset: false, body: LoginForm());
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginForm createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> {
  String _email = "";
  String _password = "";
  bool _isVisiblePassword = false;

  final String url =
      "https://riverbedcoffee-brewer-roastery.com/policies/terms-of-service";

  void _handleEmail(String email) {
    setState(() {
      _email = email;
    });
  }

  void _handlePassword(String password) {
    setState(() {
      _password = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.fromLTRB(width * 0.1, height * 0.02, width * 0.1, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: width * 0.6,
              child: SvgPicture.asset("images/MotionLogoMain.svg")),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          SizedBox(
            height: height * 0.42,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: height * 0.03),
                  child: Text(
                    "ログイン",
                    style: TextStyle(fontSize: height * 0.03),
                  ),
                ),
                TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email *',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      return Validator.emailValidate(value!);
                    },
                    onChanged: _handleEmail),
                Container(
                  margin: EdgeInsets.only(bottom: height * 0.05),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password *',
                      suffixIcon: IconButton(
                        icon: Icon(_isVisiblePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isVisiblePassword = !_isVisiblePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isVisiblePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      return Validator.passwordValidate(value!);
                    },
                    onChanged: _handlePassword,
                  ),
                ),
                ElevatedButton(
                  child: Text(
                    'LOG IN',
                    style: TextStyle(color: HexColor('FC2951')),
                  ),
                  onPressed: () async {
                    // 入力値のチェック
                    if (Validator.emailValidate(_email) == null &&
                        Validator.passwordValidate(_password) == null) {
                      try {
                        // ログイン
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _email, password: _password);

                        // Home画面に遷移
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showDialog(
                            context: context,
                            builder: (_) => const CupertinoAlertDialog(
                              content: Text("メールアドレスが違います。"),
                            ),
                          );
                        } else if (e.code == 'wrong-password') {
                          showDialog(
                            context: context,
                            builder: (_) => const CupertinoAlertDialog(
                              content: Text("パスワードが違います。"),
                            ),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width * 0.45, height * 0.065),
                    primary: HexColor('FFFFFF'), // ボタンの背景色
                    side: BorderSide(
                      color: HexColor('FC2951'), //色
                      width: 1, //太さ
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
