import 'package:flutter/material.dart';
import '../widgets/property_list_item.dart';
import '../widgets/admin_property_form.dart';


class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Add a variable to track the selected tab
  int _selectedIndex = 0;
  
  // Mock data for properties
  final List<Map<String, dynamic>> _properties = [
    {
      'id': '1',
      'title': 'Modern Studio Apartment',
      'location': 'Downtown',
      'price': 'R1200/month',  
      'type': 'Apartment',
      'status': 'Available',
      'imageUrl': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
    },
    {
      'id': '2',
      'title': 'Luxury Apartment with View',
      'location': 'City Center',
      'price': 'R1800/month', 
      'type': 'Apartment',
      'status': 'Available',
      'imageUrl': 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2',
    },
    {
      'id': '3',
      'title': 'Cozy Single Room',
      'location': 'University Area',
      'price': 'R800/month',  
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

  void _editProperty(Map<String, dynamic> property) {
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
        child: AdminPropertyForm(
          onSubmit: (updatedProperty) => _updateProperty(property['id'], updatedProperty),
          initialProperty: property, // Pass the existing property data
        ),
      ),
    );
  }

  void _updateProperty(String id, Map<String, dynamic> updatedProperty) {
    setState(() {
      final index = _properties.indexWhere((property) => property['id'] == id);
      if (index != -1) {
        _properties[index] = {
          'id': id,
          ...updatedProperty,
        };
      }
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Property updated successfully!'),
        backgroundColor: Color(0xFF4F6CAD),
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
      body: _getScreenForIndex(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Required for 4+ items
        selectedItemColor: const Color(0xFF4F6CAD),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 
          ? FloatingActionButton(
              onPressed: _showAddPropertyForm,
              backgroundColor: const Color(0xFF4F6CAD),
              child: const Icon(Icons.add),
            )
          : null, // Only show FAB on dashboard tab
    );
  }
  
  // Method to return the appropriate screen based on selected index
  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return _buildDashboardScreen();
      case 1:
        return _buildMessagesScreen();
      case 2:
        return _buildProfileScreen();
      case 3:
        return _buildSettingsScreen();
      default:
        return _buildDashboardScreen();
    }
  }
  
  // Dashboard screen (your existing content)
  Widget _buildDashboardScreen() {
    return Column(
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
                      onEdit: () => _editProperty(property),
                    );
                  },
                ),
        ),
      ],
    );
  }
  
  // Messages screen placeholder
  Widget _buildMessagesScreen() {
    return const Center(
      child: Text(
        'Messages',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
  
  // Profile screen placeholder
  Widget _buildProfileScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Profile picture
          const CircleAvatar(
            radius: 60,
            backgroundColor: Color(0xFFE0E0E0),
            child: Icon(Icons.person, size: 80, color: Color(0xFF4F6CAD)),
          ),
          const SizedBox(height: 20),
          // Name
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 5),
          // Email
          Text(
            'john.doe@example.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),
          // Profile info card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildProfileInfoRow(Icons.phone, 'Phone', '+27 71 234 5678'),
                const Divider(),
                _buildProfileInfoRow(Icons.location_on, 'Address', '123 Main Street, Cape Town'),
                const Divider(),
                _buildProfileInfoRow(Icons.calendar_today, 'Member Since', 'January 2023'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Edit profile button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Add edit profile functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F6CAD),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Edit Profile'),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method for profile info rows
  Widget _buildProfileInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4F6CAD)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Settings screen placeholder
  Widget _buildSettingsScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 20),
          _buildSettingsCard(
            'Account Settings',
            [
              _buildSettingsItem(Icons.person, 'Personal Information'),
              _buildSettingsItem(Icons.lock, 'Change Password'),
              _buildSettingsItem(Icons.payment, 'Payment Methods'),
            ],
          ),
          const SizedBox(height: 15),
          _buildSettingsCard(
            'Preferences',
            [
              _buildSettingsItem(Icons.notifications, 'Notifications'),
              _buildSettingsItem(Icons.language, 'Language'),
              _buildSettingsItem(Icons.dark_mode, 'Dark Mode'),
            ],
          ),
          const SizedBox(height: 15),
          _buildSettingsCard(
            'Support',
            [
              _buildSettingsItem(Icons.help, 'Help Center'),
              _buildSettingsItem(Icons.info, 'About'),
              _buildSettingsItem(Icons.logout, 'Log Out', isLogout: true),
            ],
          ),
        ],
      ),
    );
  }
  
  // Helper method for settings cards
  Widget _buildSettingsCard(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
          ),
          const Divider(height: 1),
          ...items,
        ],
      ),
    );
  }
  
  // Helper method for settings items
  Widget _buildSettingsItem(IconData icon, String title, {bool isLogout = false}) {
    return InkWell(
      onTap: () {
        // Handle settings item tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.red : const Color(0xFF4F6CAD),
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isLogout ? Colors.red : const Color(0xFF2D3142),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
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