import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'feature/blog/presentation/pages/blog_page.dart';
import 'feature/job/presentation/page/job_page.dart';
import 'feature/profile/page/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: TickerMode(
        enabled: _selectedIndex == index,
        child: Navigator(
          key: _navigatorKeys[index],
          onGenerateRoute: (settings) {
            late Widget page;
            switch (index) {
              case 0:
                page = BlogPage();
                break;
              case 1:
                page = JobsPage();
                break;
              case 2:
                page = ProfilePage();
                break;
              default:
                page = BlogPage();
            }
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => page,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 300),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppPallete.surfaceColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (_selectedIndex == index) {
                _navigatorKeys[index].currentState?.popUntil((r) => r.isFirst);
              } else {
                setState(() => _selectedIndex = index);
              }
            },
            backgroundColor: AppPallete.surfaceColor,
            selectedItemColor: AppPallete.primaryColor,
            unselectedItemColor: AppPallete.textSecondary,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 11,
            ),
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(_selectedIndex == 0 ? 8 : 6),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0
                        ? AppPallete.primaryColor.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.home_rounded,
                    size: _selectedIndex == 0 ? 26 : 24,
                  ),
                ),
                label: "Home"),
              BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(_selectedIndex == 1 ? 8 : 6),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1
                        ? AppPallete.primaryColor.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.work_rounded,
                    size: _selectedIndex == 1 ? 26 : 24,
                  ),
                ),
                label: "Jobs"),
              BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(_selectedIndex == 2 ? 8 : 6),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 2
                        ? AppPallete.primaryColor.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: _selectedIndex == 2 ? 26 : 24,
                  ),
                ),
                label: "Profile"),
            ],
          ),
        ),
      ),
    );
  }
}
