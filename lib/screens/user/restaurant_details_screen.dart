import 'package:flutter/material.dart';
import 'package:bnb/screens/user/reservation_form_screen.dart';
import 'package:bnb/screens/user/full_menu_screen.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> restaurantData;

  const RestaurantDetailsScreen({
    Key? key,
    required this.restaurantData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample menu images - in a real app, these would come from the restaurantData
    final List<Map<String, dynamic>> menuItems = [
      {
        'name': 'Signature Pasta',
        'price': '\$15.99',
        'imageUrl': 'https://images.unsplash.com/photo-1551183053-bf91a1d81141',
        'description': 'Homemade pasta with rich tomato sauce and fresh basil'
      },
      {
        'name': 'Grilled Salmon',
        'price': '\$22.99',
        'imageUrl': 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2',
        'description': 'Fresh salmon fillet with lemon butter sauce and seasonal vegetables'
      },
      {
        'name': 'Chocolate Dessert',
        'price': '\$8.99',
        'imageUrl': 'https://images.unsplash.com/photo-1563805042-7684c019e1cb',
        'description': 'Decadent chocolate cake with vanilla ice cream'
      },
      {
        'name': 'Fresh Salad',
        'price': '\$12.99',
        'imageUrl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
        'description': 'Mixed greens with seasonal vegetables and house dressing'
      },
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Restaurant Image
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                restaurantData['name'] ?? 'Restaurant',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              background: restaurantData['imageUrl'] != null
                  ? Image.network(
                      restaurantData['imageUrl'],
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: const Color(0xFF4F6CAD),
                      child: const Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
          
          // Restaurant Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cuisine Type and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        backgroundColor: const Color(0xFF4F6CAD).withOpacity(0.2),
                        label: Text(
                          restaurantData['cuisineType'] ?? 'Various Cuisine',
                          style: const TextStyle(
                            color: Color(0xFF4F6CAD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
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
                  
                  const SizedBox(height: 16),
                  
                  // Address
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          restaurantData['address'] ?? '123 Restaurant Street, City',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Operating Hours
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        restaurantData['operatingHours'] ?? 'Open: 11:00 AM - 10:00 PM',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Phone
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        restaurantData['phone'] ?? '+1 234 567 8900',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  
                  const Divider(height: 32),
                  
                  // Services Offered
                  const Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Services Grid
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (restaurantData['reservationsAccepted'] == true)
                        _buildServiceChip('Reservations', Icons.calendar_today),
                      if (restaurantData['takeoutAvailable'] == true)
                        _buildServiceChip('Takeout', Icons.takeout_dining),
                      if (restaurantData['deliveryAvailable'] == true)
                        _buildServiceChip('Delivery', Icons.delivery_dining),
                      if (restaurantData['alcoholServed'] == true)
                        _buildServiceChip('Bar', Icons.local_bar),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Seating Capacity
                  if (restaurantData['seatingCapacity'] != null)
                    Row(
                      children: [
                        const Icon(Icons.people, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Seating Capacity: ${restaurantData['seatingCapacity']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  
                  const Divider(height: 32),
                  
                  // Menu Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Menu Highlights',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to full menu screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullMenuScreen(
                                restaurantName: restaurantData['name'] ?? 'Restaurant',
                              ),
                            ),
                          );
                        },
                        child: const Text('View Full Menu'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Menu Images Carousel
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return Container(
                          width: 200,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Dish Image
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Image.network(
                                  item['imageUrl'],
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          item['price'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF4F6CAD),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['description'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const Divider(height: 32),
                  
                  // Description
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    restaurantData['description'] ?? 
                    'This restaurant offers a delightful dining experience with a variety of dishes prepared by our expert chefs. The ambiance is perfect for both casual dining and special occasions.',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Make Reservation Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReservationFormScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F6CAD),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Make Reservation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildServiceChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(
        icon,
        size: 18,
        color: const Color(0xFF4F6CAD),
      ),
      backgroundColor: Colors.grey[200],
      label: Text(label),
    );
  }
}