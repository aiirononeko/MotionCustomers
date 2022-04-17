import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../view_model/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      body: context.read<HomeViewModel>().currentPage,
      bottomNavigationBar: SizedBox(
        height: height * 0.15,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.coffee),
              label: '',
            ),
          ],
          currentIndex: context.read<HomeViewModel>().selectIndex,
          onTap: Provider.of<HomeViewModel>(context).setIndex,
          backgroundColor: Colors.black,
          fixedColor: Colors.yellowAccent,
          unselectedItemColor: Colors.white,
          iconSize: height * 0.04,
        ),
      )
    );
  }
}
