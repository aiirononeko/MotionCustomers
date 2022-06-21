import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motion_customers/ui/payment_screen/subscription_payment_screen.dart';

import 'coffee_ticket_payment_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery
        .of(context)
        .size
        .width;
    final double height = MediaQuery
        .of(context)
        .size
        .height;

    return Container(
      margin: EdgeInsets.fromLTRB(width * 0.1, height * 0.02, width * 0.1, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width * 0.6,
            child: SvgPicture.asset("images/MotionLogoMain.svg")
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const CoffeeTicketPaymentScreen()
              ));
            },
            child: Container(
              margin: EdgeInsets.only(bottom: height * 0.015),
              child: Row(
                children: [
                  Text(
                    'Coffee Ticket',
                    style: TextStyle(
                        fontSize: width * 0.065,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Icon(
                    Icons.navigate_next,
                    size: width * 0.065,
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: height * 0.025),
            child: Text(
              'コーヒーチケットを購入してお得にキャッシュレスで注文しよう',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.03,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: height * 0.025),
            child: Divider(
                color: Colors.black,
                thickness: height * 0.002
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const SubscriptionPaymentScreen()
              ));
            },
            child: Container(
              margin: EdgeInsets.only(bottom: height * 0.015),
              child: Row(
                children: [
                  Text(
                    'Premium Member',
                    style: TextStyle(
                        fontSize: width * 0.065,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Icon(
                    Icons.navigate_next,
                    size: width * 0.065,
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: height * 0.025),
            child: Text(
              'サブスクリプションに登録してさらにお得にキャッシュレスで注文しよう',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.03,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
