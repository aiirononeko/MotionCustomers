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
                        fontSize: height * width * 0.00008,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Icon(
                    Icons.navigate_next,
                    size: height * width * 0.0001,
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: height * 0.02),
            child: const Text(
              'プレミアムメンバーになって毎日使えるコーヒーチケットや特典をゲットしよう',
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: height * 0.02),
            child: Divider(
                color: Colors.black,
                thickness: height * 0.002
            ),
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
                        fontSize: height * width * 0.00008,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Icon(
                    Icons.navigate_next,
                    size: height * width * 0.0001,
                  )
                ],
              ),
            ),
          ),
          const Text(
            'コーヒーチケットを購入してキャッシュレスで注文をしよう',
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}
