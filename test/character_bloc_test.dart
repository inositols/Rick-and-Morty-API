import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_app/domain/entities/character.dart';
import 'package:rick_and_morty_app/domain/repositories/character_repository.dart';
import 'package:rick_and_morty_app/presentation/bloc/character_bloc.dart';
import 'package:rick_and_morty_app/presentation/bloc/character_event.dart';
import 'package:rick_and_morty_app/presentation/bloc/character_state.dart';

class MockCharacterRepository extends Mock implements CharacterRepository {}

void main() {
  late CharacterBloc characterBloc;
  late MockCharacterRepository mockRepository;

  setUp(() {
    mockRepository = MockCharacterRepository();
    characterBloc = CharacterBloc(repository: mockRepository);
  });

  tearDown(() {
    characterBloc.close();
  });

  final tCharacters = [
    const Character(
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
    ),
  ];

  test('initial state should be CharacterLoading', () {
    expect(characterBloc.state, CharacterLoading());
  });

  blocTest<CharacterBloc, CharacterState>(
    'emits [CharacterLoaded] when CharacterFetch is added.',
    build: () {
      when(
        () => mockRepository.getAllCharacters(
          any(),
          name: any(named: 'name'),
          status: any(named: 'status'),
          species: any(named: 'species'),
        ),
      ).thenAnswer((_) async => tCharacters);
      return characterBloc;
    },
    act: (bloc) => bloc.add(const CharacterFetch()),
    expect: () => [CharacterLoaded(characters: tCharacters, page: 1)],
  );

  blocTest<CharacterBloc, CharacterState>(
    'emits [CharacterLoading, CharacterLoaded] when CharacterSearchChanged is added.',
    build: () {
      when(
        () => mockRepository.getAllCharacters(
          any(),
          name: any(named: 'name'),
          status: any(named: 'status'),
          species: any(named: 'species'),
        ),
      ).thenAnswer((_) async => tCharacters);
      return characterBloc;
    },
    act: (bloc) => bloc.add(const CharacterSearchChanged('Rick')),
    wait: const Duration(milliseconds: 600), // Account for debounce
    expect: () => [
      CharacterLoading(),
      CharacterLoaded(
        characters: tCharacters,
        page: 1,
        searchQuery: 'Rick',
        hasReachedMax: true,
      ),
    ],
  );
}
