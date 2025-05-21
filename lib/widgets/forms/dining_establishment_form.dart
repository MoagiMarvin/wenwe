import 'package:flutter/material.dart';
import 'base_venue_form.dart';

class DiningEstablishmentForm extends BaseVenueForm {
  const DiningEstablishmentForm({
    super.key,
    required super.onSubmit,
    super.initialData,
  });

  @override
  State<DiningEstablishmentForm> createState() => _DiningEstablishmentFormState();
}

class _DiningEstablishmentFormState extends BaseVenueFormState<DiningEstablishmentForm> {
  String _selectedType = 'Restaurant';
  final TextEditingController _seatingCapacityController = TextEditingController();
  final TextEditingController _cuisineTypeController = TextEditingController();
  final TextEditingController _operatingHoursController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController(); // Added contact number controller
  bool _reservationsAccepted = false;
  bool _takeoutAvailable = false;
  bool _deliveryAvailable = false;
  bool _alcoholServed = false;
  
  // New controllers for menu items
  final List<Map<String, dynamic>> _menuItems = [];
  final TextEditingController _menuItemNameController = TextEditingController();
  final TextEditingController _menuItemPriceController = TextEditingController();
  final TextEditingController _menuItemDescriptionController = TextEditingController();
  String? _menuItemImageUrl;
  
  // Menu image URL
  String? _menuImageUrl;
  
  final List<String> _diningTypes = [
    'Restaurant',
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize from existing data if available
    if (widget.initialData != null) {
      final data = widget.initialData!;
      
      if (data['type'] != null && _diningTypes.contains(data['type'])) {
        _selectedType = data['type'];
      }
      
      _seatingCapacityController.text = data['seatingCapacity'] ?? '';
      _cuisineTypeController.text = data['cuisineType'] ?? '';
      _operatingHoursController.text = data['operatingHours'] ?? '';
      _contactNumberController.text = data['contactNumber'] ?? ''; // Initialize contact number
      _reservationsAccepted = data['reservationsAccepted'] ?? false;
      _takeoutAvailable = data['takeoutAvailable'] ?? false;
      _deliveryAvailable = data['deliveryAvailable'] ?? false;
      _alcoholServed = data['alcoholServed'] ?? false;
      
      // Initialize menu items if available
      if (data['menuItems'] != null) {
        _menuItems.addAll(List<Map<String, dynamic>>.from(data['menuItems']));
      }
      
      // Initialize menu image if available
      _menuImageUrl = data['menuImageUrl'];
    }
  }

  @override
  void dispose() {
    _seatingCapacityController.dispose();
    _cuisineTypeController.dispose();
    _operatingHoursController.dispose();
    _contactNumberController.dispose(); // Dispose contact number controller
    _menuItemNameController.dispose();
    _menuItemPriceController.dispose();
    _menuItemDescriptionController.dispose();
    super.dispose();
  }

  @override
  void addVenueSpecificData(Map<String, dynamic> formData) {
    formData['type'] = _selectedType;
    formData['seatingCapacity'] = _seatingCapacityController.text;
    formData['cuisineType'] = _cuisineTypeController.text;
    formData['operatingHours'] = _operatingHoursController.text;
    formData['contactNumber'] = _contactNumberController.text; // Add contact number to form data
    formData['reservationsAccepted'] = _reservationsAccepted;
    formData['takeoutAvailable'] = _takeoutAvailable;
    formData['deliveryAvailable'] = _deliveryAvailable;
    formData['alcoholServed'] = _alcoholServed;
    formData['venueType'] = 'dining';
    formData['menuItems'] = _menuItems;
    formData['menuImageUrl'] = _menuImageUrl;
    // Note: status field is removed
  }
  
