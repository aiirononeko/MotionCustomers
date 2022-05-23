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

  final url = "https://riverbedcoffee-brewer-roastery.com/policies/terms-of-service";
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
                      "${_product?.price}で11枚分のコーヒーチケットを購入しよう。",
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
                            "¥500×11杯=¥5500",
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
                      "¥600お得！",
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
          ],
        ),
      )
    );
  }
}
