import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kcmdemo/bloc/kcm_cubit.dart';
import 'package:kcmdemo/bloc/kcm_repository_impl.dart';
import 'package:kcmdemo/services/auth_service.dart';
import 'package:kcmdemo/services/kcm_service.dart';

class KcmScreen extends StatefulWidget {
  const KcmScreen({super.key});

  @override
  State<KcmScreen> createState() => _KcmScreenState();
}

class _KcmScreenState extends State<KcmScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    KcmService kcmService = KcmService();
    return RepositoryProvider(
      create: (context) => KcmCubit(KcmRepositoryImpl()),
      child: BlocBuilder<KcmCubit, KcmState>(
        builder: (context, state) {
          if (state is KcmInitial) {
            context.read<KcmCubit>().getData();
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(strokeWidth: 1,),
              ),
            );
          }
          else if (state is KcmLoaded && state.data.isNotEmpty) {
            var questions = state.data;
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  'The questions (KCM)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () => authService.handleSignOut(),
                    icon: const Icon(Icons.logout),
                  )
                ],
                titleSpacing: 0,
              ),
              body: SingleChildScrollView(
                child: Stepper(
                  currentStep: index,
                  // onStepTapped: (int indexSet) {
                  //   setState(() {
                  //     index = indexSet;
                  //   });
                  // },
                  controlsBuilder: (BuildContext context,
                      ControlsDetails details) {
                    return Container();
                  },
                  steps: questions.map((question) =>
                      Step(
                        title: Text(question.question),
                        content: Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: question.answers.map((answer) {
                              return RadioListTile<String>(
                                title: Text(answer),
                                value: answer,
                                groupValue: question.userAnswer,
                                onChanged: (String? value) {
                                  context.read<KcmCubit>().updateData(state.data, question.id, answer);
                                  setState(() {
                                    if (!(index == questions.length - 1)) {
                                      index++;
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        isActive: index == question.position,
                        state: question.state,
                      )).toList(),
                  type: StepperType.vertical,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                mini: false,
                onPressed: () async{
                  await kcmService.setAnswers(state.data);
                  Navigator.pop(context);
                },
                child: const Icon(Icons.save, size: 35,),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(strokeWidth: 1,),
              ),
            );
          }
        },
      ),
    );
  }
}


