import 'package:flutter/material.dart';
import '../../widgets/feature_grid.dart';
import '../../widgets/feature_item.dart';
import '../../widgets/review_item.dart';
import '../../widgets/rule_item.dart';

class AccommodationDetailsPage extends StatefulWidget {
  final String title;
  final double rating;
  final String location;
  final String availability;
  final String price;
  final String imageUrl;

  const AccommodationDetailsPage({
    super.key,
    required this.title,
    required this.rating,
    required this.location,
    required this.availability,
    required this.price,
    required this.imageUrl,
  });

  @override
  State<AccommodationDetailsPage> createState() => _AccommodationDetailsPageState();
}

class _AccommodationDetailsPageState extends State<AccommodationDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, color: Colors.black),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.black),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  widget.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Location
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.location_on, color: Color(0xFF4F6CAD), size: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.location,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4F6CAD),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Price and availability
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.price,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4F6CAD),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4F6CAD).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.availability,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF4F6CAD),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Tab bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF4F6CAD),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFF4F6CAD),
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: 'Description'),
                      Tab(text: 'Features'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                ),
                
                // Tab content
                SizedBox(
                  height: 500, // Fixed height for tab content
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Description tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'About this place',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'This beautiful ${widget.title.toLowerCase()} offers a perfect blend of comfort and style. Located in the heart of ${widget.location}, it provides easy access to all major attractions, restaurants, and shopping centers.\n\nThe apartment features modern furnishings, high ceilings, and plenty of natural light. The open floor plan creates a spacious feel, making it perfect for both relaxation and entertaining guests.\n\nThe fully equipped kitchen includes stainless steel appliances, granite countertops, and all necessary cookware. The living area has a comfortable sofa, smart TV, and high-speed internet access.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'House Rules',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const RuleItem(icon: Icons.smoke_free, text: 'No smoking'),
                            const RuleItem(icon: Icons.pets, text: 'Pets allowed (with restrictions)'),
                            const RuleItem(icon: Icons.celebration, text: 'No parties or events'),
                            const RuleItem(icon: Icons.access_time, text: 'Check-in: After 3:00 PM'),
                            const RuleItem(icon: Icons.access_time, text: 'Check-out: Before 11:00 AM'),
                          ],
                        ),
                      ),
                      
                      // Features tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Amenities',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const FeatureGrid(),
                            const SizedBox(height: 24),
                            const Text(
                              'What this place offers',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const FeatureItem(icon: Icons.wifi, text: 'Free high-speed WiFi'),
                            const FeatureItem(icon: Icons.tv, text: '55" Smart TV with Netflix'),
                            const FeatureItem(icon: Icons.ac_unit, text: 'Air conditioning'),
                            const FeatureItem(icon: Icons.local_laundry_service, text: 'Washer and dryer'),
                            const FeatureItem(icon: Icons.kitchen, text: 'Fully equipped kitchen'),
                            const FeatureItem(icon: Icons.bathtub, text: 'Bathtub and shower'),
                            const FeatureItem(icon: Icons.local_parking, text: 'Free parking on premises'),
                            const FeatureItem(icon: Icons.security, text: '24/7 security'),
                          ],
                        ),
                      ),
                      
                      // Reviews tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Reviews',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3142),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${widget.rating} (42 reviews)',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const ReviewItem(
                              name: 'Sarah Johnson',
                              rating: 4.8,
                              comment: 'Absolutely loved my stay here! The location is perfect, and the apartment is exactly as pictured. Very clean and comfortable.',
                              date: 'April 2023',
                              imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
                            ),
                            const Divider(),
                            const ReviewItem(
                              name: 'Michael Chen',
                              rating: 5.0,
                              comment: 'One of the best places I\'ve stayed in. The host was very responsive and accommodating. The amenities were top-notch!',
                              date: 'March 2023',
                              imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                            ),
                            const Divider(),
                            const ReviewItem(
                              name: 'Emma Wilson',
                              rating: 4.5,
                              comment: 'Great place in a fantastic location. Very comfortable bed and the kitchen had everything I needed. Would definitely stay again!',
                              date: 'February 2023',
                              imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // Show booking confirmation dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Booking'),
                content: Text('Would you like to book ${widget.title} for ${widget.price}?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking confirmed! Check your email for details.'),
                          backgroundColor: Color(0xFF4F6CAD),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F6CAD),
                    ),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F6CAD),
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: const Color(0xFF4F6CAD).withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Book Now',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}