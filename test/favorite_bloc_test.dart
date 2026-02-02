import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_app/domain/entities/character.dart';
import 'package:rick_and_morty_app/domain/repositories/character_repository.dart';
import 'package:rick_and_morty_app/presentation/bloc/favorite_bloc.dart';

class MockCharacterRepository extends Mock implements CharacterRepository {}

class FakeCharacter extends Fake implements Character {}

void main() {
  late FavoriteBloc favoriteBloc;
  late MockCharacterRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeCharacter());
  });

  setUp(() {
    mockRepository = MockCharacterRepository();
    favoriteBloc = FavoriteBloc(repository: mockRepository);
  });

  const tCharacter = Character(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    imageUrl: '',
    locationName: 'Earth',
    gender: 'Male',
    type: '',
    originName: 'Earth',
    episodes: [],
  );

  test('initial state should be FavoriteLoading', () {
    expect(favoriteBloc.state, FavoriteLoading());
  });

  blocTest<FavoriteBloc, FavoriteState>(
    'emits [FavoriteLoaded] when LoadFavorites is added.',
    build: () {
      when(() => mockRepository.getFavorites()).thenReturn([tCharacter]);
      return favoriteBloc;
    },
    act: (bloc) => bloc.add(LoadFavorites()),
    expect: () => [const FavoriteLoaded([tCharacter])],
  );

  blocTest<FavoriteBloc, FavoriteState>(
    'adds favorite and emits [FavoriteLoaded] when ToggleFavorite is added and character is NOT favorite.',
    build: () {
      var count = 0;
      when(() => mockRepository.getFavorites()).thenAnswer((_) {
        if (count == 0) {
          count++;
          return [];
        }
        return [tCharacter];
      });
      when(() => mockRepository.addFavorite(any())).thenAnswer((_) async {});
      return favoriteBloc;
    },
    seed: () => const FavoriteLoaded([]),
    act: (bloc) => bloc.add(const ToggleFavorite(tCharacter)),
    expect: () => [const FavoriteLoaded([tCharacter])],
    verify: (_) {
      verify(() => mockRepository.addFavorite(tCharacter)).called(1);
    },
  );
}
