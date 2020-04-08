import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_event.dart';

///Created by Demilade Oladugba on 4/8/2020

class TriviaControls extends StatefulWidget {
  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
        ),
        SizedBox(height: 10),
        Row(children: <Widget>[
          Expanded(
            child: RaisedButton(
              onPressed: () {
                dispatchConcrete();
              },
              child: Text('Search'),
              color: Theme.of(context).accentColor,
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: RaisedButton(
              onPressed: () {
                dispatchRandom();
              },
              child: Text('Get random trivia'),
              color: Theme.of(context).accentColor,
              textTheme: ButtonTextTheme.primary,
            ),
          ),
        ])
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .dispatch(GetTriviaForConcreteNumber(numberString: inputStr));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .dispatch(GetTriviaForRandomNumber());
  }
}