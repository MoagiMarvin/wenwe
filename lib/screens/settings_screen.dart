import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _currency = 'ZAR';
  
  final List<String> _currencies = ['ZAR', 'USD', 'EUR', 'GBP'];
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    // In a real app, you would load settings from SharedPreferences or your backend
    setState(() {
      _notificationsEnabled = true;
      _darkModeEnabled = false;
      _currency = 'ZAR';
    });
  }
  
  Future<void> _saveSettings() async {
    // In a real app, you would save settings to SharedPreferences or your backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF4F6CAD),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 16),
            
            // Settings cards
            _buildSettingsCard(
              title: 'Notifications',
              subtitle: 'Receive notifications about new inquiries and bookings',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeColor: const Color(0xFF4F6CAD),
              ),
            ),
            
            _buildSettingsCard(
              title: 'Dark Mode',
              subtitle: 'Use dark theme throughout the app',
              trailing: Switch(
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
                activeColor: const Color(0xFF4F6CAD),
              ),
            ),
            
            _buildSettingsCard(
              title: 'Currency',
              subtitle: 'Set your preferred currency',
              trailing: DropdownButton<String>(
                value: _currency,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _currency = newValue;
                    });
                  }
                },
                items: _currencies.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                underline: Container(),
              ),
            ),
            
            const SizedBox(height: 30),
            
            const Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 16),
            
            _buildSettingsCard(
              title: 'Change Password',
              subtitle: 'Update your account password',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to change password screen
              },
            ),
            
            _buildSettingsCard(
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to privacy policy screen
              },
            ),
            
            _buildSettingsCard(
              title: 'Terms of Service',
              subtitle: 'Read our terms of service',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to terms of service screen
              },
            ),
            
            const SizedBox(height: 30),
            
            _buildSettingsCard(
              title: 'Log Out',
              subtitle: 'Sign out of your account',
              trailing: const Icon(Icons.logout, color: Colors.red),
              onTap: () {
                // Handle logout
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Log Out'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle logout logic
                          Navigator.pop(context);
                          // Navigate to login screen
                        },
                        child: const Text('Log Out', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 30),
            
            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F6CAD),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3142),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}