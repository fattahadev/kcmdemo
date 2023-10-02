import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Question{
  int position;
  final String id;
  final String question;
  List<String> answers;
  final String answer;
  final double note;
  String? userAnswer;
  StepState state;

  Question({
    this.position = 0,
    required this.id,
    required this.question,
    required this.answers,
    required this.answer,
    required this.note,
    this.state = StepState.indexed,
  });
  
  factory Question.fromMap(DocumentSnapshot snapshot){
    return Question(
      id: snapshot.id,
      question: snapshot.get('question'),
      answer: snapshot.get('answer'),
      answers: snapshot.get('answers').toString().split(','),
      note: snapshot.get('note') is double ?
        snapshot.get('note') : double.parse(snapshot.get('note').toString()),
    );
  }
  
}