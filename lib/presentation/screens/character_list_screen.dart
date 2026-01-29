import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character_bloc.dart';
import '../bloc/character_event.dart';
import '../bloc/character_state.dart';
import '../widgets/character_card.dart';

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
    return BlocConsumer<CharacterBloc, CharacterState>(
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
          return const Center(child: CircularProgressIndicator());
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
                    context.read<CharacterBloc>().add(CharacterFetch());
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }
        if (state is CharacterLoaded) {
          if (state.characters.isEmpty) {
            return const Center(child: Text('No characters found'));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax
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

              return CharacterCard(character: state.characters[index]);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
