import 'package:flutter/material.dart';
import '../widgets/accommodation_card.dart';
import '../widgets/category_button.dart';

class LongStayScreen extends StatefulWidget {
  const LongStayScreen({super.key});

  @override
  State<LongStayScreen> createState() => _LongStayScreenState();
}

class _LongStayScreenState extends State<LongStayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Long Stay Accommodations'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search long-term accommodations...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(Icons.filter_list, color: Colors.grey[700]),
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
    );
  }
}