import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerMap extends StatefulWidget {
  final LatLng initialLocation;
  final Function(LatLng) onLocationSelected;

  const LocationPickerMap({
    Key? key,
    required this.initialLocation,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  late LatLng _selectedLocation;
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.initialLocation,
        zoom: 14,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: _selectedLocation,
          draggable: true,
          onDragEnd: (newPosition) {
            setState(() {
              _selectedLocation = newPosition;
              widget.onLocationSelected(newPosition);
            });
          },
        ),
      },
      onTap: (location) {
        setState(() {
          _selectedLocation = location;
          widget.onLocationSelected(location);
        });
      },
      onMapCreated: (controller) {
        _mapController = controller;
      },
    );
  }
}

class AdminPropertyForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final Map<String, dynamic>? initialProperty; // Add this line

  const AdminPropertyForm({
    Key? key,
    required this.onSubmit,
    this.initialProperty, // Add this line
  }) : super(key: key);

  @override
  State<AdminPropertyForm> createState() => _AdminPropertyFormState();
}

class _AdminPropertyFormState extends State<AdminPropertyForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _coordinatesController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final List<TextEditingController> _rulesControllers = [TextEditingController()];
  
  String _selectedType = 'Apartment';
  // Change this line
  String _selectedStatus = 'Available Now';  // Changed from 'Available' to 'Available Now'
  String _selectedDuration = 'Long-term'; // Add this line
  
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  Uint8List? _webImage;
  
  // Multiple images support
  List<dynamic> _selectedImages = [];
  final int _maxImages = 5;
  
  // Default location (can be set to a specific city)
  final LatLng _defaultLocation = const LatLng(-26.2041, 28.0473); // Johannesburg
  late LatLng _selectedLocation;
  
  // Amenities list
  final List<Map<String, dynamic>> _amenities = [
    {'name': 'WiFi', 'icon': Icons.wifi, 'selected': false},
    {'name': 'Parking', 'icon': Icons.local_parking, 'selected': false},
    {'name': 'Kitchen', 'icon': Icons.kitchen, 'selected': false},
    {'name': 'TV', 'icon': Icons.tv, 'selected': false},
    {'name': 'AC', 'icon': Icons.ac_unit, 'selected': false},
    {'name': 'Washing Machine', 'icon': Icons.local_laundry_service, 'selected': false},
    {'name': 'Security', 'icon': Icons.security, 'selected': false},
    {'name': 'Pool', 'icon': Icons.pool, 'selected': false},
    {'name': 'Gym', 'icon': Icons.fitness_center, 'selected': false},
  ];
  
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
  
  // This will hold the current property types based on selected duration
  List<String> _propertyTypes = [];
  
  final List<String> _statusOptions = [
    'Available Now',
    'Available from Date',
    'Pending',
    'Rented',
  ];
  
  // Add this new list
  final List<String> _durationOptions = [
    'Long-term',
    'Short-term',
    'Both',
  ];
  
  // Add this
  DateTime? _availableFromDate;
  final _availableDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedLocation = _defaultLocation;
    
    // Initialize property types based on selected duration
    _propertyTypes = _selectedDuration == 'Long-term' 
        ? _longTermPropertyTypes 
        : _shortTermPropertyTypes;
    
    // Initialize form with existing property data if available
    if (widget.initialProperty != null) {
      final property = widget.initialProperty!;
      _titleController.text = property['title'] ?? '';
      _locationController.text = property['location'] ?? '';
      _priceController.text = property['price'] ?? '';
      _descriptionController.text = property['description'] ?? '';
      
      if (property['coordinates'] != null) {
        _coordinatesController.text = property['coordinates'];
        
        // Parse coordinates if available
        try {
          final parts = property['coordinates'].split(',');
          if (parts.length == 2) {
            final lat = double.parse(parts[0].trim());
            final lng = double.parse(parts[1].trim());
            _selectedLocation = LatLng(lat, lng);
          }
        } catch (e) {
          // Use default location if parsing fails
        }
      }
      
      if (property['type'] != null && _propertyTypes.contains(property['type'])) {
        _selectedType = property['type'];
      }
      
      if (property['status'] != null && _statusOptions.contains(property['status'])) {
        _selectedStatus = property['status'];
      }
      
      // Add this block to handle available from date
      if (property['availableFromDate'] != null) {
        _availableDateController.text = property['availableFromDate'];
        try {
          final parts = property['availableFromDate'].split('/');
          if (parts.length == 3) {
            final day = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            _availableFromDate = DateTime(year, month, day);
          }
        } catch (e) {
          // Use default date if parsing fails
        }
      }
      
      // Handle amenities if available
      if (property['amenities'] != null && property['amenities'] is List) {
        final amenities = property['amenities'] as List;
        for (var amenity in _amenities) {
          if (amenities.contains(amenity['name'])) {
            amenity['selected'] = true;
          }
        }
      }
      
      // Handle rules if available
      if (property['rules'] != null && property['rules'] is List) {
        final rules = property['rules'] as List;
        _rulesControllers.clear();
        
        if (rules.isEmpty) {
          _rulesControllers.add(TextEditingController());
        } else {
          for (var rule in rules) {
            _rulesControllers.add(TextEditingController(text: rule.toString()));
          }
        }
      }
      
      // Handle image URL if available
      if (property['imageUrl'] != null) {
        _imageUrlController.text = property['imageUrl'];
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    for (var controller in _rulesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Add this method here
  Future<void> _selectAvailableDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _availableFromDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _availableFromDate) {
      setState(() {
        _availableFromDate = picked;
        // Format date with leading zeros for day and month
        _availableDateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= _maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum $_maxImages images allowed')),
      );
      return;
    }
  
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      if (kIsWeb) {
        // Handle web platform
        pickedFile.readAsBytes().then((value) {
          setState(() {
            _selectedImages.add({'type': 'web', 'data': value});
          });
        });
      } else {
        // Handle mobile platform
        setState(() {
          _selectedImages.add({'type': 'file', 'data': File(pickedFile.path)});
        });
      }
    }
  }

  Future<void> _takePhoto() async {
    if (_selectedImages.length >= _maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum $_maxImages images allowed')),
      );
      return;
    }
  
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    
    if (pickedFile != null) {
      if (kIsWeb) {
        // Handle web platform
        pickedFile.readAsBytes().then((value) {
          setState(() {
            _selectedImages.add({'type': 'web', 'data': value});
          });
        });
      } else {
        // Handle mobile platform
        setState(() {
          _selectedImages.add({'type': 'file', 'data': File(pickedFile.path)});
        });
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? suffixIcon,
    Function()? onSuffixIconPressed,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(15),
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon, color: const Color(0xFF4F6CAD)),
                    onPressed: onSuffixIconPressed,
                  )
                : null,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildImagePreviews() {
    if (_selectedImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Image Previews',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _selectedImages.length,
            itemBuilder: (context, index) {
              final image = _selectedImages[index];
              Widget imageWidget;
              
              if (image['type'] == 'web') {
                imageWidget = Image.memory(
                  image['data'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                );
              } else {
                imageWidget = Image.file(
                  image['data'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                );
              }
              
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageWidget,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_selectedImages.length}/$_maxImages images selected',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showMapDialog() {
    showDialog(
      context: context,
      builder: (context) {
        LatLng initialLocation = _selectedLocation;
        
        return AlertDialog(
          title: const Text('Select Location'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LocationPickerMap(
                      initialLocation: initialLocation,
                      onLocationSelected: (LatLng location) {
                        _selectedLocation = location;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Tap on the map to select a location or drag the marker',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _coordinatesController.text = 
                      '${_selectedLocation.latitude.toStringAsFixed(6)}, ${_selectedLocation.longitude.toStringAsFixed(6)}';
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F6CAD),
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _updatePropertyTypes(String duration) {
    setState(() {
      _selectedDuration = duration;
      // Update property types based on selected duration
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
      
      // If current selected type is not in the new list, reset it
      if (!_propertyTypes.contains(_selectedType)) {
        _selectedType = _propertyTypes[0];
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Get selected amenities
      List<String> selectedAmenities = _amenities
          .where((amenity) => amenity['selected'] as bool)
          .map((amenity) => amenity['name'] as String)
          .toList();
      
      // Get rules
      List<String> rules = _rulesControllers
          .map((controller) => controller.text)
          .where((rule) => rule.isNotEmpty)
          .toList();
      
      final Map<String, dynamic> formData = {
        'title': _titleController.text,
        'location': _locationController.text,
        'coordinates': _coordinatesController.text,
        'price': _priceController.text,
        'description': _descriptionController.text,
        'type': _selectedType,
        'status': _selectedStatus,
        'duration': _selectedDuration, // Add this line
        // Add this conditional
        'availableFromDate': _selectedStatus == 'Available from Date' ? _availableDateController.text : null,
        'amenities': selectedAmenities,
        'rules': rules,
      };

      // Handle image data
      if (_selectedImages.isNotEmpty) {
        // For simplicity in this example, we'll just use the first image for the imageUrl
        // In a real app, you'd handle multiple images differently
        formData['imageUrl'] = 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2';
      } else if (_webImage != null) {
        formData['imageBytes'] = _webImage;
      } else if (_imageFile != null) {
        formData['imageFile'] = _imageFile;
      } else if (_imageUrlController.text.isNotEmpty) {
        formData['imageUrl'] = _imageUrlController.text;
      } else {
        formData['imageUrl'] = 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2';
      }

      widget.onSubmit(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialProperty != null;
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form header - update title based on whether we're editing or adding
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Edit Property' : 'Add New Property',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Form fields
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _titleController,
                      label: 'Property Title',
                      hint: 'e.g. Modern Studio Apartment',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 15),
                    
                    _buildTextField(
                      controller: _locationController,
                      label: 'Location',
                      hint: 'e.g. Downtown',
                      suffixIcon: Icons.location_on,
                      onSuffixIconPressed: _showMapDialog,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a location';
                        }
                        return null;
                      },
                    ),
                    
                    // Display coordinates if available
                    if (_coordinatesController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          'Coordinates: ${_coordinatesController.text}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 15),
                    
                    _buildTextField(
                      controller: _priceController,
                      label: 'Price',
                      hint: r'e.g. R1200/month',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Add Duration Dropdown here
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
                              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4F6CAD)),
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
                    
                    // Conditional fields based on duration
                    if (_selectedDuration == 'Long-term' || _selectedDuration == 'Both')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Long-term Options',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Add long-term specific fields here
                          // For example: lease duration, security deposit, etc.
                        ],
                      ),
                    
                    if (_selectedDuration == 'Short-term' || _selectedDuration == 'Both')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Short-term Options',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Add short-term specific fields here
                          // For example: minimum stay, cleaning fee, etc.
                        ],
                      ),
                    
                    const SizedBox(height: 15),
                    
                    // Property type dropdown - now uses the dynamic _propertyTypes list
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
                              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4F6CAD)),
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
                    
                    const SizedBox(height: 15),
                    
                    // Property status dropdown
                    const Text(
                      'Status',
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
                          value: _selectedStatus,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4F6CAD)),
                          items: _statusOptions.map((String status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedStatus = newValue;
                                // Clear date if not "Available from Date"
                                if (newValue != 'Available from Date') {
                                  _availableDateController.clear();
                                  _availableFromDate = null;
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    
                    // Show date picker if "Available from Date" is selected
                    if (_selectedStatus == 'Available from Date')
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _availableDateController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'Select availability date',
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.all(15),
                                ),
                                validator: (value) {
                                  if (_selectedStatus == 'Available from Date' && 
                                      (value == null || value.isEmpty)) {
                                    return 'Please select a date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.calendar_today, color: Color(0xFF4F6CAD)),
                              onPressed: _selectAvailableDate,
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 15),
                    
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Describe your property...',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Amenities section
                    const Text(
                      'Amenities',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _amenities.map((amenity) {
                        return FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                amenity['icon'] as IconData,
                                size: 16,
                                color: amenity['selected'] as bool
                                    ? Colors.white
                                    : const Color(0xFF4F6CAD),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                amenity['name'] as String,
                                style: TextStyle(
                                  color: amenity['selected'] as bool
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          selected: amenity['selected'] as bool,
                          selectedColor: const Color(0xFF4F6CAD),
                          backgroundColor: Colors.grey[100],
                          checkmarkColor: Colors.white,
                          onSelected: (bool selected) {
                            setState(() {
                              amenity['selected'] = selected;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Rules section
                    const Text(
                      'House Rules',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        for (int i = 0; i < _rulesControllers.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _rulesControllers[i],
                                    decoration: InputDecoration(
                                      hintText: 'e.g. No smoking',
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.all(15),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (i == _rulesControllers.length - 1)
                                  IconButton(
                                    icon: const Icon(Icons.add_circle, color: Color(0xFF4F6CAD)),
                                    onPressed: () {
                                      setState(() {
                                        _rulesControllers.add(TextEditingController());
                                      });
                                    },
                                  )
                                else
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _rulesControllers.removeAt(i);
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Image upload section
                    const Text(
                      'Property Images',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Gallery'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4F6CAD),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _takePhoto,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Camera'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4F6CAD),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Image URL input
                    _buildTextField(
                      controller: _imageUrlController,
                      label: 'Image URL (optional)',
                      hint: 'e.g. https://example.com/image.jpg',
                      validator: null,
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Image previews
                    _buildImagePreviews(),
                    
                    const SizedBox(height: 20),
                    
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
          ],
        ),
      ),
    );
  }
}
