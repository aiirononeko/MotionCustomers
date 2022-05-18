import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motion_customers/service/hex_color.dart';
import 'package:provider/provider.dart';

import '../../view_model/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: context.read<HomeViewModel>().currentPage,
      bottomNavigationBar: SizedBox(
        height: height * 0.135,
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.only(top: height * 0.01),
                child: context.read<HomeViewModel>().getBottomNavigationBarItems()[0],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.only(top: height * 0.01),
                child: context.read<HomeViewModel>().getBottomNavigationBarItems()[1],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.only(top: height * 0.01),
                child: context.read<HomeViewModel>().getBottomNavigationBarItems()[2],
              ),
              label: '',
            ),
          ],
          currentIndex: context.read<HomeViewModel>().selectIndex,
          onTap: Provider.of<HomeViewModel>(context).setIndex,
          backgroundColor: HexColor("DADADA"),
          iconSize: height * 0.04,
        ),
      )
    );
  }
}
