import 'package:flutter/material.dart';
import '../widgets/category_button.dart';
import 'accommodation_search_screen.dart';
import 'short_stay_screen.dart';
import 'restaurant_details_screen.dart';
import 'reservation_form_screen.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  // Options for dropdown
  final List<String> _options = ['Long Stay', 'Short Stay', 'Restaurants'];
  String _selectedOption = 'Restaurants'; // Default for this screen
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar with dropdown
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(Icons.search, color: Colors.grey),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search restaurants...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    // Dropdown menu
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton<String>(
                        value: _selectedOption,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedOption = newValue!;
                          });
                          
                          // Navigate based on selection
                          if (newValue == 'Long Stay') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AccommodationSearchScreen(),
                              ),
                            );
                          } else if (newValue == 'Short Stay') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ShortStayScreen(),
                              ),
                            );
                          }
                        },
                        items: _options.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Category filters - horizontal scrollable
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryButton(label: "Italian"),
                    CategoryButton(label: "Indian"),
                    CategoryButton(label: "Chinese"),
                    CategoryButton(label: "Fast Food"),
                    CategoryButton(label: "Cafe"),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Restaurant listings
              Expanded(
                child: ListView(
                  children: [
                    _buildRestaurantCard(
                      context: context,
                      name: "Bella Italia",
                      cuisine: "Italian",
                      rating: 4.7,
                      priceRange: "\$\$",
                      imageUrl: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5",
                      description: "Authentic Italian cuisine with a modern twist. Our pasta is made fresh daily.",
                      address: "123 Main St, Anytown",
                      operatingHours: "11:00 AM - 10:00 PM",
                      phone: "+1 234 567 8901",
                    ),
                    const SizedBox(height: 15),
                    _buildRestaurantCard(
                      context: context,
                      name: "Spice Garden",
                      cuisine: "Indian",
                      rating: 4.5,
                      priceRange: "\$\$",
                      imageUrl: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4",
                      description: "Experience the rich flavors of authentic Indian cuisine in a cozy atmosphere.",
                      address: "456 Oak Ave, Anytown",
                      operatingHours: "12:00 PM - 10:00 PM",
                      phone: "+1 234 567 8902",
                    ),
                    const SizedBox(height: 15),
                    _buildRestaurantCard(
                      context: context,
                      name: "Golden Dragon",
                      cuisine: "Chinese",
                      rating: 4.3,
                      priceRange: "\$\$\$",
                      imageUrl: "https://images.unsplash.com/photo-1552566626-52f8b828add9",
                      description: "Traditional Chinese dishes prepared by master chefs using authentic recipes.",
                      address: "789 Elm St, Anytown",
                      operatingHours: "11:30 AM - 9:30 PM",
                      phone: "+1 234 567 8903",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
  
  Widget _buildRestaurantCard({
    required BuildContext context,
    required String name,
    required String cuisine,
    required double rating,
    required String priceRange,
    required String imageUrl,
    required String description,
    required String address,
    required String operatingHours,
    required String phone,
  }) {
    // Create restaurant data map to pass to details screen
    final Map<String, dynamic> restaurantData = {
      'name': name,
      'cuisineType': cuisine,
      'rating': rating,
      'imageUrl': imageUrl,
      'description': description,
      'address': address,
      'operatingHours': operatingHours,
      'phone': phone,
      'reservationsAccepted': true,
      'takeoutAvailable': true,
      'deliveryAvailable': cuisine != 'Fine Dining',
      'alcoholServed': true,
      'seatingCapacity': 50,
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
          // Restaurant image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      priceRange,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  cuisine,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Icon(
                      Icons.access_time,
                      color: Colors.grey[600],
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "30-45 min",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 15),
                
                // Action buttons
                Row(
                  children: [
                    // View Details Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailsScreen(
                                restaurantData: restaurantData,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F6CAD),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('View'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Reserve Button
                    Expanded(
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
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Reserve'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}