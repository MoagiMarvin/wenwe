import 'package:flutter/material.dart';

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> amenities = [
      {'icon': Icons.wifi, 'name': 'WiFi'},
      {'icon': Icons.ac_unit, 'name': 'AC'},
      {'icon': Icons.tv, 'name': 'TV'},
      {'icon': Icons.kitchen, 'name': 'Kitchen'},
      {'icon': Icons.local_parking, 'name': 'Parking'},
      {'icon': Icons.pool, 'name': 'Pool'},
      {'icon': Icons.fitness_center, 'name': 'Gym'},
      {'icon': Icons.hot_tub, 'name': 'Hot Tub'},
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: amenities.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                amenities[index]['icon'],
                color: const Color(0xFF4F6CAD),
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                amenities[index]['name'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}