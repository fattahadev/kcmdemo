import 'package:cloud_firestore/cloud_firestore.dart';

class UsersAnswers{
  final String uid;
  final String answerId;
  final String userAnswer;
  final double note;

  UsersAnswers({
    required this.uid,
    required this.answerId,
    required this.userAnswer,
    required this.note
  });


  factory UsersAnswers.fromMap(DocumentSnapshot snapshot){
    return UsersAnswers(
      uid: snapshot.get('uid'),
      answerId: snapshot.get('answerId'),
      userAnswer: snapshot.get('userAnswer'),
      note: snapshot.get('note') is double ?
        snapshot.get('note') : double.parse(snapshot.get('note').toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'answerId': answerId,
    'userAnswer': userAnswer,
  };

}