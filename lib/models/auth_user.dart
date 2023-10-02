import 'package:cloud_firestore/cloud_firestore.dart';

class AuthUser{
  final String? id;
  final String uid;
  final String email;
  final double? score;

  AuthUser({this.id, required this.uid, required this.email, this.score});

  factory AuthUser.fromMap(DocumentSnapshot snapshot){
    return AuthUser(
      id: snapshot.id,
      uid: snapshot.get('uid'),
      email: snapshot.get('email'),
      score: snapshot.get('score') is double ?
        snapshot.get('score') : double.parse(snapshot.get('score').toString()),
    );
  }

  Map<String, dynamic> toJson() =>{
      'uid': uid,
      'email': email,
      'score': score,
  };

}