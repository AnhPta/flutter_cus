import 'package:app_customer/screens/navigation/home_screen.dart';
import 'package:app_customer/screens/navigation/shipment_list.dart';
import 'package:app_customer/screens/profile/profile.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title = 'Home'}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  NavigationBloc navigationBloc;
//  final _pageViewController = PageController();
  PageController _pageViewController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NavigationBloc, NavigationState>(
        bloc: navigationBloc,
        builder: (BuildContext context, NavigationState state) {
          if (state is HomeNavigationState) {
            return HomeScreen();
          }
          if (state is ProfileNavigationState) {
            return ProfileNavigationPage();
          }
          if (state is ShipmentNavigationState) {
            return ShipmentScreen(
              loadedShipmentState: state.loadedShipmentState
            );
          }
          if (state is StatisticalNavigationState) {
            return Scaffold(
              body: Center(
                child: Icon(FontAwesomeIcons.chartBar, size: 50, color: Colors.orangeAccent),
              ),
            );
          }
          return Container();
        },
      ),
//      bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
//        bloc: navigationBloc,
//        builder: (BuildContext context, NavigationState state) {
//          return BottomNavigationBar(
//            unselectedItemColor: Colors.black,
//            selectedItemColor: colorAccent,
//            iconSize: 16,
//            unselectedLabelStyle: TextStyle(fontSize: 10),
//            selectedLabelStyle: TextStyle(fontSize: 12),
//            showUnselectedLabels: true,
//            currentIndex: navigationBloc.currentIndex,
//            onTap: (index) => navigationBloc.dispatch(ChangeIndexPageEvent(index: index))
//            items: const <BottomNavigationBarItem>[
//            BottomNavigationBarItem(
//              icon: Icon(FontAwesomeIcons.home),
//              title: Text('Trang chủ'),
//            ),
//            BottomNavigationBarItem(
//              icon: Icon(FontAwesomeIcons.boxOpen),
//              title: Text('Vận đơn'),
//            ),
////            BottomNavigationBarItem(
////              icon: Icon(FontAwesomeIcons.userAlt),
////              title: Text('Thống kê'),
////            ),
//            BottomNavigationBarItem(
//                icon: Icon(FontAwesomeIcons.userAlt),
//                title: Text('Tài khoản'),
//              ),
//            ],
//          );
//        }
//      ),
      bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
        bloc: navigationBloc,
        builder: (context, state) {
          return BubbleBottomBar(
            iconSize: 18,
            opacity: .2,
            currentIndex: navigationBloc.currentIndex,
            onTap: (index) => navigationBloc.dispatch(ChangeIndexPageEvent(index: index)),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            elevation: 8,
//            fabLocation: BubbleBottomBarFabLocation.end,
            hasNotch: true,
            hasInk: true,
            inkColor: Colors.black12,
            items: <BubbleBottomBarItem>[
              BubbleBottomBarItem(
                backgroundColor: Colors.green,
                icon: Icon(FontAwesomeIcons.home, color: Colors.black45),
                title: Text('Trang chủ', style: TextStyle(color: Colors.black, fontSize: 15)),
                activeIcon: Icon(FontAwesomeIcons.home, color: Colors.green, size: 16),
              ),
              BubbleBottomBarItem(
                backgroundColor: colorAccent,
                activeIcon: Icon(FontAwesomeIcons.boxOpen, color: colorAccent, size: 16),
                icon: Icon(FontAwesomeIcons.boxOpen, color: Colors.black45),
                title: Text('Vận đơn', style: TextStyle(color: Colors.black, fontSize: 15)),
              ),
              BubbleBottomBarItem(
                backgroundColor: colorPrimary,
                activeIcon: Icon(FontAwesomeIcons.userAlt, color: colorPrimary, size: 16),
                icon: Icon(FontAwesomeIcons.userAlt, color: Colors.black45),
                title: Text('Tài khoản', style: TextStyle(color: Colors.black, fontSize: 15)),
              ),
              BubbleBottomBarItem(
                backgroundColor: Colors.orangeAccent,
                activeIcon: Icon(FontAwesomeIcons.chartBar, color: Colors.orangeAccent, size: 16),
                icon: Icon(FontAwesomeIcons.chartBar, color: Colors.black45),
                title: Text('Thống kê', style: TextStyle(color: Colors.black, fontSize: 15)),
              ),
            ],
          );
        }
      ),
    );
  }
}
