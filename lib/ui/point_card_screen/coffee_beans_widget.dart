import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CoffeeBeansWidget extends StatefulWidget {
  final int point;
  const CoffeeBeansWidget({Key? key, required this.point}) : super(key: key);

  @override
  _CoffeeBeansWidgetState createState() => _CoffeeBeansWidgetState();
}

class _CoffeeBeansWidgetState extends State<CoffeeBeansWidget> {
  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final List<dynamic> zeroPointIconData = [
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
    ];

    final List<dynamic> onePointIconData = [
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
    ];

    final List<dynamic> twoPointIconData = [
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
    ];

    final List<dynamic> threePointIconData = [
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
    ];

    final List<dynamic> fourPointIconData = [
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
    ];

    final List<dynamic> fivePointIconData = [
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
    ];

    final List<dynamic> sixPointIconData = [
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
    ];

    final List<dynamic> sevenPointIconData = [
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
    ];

    final List<dynamic> eightPointIconData = [
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
      SvgPicture.asset('images/RC_icon-02.svg'),
    ];

    final List<dynamic> ninePointIconData = [
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg'),
      SvgPicture.asset('images/RC_icon-03.svg')
    ];

    final List<List<dynamic>> myPointList = [
      zeroPointIconData,
      onePointIconData,
      twoPointIconData,
      threePointIconData,
      fourPointIconData,
      fivePointIconData,
      sixPointIconData,
      sevenPointIconData,
      eightPointIconData,
      ninePointIconData,
    ];

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.028),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              Container(
                child: myPointList[widget.point][0],
              ),
              SizedBox(
                height: height * 0.06,
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: height * 0.06,
              ),
              Container(
                child: myPointList[widget.point][1],
              )
            ],
          ),
          Column(
            children: [
              Container(
                child: myPointList[widget.point][2],
              ),
              SizedBox(
                height: height * 0.06,
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: height * 0.06,
              ),
              Container(
                child: myPointList[widget.point][3],
              )
            ],
          ),
          Column(
            children: [
              Container(
                child: myPointList[widget.point][4],
              ),
              SizedBox(
                height: height * 0.06,
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: height * 0.06,
              ),
              Container(
                child: myPointList[widget.point][5],
              ),
            ],
          ),
          Column(
            children: [
              Container(
                child: myPointList[widget.point][6],
              ),
              SizedBox(
                height: height * 0.06,
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: height * 0.06,
              ),
              Container(
                child: myPointList[widget.point][7],
              )
            ],
          ),
          Column(
            children: [
              Container(
                child: myPointList[widget.point][8],
              ),
              SizedBox(
                height: height * 0.06,
              )
            ],
          ),
          Column(
            children: [
              const SizedBox(
                height: 50,
                width: 50
              ),
              SvgPicture.asset('images/CoffeeCup.svg')
            ],
          )
        ],
      ),
    );
  }
}
