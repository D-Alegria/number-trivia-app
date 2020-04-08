import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/error.dart';
import 'package:number_trivia/core/usecase/usecase.dart';
import 'package:number_trivia/core/util/input_conversion.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_state.dart';

///Created by Demilade Oladugba on 4/8/2020

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia getConcreteNumberTrivia;
  MockGetRandomNumberTrivia getRandomNumberTrivia;
  MockInputConverter inputConverter;

  setUp(() {
    getConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    getRandomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: getConcreteNumberTrivia,
        getRandomNumberTrivia: getRandomNumberTrivia,
        inputConverter: inputConverter);
  });

  test('initialState should be empty', () {
    //assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(inputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
        'should call the InputConverter to invalidate and convert the string to an unsigned integer',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      //act
      bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(inputConverter.stringToUnsignedInteger(any));
      //assert
      verify(inputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [ERROR] when the input is invalid', () async {
      //arrange
      when(inputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      //assert later
      expectLater(
          bloc.state,
          emitsInOrder([
            Empty(),
            Error(message: INVALID_INPUT_FAILURE_MESSAGE),
          ]));
      //act
      bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('should get data from the concrete use case', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(getConcreteNumberTrivia(any));
      //assert
      verify(getConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // assert Later
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('should emit [Loading, Error] when data is gotten fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert Later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting daata fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert Later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the random use case', () async {
      //arrange
      when(getRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc.dispatch(GetTriviaForRandomNumber());
      await untilCalled(getRandomNumberTrivia(any));
      //assert
      verify(getRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      when(getRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // assert Later
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when data is gotten fails', () async {
      // arrange
      when(getRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert Later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting daata fails',
        () async {
      // arrange
      when(getRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert Later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForRandomNumber());
    });
  });
}
