import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../service/payment.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  const SubscriptionPaymentScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionPaymentScreen createState() => _SubscriptionPaymentScreen();
}

class _SubscriptionPaymentScreen extends State<SubscriptionPaymentScreen> {

  ProductDetails? _product;

  final url = "https://riverbed-coffee-customer-dev.firebaseapp.com/";
  bool _flag = false;

  @override
  void initState() {
    super.initState();
    getStoreInfo();
  }

  Future<void> getStoreInfo() async {
    Payment payment = Payment();
    ProductDetails? product = await payment.getSubscriptionItemInfo();
    setState(() {
      _product = product;
    });
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.15),
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(0, height * 0.1, 0, height * 0.03),
            child: SvgPicture.asset("images/MotionLogoMain.svg")
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(width * 0.08, 0, width * 0.08, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, height * 0.01, 0, 0),
              child: Text(
                "Premium Member",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.035,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, height * 0.025, 0, 0),
              child: Text(
                "月額\$${_product?.rawPrice}でリバーベットコーヒーのコーヒーが飲み放題のサブスクリプション型コーヒーサービス。",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.015,
                  wordSpacing: 0,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, height * 0.05, 0, 0),
              child: Text(
                "週3日1杯のコーヒーを飲む場合...",
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
                      "12日×500円=6,000円",
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
                "毎月約3,000円以上もお得！",
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
                  margin: EdgeInsets.fromLTRB(0, height * 0.11, 0, 0),
                  padding: EdgeInsets.fromLTRB(0, height * 0.013, 0, height * 0.013),
                  color: Colors.black12,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(width * 0.03, 0, 0, 0),
                        child: Text(
                          "利用規約&プライバシーポリシー",
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
              padding: EdgeInsets.fromLTRB(0, height * 0.01, 0, 0),
              child: Row(
                children: [
                  Checkbox(
                    value: _flag,
                    onChanged: _handleCheckbox,
                    activeColor: Colors.yellowAccent,
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
                onPressed: !_flag? null: () {
                  // TODO サブスクリプション購入処理
                },
                child: Text(
                  "サブスクリプションに登録する",
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
    );
  }
}
