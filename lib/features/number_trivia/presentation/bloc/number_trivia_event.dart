import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([List props = const <dynamic>[]]) : super(props);
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumber({@required this.numberString})
      : super([numberString]);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
