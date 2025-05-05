import 'package:flutter/material.dart';
import '../widgets/property_list_item.dart';
import '../widgets/admin_property_form.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Mock data for properties
  final List<Map<String, dynamic>> _properties = [
    {
      'id': '1',
      'title': 'Modern Studio Apartment',
      'location': 'Downtown',
      'price': '\$1200/month',
      'type': 'Apartment',
      'status': 'Available',
      'imageUrl': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
    },
    {
      'id': '2',
      'title': 'Luxury Apartment with View',
      'location': 'City Center',
      'price': '\$1800/month',
      'type': 'Apartment',
      'status': 'Available',
      'imageUrl': 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2',
    },
    {
      'id': '3',
      'title': 'Cozy Single Room',
      'location': 'University Area',
      'price': '\$800/month',
      'type': 'Single',
      'status': 'Pending',
      'imageUrl': 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85',
    },
  ];

  void _addNewProperty(Map<String, dynamic> property) {
    setState(() {
      _properties.add({
        'id': (_properties.length + 1).toString(),
        ...property,
      });
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Property added successfully!'),
        backgroundColor: Color(0xFF4F6CAD),
      ),
    );
  }

  void _deleteProperty(String id) {
    setState(() {
      _properties.removeWhere((property) => property['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Property deleted successfully!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showAddPropertyForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: AdminPropertyForm(onSubmit: _addNewProperty),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Landlord Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4F6CAD),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF4F6CAD),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome, Landlord!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'You have ${_properties.length} properties listed',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _StatCard(
                      title: 'Active',
                      value: _properties.where((p) => p['status'] == 'Available').length.toString(),
                      color: Colors.green,
                    ),
                    const SizedBox(width: 15),
                    _StatCard(
                      title: 'Pending',
                      value: _properties.where((p) => p['status'] == 'Pending').length.toString(),
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 15),
                    _StatCard(
                      title: 'Rented',
                      value: _properties.where((p) => p['status'] == 'Rented').length.toString(),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Property list header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Properties',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _showAddPropertyForm,
                  icon: const Icon(Icons.add, color: Color(0xFF4F6CAD)),
                  label: const Text(
                    'Add New',
                    style: TextStyle(color: Color(0xFF4F6CAD)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF4F6CAD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Property list
          Expanded(
            child: _properties.isEmpty
                ? const Center(
                    child: Text(
                      'No properties yet. Add your first property!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _properties.length,
                    itemBuilder: (context, index) {
                      final property = _properties[index];
                      return PropertyListItem(
                        property: property,
                        onDelete: () => _deleteProperty(property['id']),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF4F6CAD),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPropertyForm,
        backgroundColor: const Color(0xFF4F6CAD),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const Spacer(),
                Icon(Icons.home, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }
}