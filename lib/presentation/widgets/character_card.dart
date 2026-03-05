import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/domain/entities/character.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const CharacterCard({
    super.key,
    required this.character,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              _buildImage(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildName(),
                    const SizedBox(height: 4),
                    _buildStatusRow(),
                    const SizedBox(height: 4),
                    _buildLocation(),
                  ],
                ),
              ),
              _buildFavoriteButton(),
            ],
          ),
        ),
      ),
    );
  }

  String _getThumbnailUrl(String originalUrl) {
    final encoded = Uri.encodeComponent(originalUrl);
    return 'https://images.weserv.nl/?url=$encoded&w=80&h=80&fit=cover';
  }

  Widget _buildImage() {
    final imageUrl = character.image.isEmpty
        ? 'https://rickandmortyapi.com/api/character/avatar/1.jpeg'
        : character.image;

    final thumbnailUrl = _getThumbnailUrl(imageUrl);

    return SizedBox(
      width: 80,
      height: 80,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ExtendedImage.network(
          thumbnailUrl,
          fit: BoxFit.cover,
          cache: true,
          retries: 3,
          timeLimit: const Duration(seconds: 10),
          loadStateChanged: (state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: state.loadingProgress?.expectedTotalBytes != null
                          ? state.loadingProgress!.cumulativeBytesLoaded /
                          state.loadingProgress!.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              case LoadState.completed:
                return state.completedWidget;
              case LoadState.failed:
                return GestureDetector(
                  onTap: () => state.reLoadImage(),
                  child: Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  Widget _buildName() {
    return Text(
      character.name,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatusRow() {
    final statusColor = _getStatusColor(character.status);
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            '${character.status} • ${character.species}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        const Icon(Icons.location_on, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            character.location,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return IconButton(
      iconSize: 28,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Icon(
          isFavorite ? Icons.star : Icons.star_border_outlined,
          key: ValueKey<bool>(isFavorite),
          color: isFavorite ? Colors.amber : Colors.grey,
        ),
      ),
      onPressed: onFavoriteTap,
    );
  }

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(character.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Статус', character.status),
            _buildDetailRow('Вид', character.species),
            _buildDetailRow('Пол', character.gender),
            _buildDetailRow('Локация', character.location),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(
            child: Text(value, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive': return Colors.green;
      case 'dead': return Colors.red;
      default: return Colors.grey;
    }
  }
}