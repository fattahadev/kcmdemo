import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kcmdemo/ui/auth_screen.dart';
import 'package:kcmdemo/ui/home_screen.dart';


class DetectAuth extends StatelessWidget {
  const DetectAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 1),
            );
          }
          if(snapshot.hasData){
            return const HomeScreen();
          }else{
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
