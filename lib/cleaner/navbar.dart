import 'package:clean/cleaner/home.dart';
import 'package:clean/cleaner/profile.dart';
import 'package:clean/cleaner/transactions.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CleanerNavBar extends StatefulWidget {
  const CleanerNavBar({Key? key}) : super(key: key);

  @override
  _CleanerNavBarState createState() => _CleanerNavBarState();
}

class _CleanerNavBarState extends State<CleanerNavBar> {
  int _currentIndex = 0;

  final List<Widget> _adminPages = const [
    Dashboard(),
    Text("lol"),
    Transactions(),
    Profile()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 62, 180, 137).withOpacity(0.1),
      body: IndexedStack(
        index: _currentIndex,
        children: _adminPages,
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 62, 180, 137).withOpacity(0.1),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: SafeArea(
              child: GNav(
                backgroundColor: Colors.transparent,
                hoverColor: Colors.grey[100]!,
                haptic: true,
                tabBorderRadius: 15,
                curve: Curves.easeOutExpo,
                duration: const Duration(milliseconds: 300),
                gap: 4, // Reduced gap
                color: Colors.grey[600],
                activeColor: Colors.black,
                iconSize: 24,
                tabBackgroundColor: Colors.grey[200]!,
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth < 350 ? 10 : 20,
                    vertical: 12),
                onTabChange: onTabTapped,
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: "Dashboard",
                  ),
                  GButton(
                    icon: Icons.schedule,
                    text: "Schedule",
                  ),
                  GButton(
                    icon: Icons.attach_money,
                    text: "Transactions",
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
