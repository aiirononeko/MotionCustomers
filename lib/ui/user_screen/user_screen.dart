import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motion_customers/service/firestore_service.dart';
import 'package:motion_customers/ui/first_screen/first_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/hex_color.dart';
import '../../utils/widget_utils.dart';
import '../../view_model/user_view_model.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 顧客情報を取得してエンティティにセット
    Provider.of<UserViewModel>(context).init();

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      width: width * 1,
      margin: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: width * 0.6,
                  margin: EdgeInsets.only(right: width * 0.2),
                  child: SvgPicture.asset("images/MotionLogoMain.svg")
              ),
            ],
          ),
          Text(
              "ID: ${context.read<UserViewModel>().customer.uid}",
              style: TextStyle(
                fontSize: width * 0.03,
              ),
          ),
          SizedBox(
            height: height * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: height * 0.02),
                  child: InkWell(
                      onTap: () async {

                        WidgetUtils().showProgressDialog(context);

                        final functions = FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'asia-northeast1');
                        final callable = functions.httpsCallable('ext-firestore-stripe-payments-createPortalLink');
                        final results = await callable.call({
                          "return_url": 'https://motion-dev-d0877.web.app'
                        });

                        launchUrl(
                            Uri.parse(results.data['url'])
                        );

                        Navigator.pop(context);

                      },
                      child: Text(
                        "購入情報",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: width * 0.03,
                        ),
                      )
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: height * 0.02),
                  child: InkWell(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              content: const Text("ログアウトします。よろしいですか？"),
                              actions: <Widget>[
                                // ボタン領域
                                ElevatedButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: HexColor('FC2951')
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(width * 0.3, height * 0.065),
                                    primary: HexColor('FFFFFF'), // ボタンの背景色
                                    side: BorderSide(
                                      color: HexColor('FC2951'), //色
                                      width: 1, //太さ
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                ElevatedButton(
                                  child: const Text("OK"),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(width * 0.3, height * 0.065),
                                    primary: HexColor('FC2951'), // ボタンの背景色
                                  ),
                                  onPressed: () async {
                                    try {

                                      // ログアウト
                                      await FirebaseAuth.instance.signOut();

                                      // First画面に遷移
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => const FirstScreen(),
                                          ),
                                              (route) => false);

                                    } catch (_) {}
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "ログアウト",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: width * 0.03,
                        ),
                      )
                  ),
                ),
                InkWell(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: const Text("Motion.から退会します。一度退会すると獲得したポイントやコーヒーチケットは失われます。よろしいですか？"),
                            actions: <Widget>[
                              // ボタン領域
                              ElevatedButton(
                                child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: HexColor('FC2951')
                                    ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(width * 0.3, height * 0.065),
                                  primary: HexColor('FFFFFF'), // ボタンの背景色
                                  side: BorderSide(
                                    color: HexColor('FC2951'), //色
                                    width: 1, //太さ
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(width * 0.3, height * 0.065),
                                  primary: HexColor('FC2951'), // ボタンの背景色
                                ),
                                child: const Text("OK"),

                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        content: const Text("本当に退会してよろしいですか？"),
                                        actions: <Widget>[
                                          // ボタン領域
                                          ElevatedButton(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: HexColor('FC2951')
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(width * 0.3, height * 0.065),
                                              primary: HexColor('FFFFFF'), // ボタンの背景色
                                              side: BorderSide(
                                                color: HexColor('FC2951'), //色
                                                width: 1, //太さ
                                              ),
                                            ),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(width * 0.3, height * 0.065),
                                              primary: HexColor('FC2951'), // ボタンの背景色
                                            ),
                                            child: const Text("OK"),

                                            onPressed: () async {
                                              try {

                                                String uid = FirebaseAuth.instance.currentUser!.uid;

                                                // 退会処理
                                                // UIDをFirestoreに登録(登録をトリガーにCloudFunctionが走る)
                                                await FirestoreService().createWithdrawCustomer(uid);

                                                // 念の為サインアウト
                                                if (FirebaseAuth.instance.currentUser != null) {
                                                  await FirebaseAuth.instance.signOut();
                                                }

                                                // First画面に遷移
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext context) => const FirstScreen(),
                                                    ),
                                                        (route) => false);

                                              } catch (_) {}
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "退会する",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: width * 0.03,
                      ),
                    )
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}
