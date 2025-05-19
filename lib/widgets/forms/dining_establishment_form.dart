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
  bool _reservationsAccepted = false;
  bool _takeoutAvailable = false;
  bool _deliveryAvailable = false;
  bool _alcoholServed = false;

  
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
      _reservationsAccepted = data['reservationsAccepted'] ?? false;
      _takeoutAvailable = data['takeoutAvailable'] ?? false;
      _deliveryAvailable = data['deliveryAvailable'] ?? false;
      _alcoholServed = data['alcoholServed'] ?? false;
    }
  }

  @override
  void dispose() {
    _seatingCapacityController.dispose();
    _cuisineTypeController.dispose();
    _operatingHoursController.dispose();
    super.dispose();
  }

  @override
  void addVenueSpecificData(Map<String, dynamic> formData) {
    formData['type'] = _selectedType;
    formData['seatingCapacity'] = _seatingCapacityController.text;
    formData['cuisineType'] = _cuisineTypeController.text;
    formData['operatingHours'] = _operatingHoursController.text;
    formData['reservationsAccepted'] = _reservationsAccepted;
    formData['takeoutAvailable'] = _takeoutAvailable;
    formData['deliveryAvailable'] = _deliveryAvailable;
    formData['alcoholServed'] = _alcoholServed;
    formData['venueType'] = 'dining';
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
      ],
    );
  }
}