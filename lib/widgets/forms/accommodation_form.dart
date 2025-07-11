import 'package:flutter/material.dart';
import 'base_venue_form.dart';
import '../room_type_management_widget.dart';
import '../common/form_fields.dart';

class AccommodationForm extends BaseVenueForm {
  const AccommodationForm({
    Key? key,
    required Function(Map<String, dynamic>) onSubmit,
    Map<String, dynamic>? initialData,
  }) : super(key: key, onSubmit: onSubmit, initialData: initialData);

  @override
  State<AccommodationForm> createState() => _AccommodationFormState();
}

class _AccommodationFormState extends BaseVenueFormState<AccommodationForm> {
  String _selectedType = 'Apartment';
  String _selectedDuration = 'Long-term';
  List<Map<String, dynamic>> _rooms = [];
  String _compoundId = '';
  
  // Property types based on duration
  final List<String> _longTermPropertyTypes = [
    'Apartment',
    'House',
    'Single Room',
    'Shared Room',
    'Bachelor',
  ];
  
  final List<String> _shortTermPropertyTypes = [
    'House',
    'Shared Room',
    'Single Room',
    'Bachelor',
    'Villa',
    'Lodge',
    'Resort',
    'Hotel',
  ];
  
  List<String> _propertyTypes = [];
  
  final List<String> _durationOptions = [
    'Long-term',
    'Short-term',
    'Both',
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize property types based on selected duration
    _propertyTypes = _selectedDuration == 'Long-term' 
        ? _longTermPropertyTypes 
        : _shortTermPropertyTypes;
    
    // Initialize from existing data if available
    if (widget.initialData != null) {
      final data = widget.initialData!;
      
      if (data['duration'] != null && _durationOptions.contains(data['duration'])) {
        _selectedDuration = data['duration'];
        _updatePropertyTypes(_selectedDuration);
      }
      
      if (data['type'] != null && _propertyTypes.contains(data['type'])) {
        _selectedType = data['type'];
      }

      if (data['compoundId'] != null) {
        _compoundId = data['compoundId'];
      }

      if (data['rooms'] != null && data['rooms'] is List) {
        _rooms = List<Map<String, dynamic>>.from(data['rooms']);
      }
    }
  }

  void _updatePropertyTypes(String duration) {
    setState(() {
      _selectedDuration = duration;
      if (duration == 'Short-term') {
        _propertyTypes = _shortTermPropertyTypes;
      } else if (duration == 'Long-term') {
        _propertyTypes = _longTermPropertyTypes;
      } else { // Both
        _propertyTypes = [..._longTermPropertyTypes];
        // Add short-term types that aren't already in the list
        for (var type in _shortTermPropertyTypes) {
          if (!_propertyTypes.contains(type)) {
            _propertyTypes.add(type);
          }
        }
      }
      
      // If current selected type is not in the new list, select the first one
      if (!_propertyTypes.contains(_selectedType)) {
        _selectedType = _propertyTypes[0];
      }
    });
  }

  @override
  void addVenueSpecificData(Map<String, dynamic> formData) {
    formData['type'] = _selectedType;
    formData['duration'] = _selectedDuration;
    formData['venueType'] = 'accommodation';
    formData['rooms'] = _rooms;
    formData['compoundId'] = _compoundId;
  }

  @override
  Widget buildVenueSpecificFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        
        // Duration dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Duration',
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
                  value: _selectedDuration,
                  isExpanded: true,
                  hint: const Text('Select Duration'),
                  items: _durationOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      _updatePropertyTypes(newValue);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 15),
        
        // Property type dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Property Type',
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
                  items: _propertyTypes.map((String value) {
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
        
        const SizedBox(height: 24),
        
        // Room Type Management Section
        RoomTypeManagementWidget(
          propertyType: _selectedType,
          compoundId: _compoundId,
          existingRoomTypes: _rooms,
          onRoomTypesChanged: (rooms) {
            setState(() {
              _rooms = rooms;
            });
          },
        ),
      ],
    );
  }
}