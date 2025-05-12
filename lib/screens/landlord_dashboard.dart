import 'package:flutter/material.dart';
import 'package:bnb/screens/landlord_profile_screen.dart';
import 'package:bnb/screens/settings_screen.dart';

class LandlordDashboard extends StatefulWidget {
  const LandlordDashboard({Key? key}) : super(key: key);

  @override
  State<LandlordDashboard> createState() => _LandlordDashboardState();
}

class _LandlordDashboardState extends State<LandlordDashboard> {
  int _selectedIndex = 0;
  
  // We'll define these screens as late variables to ensure they're initialized
  late final List<Widget> _screens;
  
  @override
  void initState() {
    super.initState();
    // Initialize screens in initState to avoid any potential issues
    _screens = [
      const PropertiesScreen(),
      const BookingsScreen(),
      const LandlordProfileScreen(), // Profile screen
      const SettingsScreen(), // Settings screen
    ];
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('Tapped on index: $index'); // Debug print to verify tap is registered
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landlord Dashboard'),
        backgroundColor: const Color(0xFF4F6CAD),
        foregroundColor: Colors.white,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF4F6CAD),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Properties',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Placeholder screens - replace with your actual screens
class PropertiesScreen extends StatelessWidget {
  const PropertiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Properties Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Bookings Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}