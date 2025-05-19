import 'package:flutter/material.dart';
import 'restaurant_details_screen.dart';

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This would typically come from your database or API
    final List<Map<String, dynamic>> restaurants = [
      {
        'name': 'Italian Delight',
        'cuisineType': 'Italian',
        'rating': 4.7,
        'imageUrl': 'https://example.com/italian.jpg',
        'operatingHours': '11:00 AM - 10:00 PM',
        'reservationsAccepted': true,
        'takeoutAvailable': true,
      },
      {
        'name': 'Spice Garden',
        'cuisineType': 'Indian',
        'rating': 4.5,
        'imageUrl': 'https://example.com/indian.jpg',
        'operatingHours': '12:00 PM - 11:00 PM',
        'reservationsAccepted': true,
        'deliveryAvailable': true,
      },
      {
        'name': 'Sushi Master',
        'cuisineType': 'Japanese',
        'rating': 4.8,
        'imageUrl': 'https://example.com/japanese.jpg',
        'operatingHours': '11:30 AM - 9:30 PM',
        'reservationsAccepted': true,
        'alcoholServed': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
        backgroundColor: const Color(0xFF4F6CAD),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return RestaurantCard(
            restaurantData: restaurant,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantDetailsScreen(
                    restaurantData: restaurant,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Map<String, dynamic> restaurantData;
  final VoidCallback onTap;

  const RestaurantCard({
    Key? key,
    required this.restaurantData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            SizedBox(
              height: 180,
              width: double.infinity,
              child: restaurantData['imageUrl'] != null
                  ? Image.network(
                      restaurantData['imageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF4F6CAD),
                          child: const Center(
                            child: Icon(
                              Icons.restaurant,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: const Color(0xFF4F6CAD),
                      child: const Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurantData['name'] ?? 'Restaurant',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            restaurantData['rating']?.toString() ?? '4.5',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Cuisine Type
                  Text(
                    restaurantData['cuisineType'] ?? 'Various Cuisine',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Operating Hours
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        restaurantData['operatingHours'] ?? 'Open: 11:00 AM - 10:00 PM',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Services
                  Wrap(
                    spacing: 8,
                    children: [
                      if (restaurantData['reservationsAccepted'] == true)
                        _buildServiceTag('Reservations'),
                      if (restaurantData['takeoutAvailable'] == true)
                        _buildServiceTag('Takeout'),
                      if (restaurantData['deliveryAvailable'] == true)
                        _buildServiceTag('Delivery'),
                      if (restaurantData['alcoholServed'] == true)
                        _buildServiceTag('Bar'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildServiceTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF4F6CAD).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF4F6CAD),
        ),
      ),
    );
  }
}