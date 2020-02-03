import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/error.dart';

import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure,NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure,NumberTrivia>> getRandomNumberTrivia();
}