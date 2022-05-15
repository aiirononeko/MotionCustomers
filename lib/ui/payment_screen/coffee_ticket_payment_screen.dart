import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/payment.dart';

class CoffeeTicketPaymentScreen extends StatefulWidget {
  const CoffeeTicketPaymentScreen({Key? key}) : super(key: key);

  @override
  _CoffeeTicketPaymentScreen createState() => _CoffeeTicketPaymentScreen();
}

class _CoffeeTicketPaymentScreen extends State<CoffeeTicketPaymentScreen> {

  final Payment _payment = Payment();

  ProductDetails? _product;

  final url = "https://motion-dev-d0877.web.app/";
  bool _flag = false;

  @override
  void initState() {
    super.initState();
    getStoreInfo();
  }

  Future<void> getStoreInfo() async {
    ProductDetails? product = await _payment.getCoffeeTicketItemInfo();
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
                  fontSize: height * 0.035,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, height * 0.025, 0, 0),
              child: Text(
                "\$${_product?.rawPrice}で11杯分のスペシャルティコーヒーが飲めるコーヒーチケット。",
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
                      "500円×11杯=5500円",
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
                "500円お得！",
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
                  _payment.buyCoffeeTicket(_product!); /// コーヒーチケット購入処理
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
    );
  }
}
