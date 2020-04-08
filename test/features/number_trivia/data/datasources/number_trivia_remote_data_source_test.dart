import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

///Created by Demilade Oladugba on 4/8/2020

class MockHttpClient extends Mock implements Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl remoteDataSourceImpl;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSourceImpl =
        NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFail404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('Not found', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number 
        being the endpoint and with application/json header''', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response is 200 (success)',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result =
          await remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
      //asset
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when response isn\'t 200 (success)',
        () async {
      //arrange
      setUpMockHttpClientFail404();
      //act
      final call = remoteDataSourceImpl.getConcreteNumberTrivia;
      //asset
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number 
        being the endpoint and with application/json header''', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      remoteDataSourceImpl.getRandomNumberTrivia();
      //assert
      verify(mockHttpClient.get('http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response is 200 (success)',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await remoteDataSourceImpl.getRandomNumberTrivia();
      //asset
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when response isn\'t 200 (success)',
        () async {
      //arrange
      setUpMockHttpClientFail404();
      //act
      final call = remoteDataSourceImpl.getRandomNumberTrivia;
      //asset
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