  void _addMenuItem() {
    if (_menuItemNameController.text.isNotEmpty && 
        _menuItemPriceController.text.isNotEmpty && 
        _menuItemImageUrl != null) {
      setState(() {
        // Check if we've reached the maximum number of menu items (5)
        if (_menuItems.length < 5) {
          _menuItems.add({
            'name': _menuItemNameController.text,
            'price': _menuItemPriceController.text,
            'imageUrl': _menuItemImageUrl,
            'description': _menuItemDescriptionController.text,
          });
          
          // Clear the controllers
          _menuItemNameController.clear();
          _menuItemPriceController.clear();
          _menuItemDescriptionController.clear();
          _menuItemImageUrl = null;
        } else {
          // Show a snackbar or alert that maximum items reached
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Maximum of 5 menu items allowed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    } else {
      // Show validation error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in name, price, and add an image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _removeMenuItem(int index) {
    setState(() {
      _menuItems.removeAt(index);
    });
  }
  
  // Mock method to simulate image selection
  // In a real app, you would use image_picker package
  void _selectImage(bool isMenuItem) {
    // Simulate selecting an image and getting a URL
    final String mockImageUrl = 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c';
    
    setState(() {
      if (isMenuItem) {
        _menuItemImageUrl = mockImageUrl;
      } else {
        _menuImageUrl = mockImageUrl;
      }
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image selected successfully'),
        backgroundColor: Color(0xFF4F6CAD),
      ),
    );
  }

  @override
  Widget buildVenueSpecificFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        
        // Dining establishment type dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dining Establishment Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedType,
                  isExpanded: true,
                  hint: const Text('Select Type'),
                  items: _diningTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 15),
        
        // Cuisine type
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cuisine Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _cuisineTypeController,
              decoration: InputDecoration(
                hintText: 'E.g., Italian, Indian, Mexican',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 15),
        
        // Seating capacity
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seating Capacity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _seatingCapacityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Number of seats',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 15),
        
        // Operating hours
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Operating Hours',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _operatingHoursController,
              decoration: InputDecoration(
                hintText: 'E.g., 11:00 AM - 10:00 PM',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 15),
        
        // Additional services
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Services Offered',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Reservations Accepted'),
              value: _reservationsAccepted,
              onChanged: (value) {
                setState(() {
                  _reservationsAccepted = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFF4F6CAD),
            ),
            CheckboxListTile(
              title: const Text('Takeout Available'),
              value: _takeoutAvailable,
              onChanged: (value) {
                setState(() {
                  _takeoutAvailable = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFF4F6CAD),
            ),
            CheckboxListTile(
              title: const Text('Delivery Available'),
              value: _deliveryAvailable,
              onChanged: (value) {
                setState(() {
                  _deliveryAvailable = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFF4F6CAD),
            ),
            CheckboxListTile(
              title: const Text('Alcohol Served'),
              value: _alcoholServed,
              onChanged: (value) {
                setState(() {
                  _alcoholServed = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFF4F6CAD),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Menu Image Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Menu Image',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 10),
            
            // Display selected menu image or upload button
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _menuImageUrl != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            _menuImageUrl!,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _menuImageUrl = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 20),
                            ),
                          ),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () => _selectImage(false),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 40, color: Color(0xFF4F6CAD)),
                            SizedBox(height: 8),
                            Text('Add Menu Image', style: TextStyle(color: Color(0xFF4F6CAD))),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Menu Items Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Menu Items (Max 5)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 10),
            
            // Display existing menu items
            if (_menuItems.isNotEmpty) ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          item['imageUrl'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(item['name']),
                      subtitle: Text('${item['price']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeMenuItem(index),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
            ],
            
            // Add new menu item form
            if (_menuItems.length < 5) ...[
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Menu Item',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Item Name
                    TextFormField(
                      controller: _menuItemNameController,
                      decoration: InputDecoration(
                        labelText: 'Item Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Item Price
                    TextFormField(
                      controller: _menuItemPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixText: 'R ',
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Item Description
                    TextFormField(
                      controller: _menuItemDescriptionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Description (Optional)',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Item Image
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: _menuItemImageUrl != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    _menuItemImageUrl!,
                                    width: double.infinity,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _menuItemImageUrl = null;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, size: 20),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () => _selectImage(true),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate, size: 30, color: Color(0xFF4F6CAD)),
                                    SizedBox(height: 5),
                                    Text('Add Item Image', style: TextStyle(color: Color(0xFF4F6CAD))),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Add Item Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addMenuItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F6CAD),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Add Menu Item',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Show message when max items reached
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Maximum of 5 menu items reached. Remove an item to add a new one.',
                        style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}