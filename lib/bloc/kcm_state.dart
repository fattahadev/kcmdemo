part of 'kcm_cubit.dart';

@immutable
abstract class KcmState extends Equatable {
  @override
  List<Object> get props => [];
}

class KcmInitial extends KcmState {
}

class KcmLoaded extends KcmState {
  final List<Question> data;
  KcmLoaded({required this.data});
}

class KcmError extends KcmState {
  final String message;
  KcmError({required this.message});
}