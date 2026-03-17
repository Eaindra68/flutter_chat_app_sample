import 'package:flutter/material.dart';
import 'package:flutter_chat_app_sample/pages/chat_page.dart';
import 'package:flutter_chat_app_sample/services/chat/chat_service.dart';

import '../component/user_tile.dart';
import '../services/auth/auth_service.dart';
import '../component/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void logout() async {
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: logout, icon: Icon(Icons.logout_sharp)),
        ],
      ),
      drawer: MyDrawer(),
      body: _builduserList(),
    );
  }

  Widget _builduserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading....");
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _builduserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _builduserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    final currentUserEmail = _authService.getCurrentUser()?.email;
    if (userData["email"] != currentUserEmail) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverEmail: userData["email"],
                recieverId: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return SizedBox();
    }
  }
}
