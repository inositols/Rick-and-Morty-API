import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/character.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                character.name,
                style: const TextStyle(
                  shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                ),
              ),
              background: Hero(
                tag: 'character-image-${character.id}',
                child: CachedNetworkImage(
                  imageUrl: character.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(context),
                    const SizedBox(height: 24),
                    Text(
                      "Appearances",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    ...character.episodes.map(
                      (ep) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.movie),
                          title: Text("Episode ${ep.split('/').last}"),
                          subtitle: const Text("Tap to view details (Future)"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildInfoRow(context, "Status", character.status, _getStatusColor()),
            const Divider(),
            _buildInfoRow(context, "Species", character.species, null),
            const Divider(),
            _buildInfoRow(context, "Gender", character.gender, null),
            const Divider(),
            _buildInfoRow(context, "Origin", character.originName, null),
            const Divider(),
            _buildInfoRow(context, "Last Location", character.locationName, null),
            if (character.type.isNotEmpty) ...[
              const Divider(),
              _buildInfoRow(context, "Type", character.type, null),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    Color? valueColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: valueColor, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (character.status) {
      case 'Alive':
        return Colors.green;
      case 'Dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
