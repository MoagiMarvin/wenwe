import 'package:flutter/material.dart';
import 'long_stay_screen.dart';
import 'short_stay_screen.dart';
import 'restaurant_list_screen.dart';
import '../../widgets/category_button.dart';
import '../../widgets/accommodation_card.dart';

class AccommodationSearchScreen extends StatefulWidget {
  const AccommodationSearchScreen({super.key});

  @override
  State<AccommodationSearchScreen> createState() => _AccommodationSearchScreenState();
}

class _AccommodationSearchScreenState extends State<AccommodationSearchScreen> {
  // Options for dropdown
  final List<String> _options = ['Long Stay', 'Short Stay', 'Restaurants'];
  String _selectedOption = 'Long Stay'; // Default selection
  
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
                        decoration: InputDecoration(
                          hintText: _getSearchHint(),
                          border: InputBorder.none,
                          hintStyle: const TextStyle(color: Colors.grey),
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
                          if (newValue == 'Short Stay') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ShortStayScreen(),
                              ),
                            );
                          } else if (newValue == 'Restaurants') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RestaurantListScreen(),
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
                    CategoryButton(label: "Single"),
                    CategoryButton(label: "Sharing"),
                    CategoryButton(label: "House"),
                    CategoryButton(label: "Apartment"),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Accommodation listings
              Expanded(
                child: ListView(
                  children: const [
                    AccommodationCard(
                      title: "Modern Studio Apartment",
                      rating: 4.5,
                      location: "Downtown",
                      availability: "Available Immediately",
                      price: "\$1200/month",
                      imageUrl: "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
                    ),
                    SizedBox(height: 15),
                    AccommodationCard(
                      title: "Luxury Apartment with View",
                      rating: 4.8,
                      location: "City Center",
                      availability: "Available from June 1",
                      price: "\$1800/month",
                      imageUrl: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
                    ),
                    SizedBox(height: 15),
                    AccommodationCard(
                      title: "Cozy 2-Bedroom House",
                      rating: 4.3,
                      location: "Suburban Area",
                      availability: "Available from July 15",
                      price: "\$1500/month",
                      imageUrl: "https://images.unsplash.com/photo-1568605114967-8130f3a36994",
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
  
  // Helper method to get search hint based on selected option
  String _getSearchHint() {
    switch (_selectedOption) {
      case 'Long Stay':
        return 'Search long-term accommodations...';
      case 'Short Stay':
        return 'Search resorts and short stays...';
      case 'Restaurants':
        return 'Search restaurants...';
      default:
        return 'Search...';
    }
  }
}