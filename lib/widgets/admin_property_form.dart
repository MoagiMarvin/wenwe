import 'dart:io';
import 'package:bnb/widgets/location_picker_map.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdminPropertyForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const AdminPropertyForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AdminPropertyForm> createState() => _AdminPropertyFormState();
}

class _AdminPropertyFormState extends State<AdminPropertyForm> {
  final _formKey = GlobalKey<FormState>();
  
  // Existing controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  
  // Add coordinates controller
  final TextEditingController _coordinatesController = TextEditingController();
  
  // Add variables for both web and mobile
  File? _imageFile;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();
  
  String _selectedType = 'Apartment';
  String _selectedStatus = 'Available';
  
  final List<String> _propertyTypes = [
    'Apartment',
    'House',
    'Single',
    'Sharing',
    'Bachelor',
  ];
  
  final List<String> _statusOptions = [
    'Available',
    'Pending',
    'Rented',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // Add method to pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          // Handle web platform
          pickedFile.readAsBytes().then((value) {
            setState(() {
              _webImage = value;
              _imageFile = null;
              _imageUrlController.clear();
            });
          });
        } else {
          // Handle mobile platform
          _imageFile = File(pickedFile.path);
          _webImage = null;
          _imageUrlController.clear();
        }
      });
    }
  }

  // Add method to take a photo with camera
  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    
    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          // Handle web platform
          pickedFile.readAsBytes().then((value) {
            setState(() {
              _webImage = value;
              _imageFile = null;
              _imageUrlController.clear();
            });
          });
        } else {
          // Handle mobile platform
          _imageFile = File(pickedFile.path);
          _webImage = null;
          _imageUrlController.clear();
        }
      });
    }
  }

  // Add method to show map dialog
  // Add a variable to store the selected location
  LatLng _selectedLocation = const LatLng(0, 0);
  
  void _showMapDialog() {
    // Parse existing coordinates if available
    LatLng? initialLocation;
    if (_coordinatesController.text.isNotEmpty) {
      try {
        List<String> parts = _coordinatesController.text.split(',');
        if (parts.length == 2) {
          double lat = double.parse(parts[0].trim());
          double lng = double.parse(parts[1].trim());
          initialLocation = LatLng(lat, lng);
        }
      } catch (e) {
        // If parsing fails, initialLocation remains null
      }
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> formData = {
        'title': _titleController.text,
        'location': _locationController.text,
        'coordinates': _coordinatesController.text,  // Add coordinates to form data
        'price': _priceController.text,
        'description': _descriptionController.text,
        'type': _selectedType,
        'status': _selectedStatus,
      };

      // Handle image data based on platform and what's available
      if (_webImage != null) {
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add New Property',
                  style: TextStyle(
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
            Expanded(
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
                      hint: r'e.g. $1200/month',  // Using raw string with 'r' prefix
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Property type dropdown
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
                          hint: const Text('Select property type'),
                          items: _propertyTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedType = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Status dropdown
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
                          hint: const Text('Select status'),
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
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Replace the image URL field with image selection options
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Property Image',
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
                                  backgroundColor: Colors.grey[200],
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
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
                                  backgroundColor: Colors.grey[200],
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'OR',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _imageUrlController,
                          label: 'Image URL (Optional)',
                          hint: 'Enter image URL or leave blank for default',
                          validator: null,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Image preview - show either file or URL
                    if (_webImage != null || _imageFile != null || _imageUrlController.text.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Image Preview',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _buildImagePreview(),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            
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
                child: const Text(
                  'Add Property',
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed,
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
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon),
                    onPressed: onSuffixIconPressed,
                  )
                : null,
          ),
          validator: validator,
        ),
      ],
    );
  }

  // Replace the image preview section with this:
  Widget _buildImagePreview() {
    if (_webImage != null) {
      return Image.memory(
        _webImage!,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (_imageFile != null) {
      return Image.file(
        _imageFile!,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (_imageUrlController.text.isNotEmpty) {
      return Image.network(
        _imageUrlController.text,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 150,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Center(
              child: Text('Invalid image URL'),
            ),
          );
        },
      );
    }
    return Container();
  }
}