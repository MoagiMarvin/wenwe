import 'package:flutter/material.dart';
import '../room_type_management_widget.dart';
import '../dining_space_management_widget.dart';
import '../common/form_fields.dart';

class CompoundPropertyForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final Map<String, dynamic>? initialData;
  final String compoundId;
  final String businessType; // 'accommodation' or 'dining'
  final String? propertyType; // Pre-selected property type

  const CompoundPropertyForm({
    super.key,
    required this.onSubmit,
    required this.compoundId,
    required this.businessType,
    this.initialData,
    this.propertyType,
  });

  @override
  State<CompoundPropertyForm> createState() => _CompoundPropertyFormState();
}

class _CompoundPropertyFormState extends State<CompoundPropertyForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController propertyNameController = TextEditingController();
  
  // For accommodation properties
  String _selectedType = 'Bachelor';
  String _selectedDuration = 'Long-term';
  List<Map<String, dynamic>> _roomTypes = [];
  
  // For dining properties
  String _selectedDiningType = 'Restaurant';
  List<Map<String, dynamic>> _diningSpaces = [];
  
  // Common property types
  final List<String> _longTermPropertyTypes = [
    'Bachelor',
    'Single Room',
    'Shared Room', 
    'Apartment',
    'House',
  ];
  
  final List<String> _shortTermPropertyTypes = [
    'Bachelor',
    'Single Room',
    'Shared Room',
    'House',
    'Villa',
    'Lodge',
    'Resort',
    'Hotel',
  ];
  
  final List<String> _diningTypes = [
    'Restaurant',
    'Cafe',
    'Bar',
    'Fast Food',
    'Catering',
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
    
    if (widget.businessType == 'accommodation' || widget.businessType == 'long_stay' || widget.businessType == 'short_stay') {
      // Map business type to duration
      if (widget.businessType == 'long_stay') {
        _selectedDuration = 'Long-term';
      } else if (widget.businessType == 'short_stay') {
        _selectedDuration = 'Short-term';
      }
      
      // Initialize property types based on selected duration
      _propertyTypes = _selectedDuration == 'Long-term' 
          ? _longTermPropertyTypes 
          : _shortTermPropertyTypes;
      
      // Set property type if provided
      if (widget.propertyType != null && _propertyTypes.contains(widget.propertyType)) {
        _selectedType = widget.propertyType!;
      }
      
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

        if (data['roomTypes'] != null && data['roomTypes'] is List) {
          _roomTypes = List<Map<String, dynamic>>.from(data['roomTypes']);
        }

        propertyNameController.text = data['propertyName'] ?? '';
      }
    } else {
      // For dining establishments
      if (widget.propertyType != null && _diningTypes.contains(widget.propertyType)) {
        _selectedDiningType = widget.propertyType!;
      }
      
      if (widget.initialData != null) {
        final data = widget.initialData!;
        
        if (data['type'] != null && _diningTypes.contains(data['type'])) {
          _selectedDiningType = data['type'];
        }

        if (data['diningSpaces'] != null && data['diningSpaces'] is List) {
          _diningSpaces = List<Map<String, dynamic>>.from(data['diningSpaces']);
        }
      }
    }
  }

  @override
  void dispose() {
    propertyNameController.dispose();
    super.dispose();
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

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      final Map<String, dynamic> formData = {
        'compoundId': widget.compoundId,
        'businessType': widget.businessType,
      };
      
      if (widget.businessType == 'accommodation' || widget.businessType == 'long_stay' || widget.businessType == 'short_stay') {
        formData['propertyName'] = propertyNameController.text;
        formData['type'] = _selectedType;
        formData['duration'] = _selectedDuration;
        formData['roomTypes'] = _roomTypes;
      } else {
        formData['propertyName'] = propertyNameController.text;
        formData['type'] = _selectedDiningType;
        formData['diningSpaces'] = _diningSpaces;
      }
      
      widget.onSubmit(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isEditing 
                          ? 'Edit ${widget.businessType == 'accommodation' ? 'Accommodation' : 'Dining'} Property'
                          : 'Add ${widget.businessType == 'accommodation' ? 'Accommodation' : 'Dining'} Property',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Property type selection
              if (widget.businessType == 'accommodation' || widget.businessType == 'long_stay' || widget.businessType == 'short_stay') ...[
                // Property name
                FormFields.buildTextField(
                  label: 'Property Name',
                  controller: propertyNameController,
                  hint: 'e.g., Student Bachelors, Premium Singles',
                ),
                
                const SizedBox(height: 16),
                
                // Duration dropdown
                FormFields.buildDropdown<String>(
                  label: 'Duration',
                  value: _selectedDuration,
                  items: _durationOptions,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      _updatePropertyTypes(newValue);
                    }
                  },
                  itemToString: (item) => item,
                ),
                
                const SizedBox(height: 16),
                
                // Property type dropdown
                FormFields.buildDropdown<String>(
                  label: 'Property Type',
                  value: _selectedType,
                  items: _propertyTypes,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    }
                  },
                  itemToString: (item) => item,
                ),
                
                const SizedBox(height: 24),
                
                // Room Type Management Section (with quantity)
                RoomTypeManagementWidget(
                  propertyType: _selectedType,
                  compoundId: widget.compoundId,
                  existingRoomTypes: _roomTypes,
                  onRoomTypesChanged: (roomTypes) {
                    setState(() {
                      _roomTypes = roomTypes;
                    });
                  },
                ),
              ] else ...[
                // Dining establishment type dropdown
                FormFields.buildDropdown<String>(
                  label: 'Dining Establishment Type',
                  value: _selectedDiningType,
                  items: _diningTypes,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedDiningType = newValue;
                      });
                    }
                  },
                  itemToString: (item) => item,
                ),
                
                const SizedBox(height: 24),
                
                // Dining Spaces Management Section
                DiningSpaceManagementWidget(
                  restaurantType: _selectedDiningType,
                  compoundId: widget.compoundId,
                  existingSpaces: _diningSpaces,
                  onSpacesChanged: (spaces) {
                    setState(() {
                      _diningSpaces = spaces;
                    });
                  },
                ),
              ],
              
              const SizedBox(height: 30),
              
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F6CAD),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Update Property' : 'Add Property',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}