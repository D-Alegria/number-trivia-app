
import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/error.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams>{
  final NumberTriviaRepository numberTriviaRepository;

  GetRandomNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Either<Failure,NumberTrivia>> call(NoParams noParam) async {
    return await numberTriviaRepository.getRandomNumberTrivia();
  }
}