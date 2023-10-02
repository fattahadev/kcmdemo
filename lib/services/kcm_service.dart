import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kcmdemo/models/auth_user.dart';
import 'package:kcmdemo/models/question.dart';
import 'package:kcmdemo/models/users_answers.dart';


class KcmService{
  //TODO::Initializing FirebaseFirestore
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //TODO::This function for check exist user in firestore with store if not exist
  Future<void> checkExistUserInFirestoreWithStoreIfNotExist(AuthUser user) async{
    CollectionReference users = _firebaseFirestore.collection('users');
    QuerySnapshot querySnapshot = await users.where('email', isEqualTo: user.email).get();
    if(!(querySnapshot.size > 0)){
      await users.add(user.toJson());
    }
  }

  //TODO::This function for get list of users with scores
  Stream<List<AuthUser>> getListOfUsersWithScores() {
    CollectionReference users = _firebaseFirestore.collection('users');
    return users
        .orderBy('score', descending: true)
        .snapshots()
        .map((query) => query
        .docs
        .map((doc) => AuthUser.fromMap(doc))
        .toList()
    );
  }

  //TODO::This function for get list of questions
  Stream<List<Question>> getListOfQuestion() {
    CollectionReference questions = _firebaseFirestore.collection('questions');
    int index = 0;
    return questions
        .snapshots()
        .map((query) => query
        .docs
        .map((doc) {
          Question question = Question.fromMap(doc);
          question.position = index;
          index++;
          return question;
        })
        .toList()
    );
  }

  //TODO::This function for set answer
  Future<void> setAnswers(List<Question> questions) async {
    CollectionReference usersAnswersRef = _firebaseFirestore.collection('users_answers');
    var userId = FirebaseAuth.instance.currentUser!.uid;
    double score = 0;
    for(int i = 0; i < questions.length; i++){
      var question = questions[i];
      QuerySnapshot querySnapshot = await usersAnswersRef
          .where('uid', isEqualTo: userId)
          .where('answerId', isEqualTo: question.id)
          .get();

      if(!(querySnapshot.size > 0)){
        UsersAnswers usersAnswers = UsersAnswers(
            uid: userId,
            answerId: question.id,
            userAnswer: question.userAnswer!,
            note: question.answer == question.userAnswer ? question.note : 0.0
        );
        score+= usersAnswers.note;
        await usersAnswersRef.add(usersAnswers.toJson());
      }
    }
    await updateScoreOfCurrentUser(score);
  }

  //TODO::This function for get answer of current user
  Future<UsersAnswers?> getAnswerOfUser(Question question) async{
    CollectionReference usersAnswersRef = _firebaseFirestore.collection('users_answers');
    var userId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot querySnapshot = await usersAnswersRef
        .where('uid', isEqualTo: userId)
        .where('answerId', isEqualTo: question.id)
        .get();

    if(querySnapshot.docs.isEmpty){
      return null;
    }
    return querySnapshot.docs.map((doc) => UsersAnswers.fromMap(doc)).first;
  }

  //TODO::This function for update score of current user
  Future<void> updateScoreOfCurrentUser(double score) async{
    CollectionReference usersRef = _firebaseFirestore.collection('users');
    var userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await usersRef
        .where('uid', isEqualTo: userId)
        .get();
    AuthUser user = querySnapshot.docs.map((doc) => AuthUser.fromMap(doc)).first;
    await usersRef.doc(user.id!).update({
      'score': score
    });
  }
}