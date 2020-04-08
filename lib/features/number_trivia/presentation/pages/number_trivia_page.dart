import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/widgets.dart';

import '../../../../injection_container.dart';

///Created by Demilade Oladugba on 4/8/2020

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: BlocProvider(
        builder: (_) => sl<NumberTriviaBloc>(),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  //Top Half
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                      if (state is Empty) {
                        return MessageDisplay(
                          message: 'Start searching',
                        );
                      } else if (state is Loading) {
                        return LoadingWidget();
                      } else if (state is Loaded) {
                        return TriviaDisplay(
                          numberTrivia: state.trivia,
                        );
                      } else if (state is Error) {
                        return MessageDisplay(
                          message: state.message,
                        );
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  //Bottom Half
                  TriviaControls()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
