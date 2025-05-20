import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullMenuScreen extends StatelessWidget {
  final String restaurantName;

  const FullMenuScreen({
    Key? key,
    required this.restaurantName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample menu images - in a real app, these would come from a database
    final List<String> menuImages = [
      'https://images.unsplash.com/photo-1627907228175-2bf3826a1f3d', // Menu page 1
      'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46', // Menu page 2
      'https://images.unsplash.com/photo-1596464716127-f2a82984de30', // Menu page 3
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('$restaurantName Menu'),
        backgroundColor: const Color(0xFF4F6CAD),
        foregroundColor: Colors.white,
      ),
      body: PageView.builder(
        itemCount: menuImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Open full-screen zoomable view
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    backgroundColor: Colors.black,
                    appBar: AppBar(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      title: Text('Menu Page ${index + 1}'),
                    ),
                    body: PhotoView(
                      imageProvider: NetworkImage(menuImages[index]),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    ),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Menu Page ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap to zoom',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          menuImages[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Swipe to see more pages (${index + 1}/${menuImages.length})',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}