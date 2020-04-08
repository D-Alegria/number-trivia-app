import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/error.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositoriesImpl/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockNumberTriviaLocalDataSource localDataSource;
  MockNumberTriviaRemoteDataSource remoteDataSource;
  MockNetworkInfo networkInfo;
  NumberTriviaRepositoryImpl repositoryImpl;

  setUp(() {
    localDataSource = MockNumberTriviaLocalDataSource();
    remoteDataSource = MockNumberTriviaRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
        localDataSource: localDataSource,
        remoteDataSource: remoteDataSource,
        networkInfo: networkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these three variables throughout all the tests
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      () {
        //arrange
        when(networkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verify(networkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(localDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the caached data is present',
          () async {
        //arrange
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return cache failure when the caached data is not present',
          () async {
        //arrange
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these three variables throughout all the tests
    final tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      () {
        //arrange
        when(networkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repositoryImpl.getRandomNumberTrivia();
        // assert
        verify(networkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repositoryImpl.getRandomNumberTrivia();
        //assert
        verify(remoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        await repositoryImpl.getRandomNumberTrivia();
        //assert
        verify(remoteDataSource.getRandomNumberTrivia());
        verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(remoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        //act
        final result = await repositoryImpl.getRandomNumberTrivia();
        //assert
        verify(remoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(localDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the caached data is present',
          () async {
        //arrange
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repositoryImpl.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return cache failure when the caached data is not present',
          () async {
        //arrange
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        //act
        final result = await repositoryImpl.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
