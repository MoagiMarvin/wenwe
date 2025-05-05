import 'package:flutter/material.dart';
import '../widgets/accommodation_card.dart';
import '../widgets/category_button.dart';
import '../widgets/stay_toggle_button.dart';

class AccommodationSearchScreen extends StatefulWidget {
  const AccommodationSearchScreen({super.key});

  @override
  State<AccommodationSearchScreen> createState() => _AccommodationSearchScreenState();
}

class _AccommodationSearchScreenState extends State<AccommodationSearchScreen> {
  bool isLongStay = true;

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
              // Stay duration toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StayToggleButton(
                    isLong: true,
                    label: "long stay",
                    isSelected: isLongStay,
                    onTap: () {
                      setState(() {
                        isLongStay = true;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  StayToggleButton(
                    isLong: false,
                    label: "short stay",
                    isSelected: !isLongStay,
                    onTap: () {
                      setState(() {
                        isLongStay = false;
                      });
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Search bar
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
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search accommodations...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(Icons.notifications_none, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Category filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryButton(label: "Single"),
                    CategoryButton(label: "Sharing"),
                    CategoryButton(label: "Bachelor"),
                    CategoryButton(label: "Apartment"),
                    CategoryButton(label: "House"),
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
}