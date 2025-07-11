import 'package:flutter/material.dart';
import '../../models/compound.dart';
import '../../widgets/forms/compound_form.dart';
import '../../widgets/forms/compound_property_form.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({Key? key}) : super(key: key);

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  // Mock data for demo
  List<Compound> _compounds = [
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

  List<Map<String, dynamic>> _properties = [
    {
      'id': '1',
      'compoundId': '1',
      'propertyName': 'Student Bachelors',
      'type': 'Bachelor',
      'duration': 'Long-term',
      'businessType': 'accommodation',
      'roomTypes': [
        {
          'name': 'Standard Bachelor',
          'quantity': 10,
          'availableCount': 8,
          'price': '3000',
          'size': '25',
          'description': 'Basic bachelor accommodation for students',
          'amenities': ['Private Bathroom', 'WiFi', 'Desk'],
          'images': [],
        },
        {
          'name': 'Premium Bachelor',
          'quantity': 5,
          'availableCount': 3,
          'price': '3500',
          'size': '30',
          'description': 'Upgraded bachelor with kitchenette',
          'amenities': ['Private Bathroom', 'Kitchenette', 'WiFi', 'Desk', 'TV'],
          'images': [],
        },
      ],
    }
  ];

  // Statistics calculation
  int get totalRooms {
    int total = 0;
    for (var property in _properties) {
      if (property['roomTypes'] != null) {
        for (var roomType in property['roomTypes']) {
          total += int.tryParse(roomType['quantity'].toString()) ?? 0;
        }
      }
    }
    return total;
  }

  int get availableRooms {
    int available = 0;
    for (var property in _properties) {
      if (property['roomTypes'] != null) {
        for (var roomType in property['roomTypes']) {
          available += int.tryParse(roomType['availableCount'].toString()) ?? 0;
        }
      }
    }
    return available;
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

  void _showAddPropertyDialog() {
    if (_compounds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a compound first!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Business Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFF4F6CAD)),
              title: const Text('Accommodation'),
              subtitle: const Text('Bachelor, Single, Apartment, House'),
              onTap: () {
                Navigator.pop(context);
                _showPropertyForm('accommodation');
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant, color: Color(0xFF4F6CAD)),
              title: const Text('Dining Establishment'),
              subtitle: const Text('Restaurant, Cafe, Bar'),
              onTap: () {
                Navigator.pop(context);
                _showPropertyForm('dining');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPropertyForm(String businessType) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 800,
          height: 700,
          child: CompoundPropertyForm(
            compoundId: _compounds.first.id, // Default to first compound for now
            businessType: businessType,
            onSubmit: (propertyData) {
              setState(() {
                _properties.add({
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  ...propertyData,
                });
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${businessType == 'accommodation' ? 'Accommodation' : 'Dining'} property added successfully!'),
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
            
            // Properties Section
            _buildPropertiesSection(),
            
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
            'Total Rooms',
            totalRooms.toString(),
            Icons.hotel,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Available',
            availableRooms.toString(),
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Occupied',
            occupiedRooms.toString(),
            Icons.person,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Occupancy',
            '${occupancyRate.toStringAsFixed(1)}%',
            Icons.analytics,
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
    );
  }

  Widget _buildPropertiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '🏠 My Properties',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showAddPropertyDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Property'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_properties.isEmpty)
          _buildEmptyState(
            'No properties yet',
            'Add your first property to start earning income',
            Icons.home,
            _showAddPropertyDialog,
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _properties.length,
            itemBuilder: (context, index) {
              return _buildPropertyCard(_properties[index]);
            },
          ),
      ],
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    final compound = _getCompoundForProperty(property['compoundId'] ?? '');
    final roomTypes = property['roomTypes'] as List<dynamic>? ?? [];
    
    int totalRooms = 0;
    int availableRooms = 0;
    for (var roomType in roomTypes) {
      totalRooms += int.tryParse(roomType['quantity'].toString()) ?? 0;
      availableRooms += int.tryParse(roomType['availableCount'].toString()) ?? 0;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  property['businessType'] == 'accommodation' ? Icons.home : Icons.restaurant,
                  color: const Color(0xFF4F6CAD),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property['propertyName'] ?? 'Unnamed Property',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      Text(
                        '🏢 ${compound?.name ?? 'Unknown Compound'} • ${property['type']} • ${property['duration'] ?? 'Dining'}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: availableRooms > 0 ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$availableRooms/$totalRooms Available',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            if (roomTypes.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Room Types (${roomTypes.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: roomTypes.map((roomType) => Chip(
                  label: Text(
                    '${roomType['name']} (${roomType['availableCount']}/${roomType['quantity']})',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: const Color(0xFF4F6CAD).withOpacity(0.1),
                )).toList(),
              ),
            ],
          ],
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