import 'package:flutter/material.dart';
import 'package:flutter_chat_app_sample/pages/setting_page.dart';

import '../services/auth/auth_service.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() async {
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(Icons.message, color: Colors.black, size: 40),
                ),
              ),
              ListTile(
                title: Text("H O M E"),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("S E T T I N G"),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SettingPage();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          ListTile(
            title: Text("LOGOUT"),
            leading: Icon(Icons.logout),
            onTap: logout,
          ),
        ],
      ),
    );
  }
}
