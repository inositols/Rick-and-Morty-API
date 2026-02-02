import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorite_bloc.dart';
import '../widgets/character_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String _sortBy = 'name';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'name', child: Text("Sort by Name")),
              const PopupMenuItem(
                value: 'status',
                child: Text("Sort by Status"),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoaded) {
            if (state.favorites.isEmpty) {
              return const Center(child: Text("No favorites yet!"));
            }
            final sortedList = List.of(state.favorites);
            if (_sortBy == 'name') {
              sortedList.sort((a, b) => a.name.compareTo(b.name));
            } else {
              sortedList.sort((a, b) => a.status.compareTo(b.status));
            }
            return ListView.builder(
              itemCount: sortedList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(
                    sortedList[index].id.toString(),
                  ), 
                  direction:
                      DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    context.read<FavoriteBloc>().add(
                      ToggleFavorite(sortedList[index]),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${sortedList[index].name} removed from favorites',
                        ),
                      ),
                    );
                  },
                  child: CharacterCard(character: sortedList[index]),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
