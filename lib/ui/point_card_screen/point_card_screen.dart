import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../view_model/point_card_view_model.dart';
import '../payment_screen/payment_screen.dart';
import 'coffee_beans_widget.dart';

class PointCardScreen extends StatelessWidget {
  const PointCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 顧客情報を取得してエンティティにセット
    Provider.of<PointCardViewModel>(context).init();

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
            width: double.infinity,
            height: height * 0.3,
            padding: EdgeInsets.fromLTRB(width * 0.08, height * 0.035, width * 0.08, height * 0.025),
            margin: EdgeInsets.fromLTRB(width * 0.04, height * 0.025, width * 0.04, height * 0.025),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black,
                  width: width * 0.005
              ),
              boxShadow: [
                BoxShadow(
                  color: context.read<PointCardViewModel>().checkIsPremiumColor(),
                  spreadRadius: 0.8,
                  offset: const Offset(6, 8),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  context.read<PointCardViewModel>().checkIsPremiumColor(),
                  Colors.white
                ],
                begin: Alignment.topLeft,
                end: const Alignment(0.3, 0.8),
                stops: const [0.08, 0.0],
              ),
            ),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(bottom: height * 0.025),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: width * 0.01),
                          child: context.read<PointCardViewModel>().checkIsPremiumCard(),
                        ),
                        Text(
                          context.read<PointCardViewModel>().checkIsPremiumString(),
                          style: TextStyle(
                              fontSize: height * 0.03,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: height * 0.01),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  context.read<PointCardViewModel>().customer.points.toString(),
                                  style: TextStyle(
                                      fontSize: height * 0.08,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  ' point',
                                  style: TextStyle(
                                    fontSize: height * 0.02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('images/coffee-togo.svg'),
                              Text (
                                ' × ',
                                style: TextStyle(
                                    fontSize: height * 0.02,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                context.read<PointCardViewModel>().customer.coffeeTickets.toString(),
                                style: TextStyle(
                                    fontSize: height * 0.035,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                ' ticket',
                                style: TextStyle(
                                    fontSize: height * 0.02,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ]
                    ),
                    QrImage(
                      data: context
                          .read<PointCardViewModel>()
                          .customer
                          .uid,
                      size: height * width * 0.0004,
                    )
                  ],
                ),
              ],
            )
        ),
        CoffeeBeansWidget(point: int.parse(context.read<PointCardViewModel>().customer.points)),
        Container(
          padding: EdgeInsets.only(bottom: height * 0.03),
          child: Text(
            'あと${10 - int.parse(context.read<PointCardViewModel>().customer.points)}pointでコーヒー1杯無料チケットを獲得',
            style: TextStyle(
                fontSize: height * 0.016,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Divider(
            color: Colors.black,
            thickness: height * 0.002
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => const PaymentScreen()
            ));
          },
        child: Container(
          // height: width / height * 100,
          margin: EdgeInsets.only(left: width * 0.05, top: height * 0.005),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'プレミアムメンバーになって毎日使える \n'
                    'コーヒーチケットや得点をゲットしよう',
                style: TextStyle(
                    fontSize: height * width * 0.00004,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.yellowAccent,
                    decorationThickness: height * 0.003
                ),
              ),
              Icon(
                Icons.navigate_next,
                size: height * width * 0.0001,
              )
            ],
          ),
        )
        )
      ],
    );
  }
}
