import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositoriesImpl/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockNumberTriviaRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {
  
}

class MockNumberTriviaLocalDataSource extends Mock implements NumberTriviaLocalDataSource {
  
}

class MockNetworkInfo extends Mock implements NetworkInfo {
  
}

void main(){
  
  MockNumberTriviaLocalDataSource localDataSource;
  MockNumberTriviaRemoteDataSource remoteDataSource;
  MockNetworkInfo networkInfo;
  NumberTriviaRepositoryImpl repositoryImpl;

  setUp((){
    localDataSource = MockNumberTriviaLocalDataSource();
    remoteDataSource = MockNumberTriviaRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo
    );
  });

  group('getConcreteNumberTrivia', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these three variables throughout all the tests
    final tNumber = 1;
    final tNumberTriviaModel =
    NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () {
      //arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repositoryImpl.getConcreteNumberTrivia(tNumber);
      // assert
      verify(networkInfo.isConnected);
    });
  });
}