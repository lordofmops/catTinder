import 'package:cat_tinder/src/model/cat.dart';
import 'package:cat_tinder/src/presenter/cat_presenter.dart';
import 'package:cat_tinder/src/service/cat_service.dart';
import 'package:cat_tinder/src/service/local_storage.dart';
import 'package:cat_tinder/src/view/cat_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<CatView>(as: #MockCatView),
    MockSpec<CatService>(as: #MockCatService),
    MockSpec<LocalStorage>(as: #MockLocalStorage),
    MockSpec<Connectivity>(as: #MockConnectivity),
  ],
)

import 'cat_presenter_test.mocks.dart';

void main() {
  late MockCatView mockView;
  late MockCatService mockService;
  late MockLocalStorage mockStorage;
  late MockConnectivity mockConnectivity;
  late CatPresenter presenter;

  setUp(() {
    mockView = MockCatView();
    mockService = MockCatService();
    mockStorage = MockLocalStorage();
    mockConnectivity = MockConnectivity();

    presenter = CatPresenter(mockView)
      ..service = mockService
      ..localStorage = mockStorage
      ..connectivity = mockConnectivity;
  });

  test('loadRandomCat should update view with cat when online', () async {
    final cat = Cat(
      imageUrl: 'test_url',
      breed: 'Test Breed',
      weight: '5',
      lifeSpan: '15',
      origin: 'US',
      temperament: 'Friendly',
      description: 'Test description',
      socialAttributes: {},
      activityAndCareAttributes: {},
      physicalAttributes: {},
      rarityAttributes: {},
      vetstreetUrl: null,
      vcahospitalsUrl: null,
      wikiUrl: null,
      cfaUrl: null,
    );

    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.wifi);
    when(mockService.fetchRandomCat()).thenAnswer((_) async => cat);

    await presenter.loadRandomCat();

    verify(mockView.showNetworkStatus(true)).called(1);
    verify(mockStorage.saveCat(cat)).called(1);
    verify(mockView.updateCat(cat)).called(1);
  });

  test('loadRandomCat should use saved cats when offline', () async {
    final cat = Cat(
      imageUrl: 'test_url',
      breed: 'Test Breed',
      weight: '5',
      lifeSpan: '15',
      origin: 'US',
      temperament: 'Friendly',
      description: 'Test description',
      socialAttributes: {},
      activityAndCareAttributes: {},
      physicalAttributes: {},
      rarityAttributes: {},
      vetstreetUrl: null,
      vcahospitalsUrl: null,
      wikiUrl: null,
      cfaUrl: null,
    );

    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.none);
    when(mockStorage.getSavedCats()).thenAnswer((_) async => [cat]);

    await presenter.loadRandomCat();

    verify(mockView.showNetworkStatus(false)).called(1);
    verify(mockView.updateCat(cat)).called(1);
  });

  test('updateLikes should save likes to storage', () async {
    await presenter.updateLikes(5);
    verify(mockStorage.saveLikes(5)).called(1);
  });
}