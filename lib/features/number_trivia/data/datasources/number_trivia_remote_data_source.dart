import 'dart:convert';

import 'package:http/http.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:meta/meta.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Client httpClient;

  NumberTriviaRemoteDataSourceImpl({@required this.httpClient});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return _getTriviaFromUrl('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return _getTriviaFromUrl('http://numbersapi.com/random');
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await httpClient.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Future.value(
          NumberTriviaModel.fromJson(jsonDecode(response.body)));
    } else {
      throw ServerException();
    }
  }
}
