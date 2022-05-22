import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../view_model/point_card_view_model.dart';
import '../payment_screen/subscription_payment_screen.dart';
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
            width: width * 0.88,
            height: height * 0.28,
            margin: EdgeInsets.only(top: height * 0.085),
            decoration: BoxDecoration(
                color: context.read<PointCardViewModel>().checkIsPremiumCardColor()
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.6,
                  height: height * 0.1,
                  child: context.read<PointCardViewModel>().checkIsPremiumLogo(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    context.read<PointCardViewModel>().checkIsPremiumCard(),
                    Container(
                      margin: EdgeInsets.only(left: width * 0.01),
                      child: Text(
                        context.read<PointCardViewModel>().checkIsPremiumString(),
                        style: TextStyle(
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.bold,
                            color: context.read<PointCardViewModel>().checkIsPremiumColor(),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
        ),
        Container(
            height: height * 0.15,
            width: width * 0.8,
            margin: EdgeInsets.only(top: height * 0.035, bottom: height * 0.015),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  ' P',
                                  style: TextStyle(
                                    fontSize: height * 0.04,
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
                    SizedBox(
                      width: width * 0.1,
                    ),
                    QrImage(
                      data: context
                          .read<PointCardViewModel>()
                          .customer
                          .uid,
                      size: height * 0.15,
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
            '${10 - int.parse(context.read<PointCardViewModel>().customer.points)} more points get you a free ticket.',
            style: TextStyle(
                fontSize: height * 0.018,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        InkWell(
            onTap: () {
              if (!context.read<PointCardViewModel>().customer.isPremium) {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const SubscriptionPaymentScreen()
                ));
              }
            },
            child: context.read<PointCardViewModel>().checkIsPremiumLink(width, height)
        )
      ],
    );
  }
}
