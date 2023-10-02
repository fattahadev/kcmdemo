import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kcmdemo/bloc/kcm_repository_impl.dart';
import 'package:kcmdemo/models/question.dart';
import 'package:equatable/equatable.dart';

part 'kcm_state.dart';

class KcmCubit extends Cubit<KcmState> {
  final KcmRepository _kcmRepository;

  KcmCubit(this._kcmRepository) : super(KcmInitial());

  Future<void> getData() async {
    try {
      List<Question> data = await _kcmRepository.fetchData().first;
      emit(KcmLoaded(data: data));
    } on Exception {
      emit(KcmError(message: "Could not fetch the list, please try again later!"));
    }
  }

  Future<void> updateData(List<Question> data, String id, String answer) async{
    try {
      for(int i = 0; i < data.length; i++){
        if(data[i].id == id){
          data[i].userAnswer = answer;
          data[i].state = answer == data[i].answer ? StepState.complete : StepState.error;
        }
      }

      emit(KcmLoaded(data: data));
    } on Exception {
      emit(KcmError(message: "Could not fetch the list, please try again later!"));
    }
  }


}