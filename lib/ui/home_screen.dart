import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kcmdemo/models/auth_user.dart';
import 'package:kcmdemo/services/auth_service.dart';
import 'package:kcmdemo/services/kcm_service.dart';
import 'package:badges/badges.dart' as badges;
import 'package:kcmdemo/ui/kcm_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    KcmService kcmService = KcmService();
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        leading: const Icon(Icons.person),
        title: Text(
          FirebaseAuth.instance.currentUser!.email!,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: badges.Badge(
              position: badges.BadgePosition.topEnd(top: 1, end: 1),
              badgeContent: const Text(
                '1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              child: IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KcmScreen()),
                ),
                icon: const Icon(Icons.library_books),
              ),
            ),
          ),
          IconButton(
            onPressed: () => authService.handleSignOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
        titleSpacing: 0,
      ),
      body: StreamBuilder<List<AuthUser>>(
        stream: kcmService.getListOfUsersWithScores(),
        builder: (context, AsyncSnapshot<List<AuthUser>> users){
          if(users.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 1),
            );
          }
          if(users.hasData && users.data != null  && users.data!.isNotEmpty){
            return SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 0,
                          child: Icon(Icons.workspace_premium, size: 35),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            const Text(
                              'Top user',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              '${users.data!.length} users',
                              style: const  TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xFFCCCCCC)),
                            ),
                          ],
                        ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  //TODO::Load list of users
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: users.data!.map((user) => _cardTopAccount(context, user)).toList(),
                  )
                ],
              ),
            );
          }else{
            return const Center(
              child: Text('Not found any users'),
            );
          }
        },
      ),
    );
  }

  Widget _cardTopAccount(BuildContext context, AuthUser user){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 1,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Text(
                    '@',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 0,
              child: Text(
                '#${user.score}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
