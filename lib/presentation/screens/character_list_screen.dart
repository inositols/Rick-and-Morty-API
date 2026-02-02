import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../bloc/character_bloc.dart';
import '../bloc/character_event.dart';
import '../bloc/character_state.dart';
import '../widgets/character_card.dart';
import '../../domain/entities/character.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CharacterBloc>().add(CharacterLoadMore());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Search Bar & Filters
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search characters...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) {
                    context.read<CharacterBloc>().add(
                      CharacterSearchChanged(value),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                icon: const Icon(Icons.tune),
                onPressed: () => _showFilterBottomSheet(context),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocConsumer<CharacterBloc, CharacterState>(
            listener: (context, state) {
              if (state is CharacterLoaded && state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Colors.redAccent,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is CharacterLoading) {
                return Skeletonizer(
                  enabled: true,
                  child: ListView.builder(
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return CharacterCard(
                        character: Character(
                          id: index,
                          name: 'Character Name',
                          status: 'Alive',
                          species: 'Human',
                          imageUrl: '',
                          locationName: 'Earth',
                          gender: 'Male',
                          type: '',
                          originName: 'Earth',
                          episodes: const [],
                        ),
                      );
                    },
                  ),
                );
              }
              if (state is CharacterError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message, textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CharacterBloc>().add(
                            const CharacterFetch(),
                          );
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }
              if (state is CharacterLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<CharacterBloc>().add(
                      const CharacterFetch(reset: true),
                    );
                  },
                  child:
                      state.characters.isEmpty
                          ? ListView(
                            children: const [
                              SizedBox(height: 100),
                              Center(child: Text('No characters found')),
                            ],
                          )
                          : ListView.builder(
                            controller: _scrollController,
                            itemCount:
                                state.hasReachedMax
                                    ? state.characters.length
                                    : state.characters.length + 1,
                            itemBuilder: (context, index) {
                              if (index >= state.characters.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              return CharacterCard(
                                character: state.characters[index],
                              );
                            },
                          ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedStatus;
  String? _selectedSpecies;

  @override
  void initState() {
    super.initState();
    final state = context.read<CharacterBloc>().state;
    if (state is CharacterLoaded) {
      _selectedStatus = state.status;
      _selectedSpecies = state.species;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusOptions = ['Alive', 'Dead', 'unknown'];
    final speciesOptions = ['Human', 'Alien', 'Humanoid', 'Poopybutthole'];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filters",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text("Status"),
          Wrap(
            spacing: 8,
            children:
                statusOptions.map((status) {
                  return ChoiceChip(
                    label: Text(status),
                    selected: _selectedStatus == status,
                    onSelected: (selected) {
                      setState(() {
                        _selectedStatus = selected ? status : null;
                      });
                    },
                  );
                }).toList(),
          ),
          const SizedBox(height: 16),
          const Text("Species"),
          Wrap(
            spacing: 8,
            children:
                speciesOptions.map((species) {
                  return ChoiceChip(
                    label: Text(species),
                    selected: _selectedSpecies == species,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSpecies = selected ? species : null;
                      });
                    },
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    context.read<CharacterBloc>().add(
                      const CharacterFilterChanged(status: null, species: null),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Clear All"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CharacterBloc>().add(
                      CharacterFilterChanged(
                        status: _selectedStatus,
                        species: _selectedSpecies,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Apply Filters"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
