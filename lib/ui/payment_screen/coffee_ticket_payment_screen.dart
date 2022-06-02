import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motion_customers/service/firestore_service.dart';
import 'package:motion_customers/ui/home_screen/home_screen.dart';
import 'package:motion_customers/utils/widget_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/payment.dart';
import '../../view_model/home_view_model.dart';

class CoffeeTicketPaymentScreen extends StatefulWidget {
  const CoffeeTicketPaymentScreen({Key? key}) : super(key: key);

  @override
  _CoffeeTicketPaymentScreen createState() => _CoffeeTicketPaymentScreen();
}

class _CoffeeTicketPaymentScreen extends State<CoffeeTicketPaymentScreen> {

  final url = "https://riverbedcoffee-brewer-roastery.com/policies/terms-of-service";
  bool _flag = false;
  final priceId = "price_1L4bOqFnaADmyp9oJSf3LEQl";

  @override
  void initState() {
    super.initState();
  }

  void _handleCheckbox(bool? e) {
    if (e != null) {
      setState(() {
        _flag = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(width * 0.1, height * 0.05, width * 0.1, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: width * 0.6,
                height: height * 0.18,
                child: SvgPicture.asset("images/MotionLogoMain.svg")
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, height * 0.01, 0, 0),
                    child: Text(
                      "Coffee Ticket",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.03,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, height * 0.025, 0, 0),
                    child: Text(
                      "5000円で、800円までのドリンクと交換できるコーヒーチケット11枚を購入しよう。",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.015,
                        wordSpacing: 0,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, height * 0.06, 0, 0),
                    child: Text(
                      "コーヒーチケットなしで11杯コーヒーを飲む場合...",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.015,
                        wordSpacing: 0,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, height * 0.015, 0, 0),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(width * 0.03, height * 0.005, width * 0.03, height * 0.005),
                          color: Colors.black,
                          child: Text(
                            "通常",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: height * 0.015,
                              color: Colors.white,
                              wordSpacing: 0,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
                          child: Text(
                            "800円×11杯=8800円",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: height * 0.015,
                              wordSpacing: 0,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(width * 0.165, height * 0.015, 0, 0),
                    padding: EdgeInsets.fromLTRB(0, height * 0.01, 0, height * 0.01),
                    width: width * 0.5,
                    color: Colors.yellowAccent,
                    alignment: Alignment.center,
                    child: Text(
                      "3300円お得！",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.015,
                        wordSpacing: 0,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0, height * 0.10, 0, 0),
                        padding: EdgeInsets.fromLTRB(0, height * 0.013, 0, height * 0.013),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(width * 0.03, 0, 0, 0),
                              child: Text(
                                "利用規約",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.015,
                                  wordSpacing: 0,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(width * 0.02, 0, 0, 0),
                              child: Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: height * 0.015,
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, height * 0.01, width * 0.08, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _flag,
                          onChanged: _handleCheckbox,
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
                  Container(
                    padding: EdgeInsets.fromLTRB(0, height * 0.03, 0, 0),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          padding: EdgeInsets.fromLTRB(width * 0.15, height * 0.02, width * 0.15, height * 0.02)
                      ),
                      onPressed: !_flag? null: () async {

                        final uid = FirebaseAuth.instance.currentUser!.uid;
                        final customer = await FirestoreService().fetchCustomerInfo(uid);
                        if (customer.isPremium) {
                          // プレミアム会員の場合は決済しない
                          // HomeScreenにルーティング
                          context.read<HomeViewModel>().setIndex(0);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => const HomeScreen(),
                              ),
                                  (route) => false);

                          showDialog(
                              context: context,
                              builder: (_) => const CupertinoAlertDialog(
                                content: Text("すでにプレミアム会員です。"),
                              ));
                        } else {
                          // customers/{uid}/checkout_sessionsにDocを作成する
                          // 上記をトリガーにFunctionが発火してsessionIdを取得する
                          // sessionIdが取得されたら、Stripeのカスタマーポータルに遷移
                          WidgetUtils().showProgressDialog(context);

                          final docRef = await Payment().createCheckoutSessions(context, uid, priceId);

                          final snapshot = FirebaseFirestore.instance
                              .collection('customers')
                              .doc(uid)
                              .collection('checkout_sessions')
                              .doc(docRef.id)
                              .snapshots();

                          snapshot.listen((doc) {
                            if (doc.data()!['error'] != null) {
                              print(doc.data()!['error']['message']);
                            }
                            if (doc.data()!['sessionId'] != null) {

                              launchUrl(
                                  Uri.parse(doc.data()!['url'])
                              );

                              // HomeScreenにルーティング
                              context.read<HomeViewModel>().setIndex(0);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => const HomeScreen(),
                                  ),
                                      (route) => false);
                            }
                          }).onDone(() {
                          });
                        }
                      },
                      child: Text(
                        "コーヒーチケットを購入する",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.015,
                          wordSpacing: 0,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
