
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/error.dart';


abstract class UseCase<Type, Params> {
  Future<Either<Failure,Type>> call(Params params);
}

class NoParam extends Equatable{

}