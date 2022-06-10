import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motion_customers/service/firestore_service.dart';
import 'package:motion_customers/service/validators.dart';
import 'package:motion_customers/ui/home_screen/home_screen.dart';
import 'package:motion_customers/view_model/register_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/hex_color.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        resizeToAvoidBottomInset: false, body: RegisterForm());
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
      margin: EdgeInsets.fromLTRB(width * 0.1, height * 0.02, width * 0.1, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: width * 0.6,
              child: SvgPicture.asset("images/MotionLogoMain.svg")),
          SizedBox(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: height * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: width * 0.13),
                      child: Text(
                        "新規登録",
                        style: TextStyle(fontSize: height * 0.03),
                      ),
                    ),
                  ],
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
              TextFormField(
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
              Container(
                margin: EdgeInsets.only(bottom: height * 0.04),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password *',
                    suffixIcon: IconButton(
                      icon: Icon(_isVisibleConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isVisibleConfirmPassword =
                              !_isVisibleConfirmPassword;
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
              ),
              InkWell(
                onTap: () async {
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: height * 0.0),
                  child: Text(
                    "利用規約",
                    style: TextStyle(
                      fontSize: height * 0.015,
                      wordSpacing: 0,
                      letterSpacing: 0.5,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(right: width * 0.08, bottom: height * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: context
                          .select((RegisterViewModel value) => value.flag),
                      onChanged:
                          context.read<RegisterViewModel>().handleCheckbox,
                      activeColor: Colors.black,
                    ),
                    Text(
                      "利用規約確認の上、同意する",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.015,
                        wordSpacing: 0,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text('REGISTER'),
                onPressed: !context
                        .select((RegisterViewModel value) => value.flag)
                    ? null
                    : () async {
                        // 入力値のチェック
                        if (Validator.emailValidate(_email) == null &&
                            Validator.passwordValidate(_password) == null &&
                            Validator.confirmPasswordValidate(
                                    _password, _confirmPassword) ==
                                null) {
                          try {
                            // FirebaseAuthにユーザー登録
                            UserCredential credential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                                    email: _email, password: _password);

                            // Firestoreに登録
                            await FirestoreService().createCustomerInfo(
                                _email, credential.user!.uid);

                            // Home画面に遷移
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'email-already-in-use') {
                              showDialog(
                                context: context,
                                builder: (_) => const CupertinoAlertDialog(
                                      content: Text("このユーザーはすでに存在しています。"),
                                    ));
                            }
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(width * 0.45, height * 0.065),
                  primary: HexColor('FC2951'), // ボタンの背景色
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
