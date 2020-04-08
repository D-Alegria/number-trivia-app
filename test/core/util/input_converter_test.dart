import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/error.dart';
import 'package:number_trivia/core/util/input_conversion.dart';

///Created by Demilade Oladugba on 4/8/2020

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () {
      //arrange
      final str = '123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, Right(123));
    });

    test('should return a Failure when the string isn\'t an integer', () {
      //arrange
      final str = 'abc';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a Failure when the string is a negative integer', () {
      //arrange
      final str = '-123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
