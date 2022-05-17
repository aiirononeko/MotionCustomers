import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motion_customers/service/firestore_customize.dart';
import 'package:motion_customers/service/validators.dart';
import 'package:motion_customers/ui/home_screen/home_screen.dart';

import '../../service/hex_color.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: RegisterForm()
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterForm createState() => _RegisterForm();
}

class _RegisterForm extends State<RegisterForm> {

  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  bool _isVisiblePassword = false;
  bool _isVisibleConfirmPassword = false;

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

  void _handleConfirmPassword(String confirmPassword) {
    setState(() {
      _confirmPassword = confirmPassword;
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
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm Password *',
                suffixIcon: IconButton(
                  icon:  Icon(_isVisibleConfirmPassword ? Icons.visibility : Icons.visibility_off) ,
                  onPressed: () {
                    setState(() {
                      _isVisibleConfirmPassword = !_isVisibleConfirmPassword;
                    });
                  },
                ),
              ),
              obscureText: !_isVisibleConfirmPassword,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                return Validator.confirmPasswordValidate(_password, value!);
              },
              onChanged: _handleConfirmPassword,
            ),
            ElevatedButton(
              child: const Text('REGISTER'),
              onPressed: () async {
                // 入力値のチェック
                if (Validator.emailValidate(_email) == null
                    && Validator.passwordValidate(_password) == null
                    && Validator.confirmPasswordValidate(_password, _confirmPassword) == null) {

                  try {

                    // FirebaseAuthにユーザー登録
                    UserCredential credential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);

                    // Firestoreに登録
                    await FirestoreCustomize.createCustomerInfo(_email, credential.user!.uid);

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
