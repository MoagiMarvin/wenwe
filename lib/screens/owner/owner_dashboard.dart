import 'package:flutter/material.dart';
import '../../models/compound.dart';
import '../../widgets/forms/compound_form.dart';
import 'compound_view_screen.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  // Mock data for demo
  final List<Compound> _compounds = [
    Compound(
      id: '1',
      name: 'Green Acres',
      street: '123 Main St',
      city: 'Polokwane',
      province: 'Limpopo',
      postalCode: '0700',
      description: 'Modern apartments close to University of Limpopo.',
      amenities: ['WiFi', 'Parking', 'Security'],
      tags: ['student', 'university', 'affordable'],
      latitude: -23.9045,
      longitude: 29.4689,
      images: [
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
        'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
      ],
    ),
  ];

  final List<Map<String, dynamic>> _properties = [];

  // Statistics will be calculated from compound properties
  int get totalCompounds => _compounds.length;
  
  int get totalProperties {
    // This will be updated when properties are added through compound view
    return _properties.length;
  }

  int get totalRooms {
    // This will be calculated from actual room data in compound properties
    return _properties.fold(0, (sum, property) {
      final rooms = property['rooms'] as List<dynamic>? ?? [];
      return sum + rooms.length;
    });
  }

  int get availableRooms {
    // Count available rooms
    return _properties.fold(0, (sum, property) {
      final rooms = property['rooms'] as List<dynamic>? ?? [];
      return sum + rooms.where((room) => room['isAvailable'] == true).length;
    });
  }

  int get occupiedRooms => totalRooms - availableRooms;

  double get occupancyRate => totalRooms > 0 ? (occupiedRooms / totalRooms) * 100 : 0;

  void _showAddCompoundDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 600,
          height: 700,
          padding: const EdgeInsets.all(16),
          child: CompoundForm(
            onSubmit: (compoundData) {
              setState(() {
                _compounds.add(
                  Compound(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: compoundData['name'],
                    street: compoundData['street'],
                    city: compoundData['city'],
                    province: compoundData['province'],
                    postalCode: compoundData['postalCode'],
                    description: compoundData['description'],
                    amenities: List<String>.from(compoundData['amenities']),
                    tags: List<String>.from(compoundData['tags']),
                    latitude: compoundData['latitude'],
                    longitude: compoundData['longitude'],
                    images: List<String>.from(compoundData['images']),
                  ),
                );
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Compound added successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  Compound? _getCompoundForProperty(String compoundId) {
    try {
      return _compounds.firstWhere((compound) => compound.id == compoundId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        backgroundColor: const Color(0xFF4F6CAD),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Show settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats Cards
            _buildStatsCards(),
            
            const SizedBox(height: 24),
            
            // Compounds Section
            _buildCompoundsSection(),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Compounds',
            totalCompounds.toString(),
            Icons.location_city,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Properties',
            totalProperties.toString(),
            Icons.home,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Total Rooms',
            totalRooms.toString(),
            Icons.hotel,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Available',
            availableRooms.toString(),
            Icons.check_circle,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompoundsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '📍 My Compounds',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showAddCompoundDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Compound'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F6CAD),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_compounds.isEmpty)
          _buildEmptyState(
            'No compounds yet',
            'Add your first compound to start managing properties',
            Icons.location_city,
            _showAddCompoundDialog,
          )
        else
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _compounds.length,
              itemBuilder: (context, index) {
                return _buildCompoundCard(_compounds[index]);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCompoundCard(Compound compound) {
    final propertyCount = _properties.where((p) => p['compoundId'] == compound.id).length;
    
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompoundViewScreen(
                  compound: compound,
                  onAddProperty: (propertyData) {
                    setState(() {
                      _properties.add(propertyData);
                    });
                  },
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compound.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '📍 ${compound.city}, ${compound.province}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '↳ $propertyCount Properties',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4F6CAD),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎯 Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Show bookings
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('View Bookings'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Show income tracking
                },
                icon: const Icon(Icons.attach_money),
                label: const Text('Income Tracking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F6CAD),
                foregroundColor: Colors.white,
              ),
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}