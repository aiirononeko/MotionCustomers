import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motion_customers/service/firestore_customize.dart';
import 'package:motion_customers/service/validators.dart';
import 'package:motion_customers/ui/home_screen/home_screen.dart';

import '../../service/hex_color.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: LoginForm()
    );
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
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: <Widget>[
            TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email *',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) {
                  return Validator.emailValidate(value!);
                },
                onChanged: _handleEmail
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password *',
                suffixIcon: IconButton(
                  icon:  Icon(_isVisiblePassword ? Icons.visibility : Icons.visibility_off) ,
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
            ElevatedButton(
              child: const Text('REGISTER'),
              onPressed: () async {
                // 入力値のチェック
                if (Validator.emailValidate(_email) == null
                    && Validator.passwordValidate(_password) == null) {

                  try {

                    // ログイン
                    await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);

                    // Home画面に遷移
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const HomeScreen()
                    ));

                  } catch (_) {}
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(width * 0.45, height * 0.065),
                primary: HexColor('FC2951'), // ボタンの背景色
              ),
            ),
          ],
        )
    );
  }
}
