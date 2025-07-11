import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../common/location_picker_dialog.dart';
import '../common/image_picker_widget.dart';
import '../common/form_fields.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

abstract class BaseVenueForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final Map<String, dynamic>? initialData;

  const BaseVenueForm({
    super.key,
    required this.onSubmit,
    this.initialData,
  });
}

abstract class BaseVenueFormState<T extends BaseVenueForm> extends State<T> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController coordinatesController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<TextEditingController> rulesControllers = [TextEditingController()];
  
  List<dynamic> selectedImages = [];
  final int maxImages = 5;
  
  // Default location (can be set to a specific city)
  final LatLng defaultLocation = const LatLng(-26.2041, 28.0473); // Johannesburg
  late LatLng selectedLocation;
  
  // Common amenities list
  final List<Map<String, dynamic>> amenities = [
    {'name': 'WiFi', 'icon': Icons.wifi, 'selected': false},
    {'name': 'Parking', 'icon': Icons.local_parking, 'selected': false},
    {'name': 'Security', 'icon': Icons.security, 'selected': false},
  ];
  
  final List<String> statusOptions = [
    'Available Now',
    'Available from Date',
    'Pending',
    'Rented',
  ];
  
  String selectedStatus = 'Available Now';
  DateTime? availableFromDate;
  final availableDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedLocation = defaultLocation;
    
    // Initialize form with existing data if available
    if (widget.initialData != null) {
      final data = widget.initialData!;
      titleController.text = data['title'] ?? '';
      locationController.text = data['location'] ?? '';
      priceController.text = data['price'] ?? '';
      descriptionController.text = data['description'] ?? '';
      
      if (data['coordinates'] != null) {
        coordinatesController.text = data['coordinates'];
        
        // Parse coordinates if available
        try {
          final parts = data['coordinates'].split(',');
          if (parts.length == 2) {
            final lat = double.parse(parts[0].trim());
            final lng = double.parse(parts[1].trim());
            selectedLocation = LatLng(lat, lng);
          }
        } catch (e) {
          debugPrint('Error parsing coordinates: $e');
        }
      }
      
      if (data['status'] != null) {
        selectedStatus = data['status'];
      }
      
      if (data['images'] != null && data['images'] is List) {
        selectedImages = List<dynamic>.from(data['images']);
      }
      
      if (data['rules'] != null && data['rules'] is List) {
        final rules = data['rules'] as List;
        rulesControllers.clear();
        for (var rule in rules) {
          rulesControllers.add(TextEditingController(text: rule.toString()));
        }
        if (rulesControllers.isEmpty) {
          rulesControllers.add(TextEditingController());
        }
      }
      
      if (data['amenities'] != null && data['amenities'] is List) {
        final selectedAmenitiesList = data['amenities'] as List;
        for (var amenity in amenities) {
          if (selectedAmenitiesList.contains(amenity['name'])) {
            amenity['selected'] = true;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    coordinatesController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    availableDateController.dispose();
    for (var controller in rulesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void showMapDialog() async {
    final LatLng initial = selectedLocation;
    final LatLng? picked = await showDialog<LatLng>(
      context: context,
      builder: (context) => LocationPickerDialog(initialLocation: initial),
    );
    if (picked != null) {
      setState(() {
        selectedLocation = picked;
        coordinatesController.text =
            '${picked.latitude.toStringAsFixed(6)}, ${picked.longitude.toStringAsFixed(6)}';
      });
    }
  }

  void addRuleField() {
    setState(() {
      rulesControllers.add(TextEditingController());
    });
  }

  void removeRuleField(int index) {
    setState(() {
      rulesControllers.removeAt(index);
    });
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      // Get selected amenities
      List<String> selectedAmenitiesList = amenities
          .where((amenity) => amenity['selected'] as bool)
          .map((amenity) => amenity['name'] as String)
          .toList();
      
      // Get rules
      List<String> rules = rulesControllers
          .map((controller) => controller.text)
          .where((rule) => rule.isNotEmpty)
          .toList();
      
      final Map<String, dynamic> formData = {
        'title': titleController.text,
        'location': locationController.text,
        'coordinates': coordinatesController.text,
        'price': priceController.text,
        'description': descriptionController.text,
        'status': selectedStatus,
        'amenities': selectedAmenitiesList,
        'rules': rules,
        'images': selectedImages,
      };
      
      // Add venue-specific data
      addVenueSpecificData(formData);
      
      widget.onSubmit(formData);
    }
  }
  
  // Method to be implemented by subclasses to add venue-specific data
  void addVenueSpecificData(Map<String, dynamic> formData);
  
  // Common form fields
  Widget buildCommonFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFields.buildTextField(
          label: 'Title',
          controller: titleController,
          hint: 'Enter venue title',
        ),
        
        FormFields.buildTextField(
          label: 'Location',
          controller: locationController,
          hint: 'Enter address',
        ),
        
        // Coordinates field with map picker
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Coordinates *',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: coordinatesController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Select on map',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Coordinates are required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: showMapDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F6CAD),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Pick on Map'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
        
        FormFields.buildTextField(
          label: 'Price',
          controller: priceController,
          hint: 'Enter price',
          keyboardType: TextInputType.number,
        ),
        
        FormFields.buildTextField(
          label: 'Description',
          controller: descriptionController,
          hint: 'Enter description',
          maxLines: 3,
        ),
        
        // Status dropdown
        FormFields.buildDropdown<String>(
          label: 'Status',
          value: selectedStatus,
          items: statusOptions,
          onChanged: (newValue) {
            setState(() {
              selectedStatus = newValue!;
            });
          },
          itemToString: (item) => item,
        ),
        
        // Available from date (if status is 'Available from Date')
        if (selectedStatus == 'Available from Date')
          FormFields.buildDatePicker(
            label: 'Available From',
            controller: availableDateController,
            context: context,
            onDateSelected: (date) {
              setState(() {
                availableFromDate = date;
              });
            },
            isRequired: true,
          ),
        
        // Amenities
        FormFields.buildCheckboxList(
          label: 'Amenities',
          items: amenities,
          onChanged: (newItems) {
            setState(() {
              for (int i = 0; i < amenities.length; i++) {
                amenities[i]['selected'] = newItems[i]['selected'];
              }
            });
          },
        ),
        
        // Rules
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rules',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextButton.icon(
                  onPressed: addRuleField,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Rule'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF4F6CAD),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(
              rulesControllers.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: rulesControllers[index],
                        decoration: InputDecoration(
                          hintText: 'Enter rule',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    if (rulesControllers.length > 1)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeRuleField(index),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        // Image picker
        const SizedBox(height: 16),
        ImagePickerWidget(
          selectedImages: selectedImages,
          maxImages: maxImages,
          onImagesSelected: (imgs) {
            setState(() {
              selectedImages = imgs.map((img) {
                if (img is String) return img;
                if (img is XFile) return img.path;
                if (img is File) return img.path;
                return img.toString();
              }).toList();
            });
          },
        ),
      ],
    );
  }
  
  // Abstract method to build venue-specific form fields
  Widget buildVenueSpecificFields();
  
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Edit Venue' : 'Add New Venue',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
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
            
            // Common form fields
            buildCommonFormFields(),
            
            // Venue-specific form fields
            buildVenueSpecificFields(),
            
            const SizedBox(height: 30),
            
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F6CAD),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isEditing ? 'Update Venue' : 'Add Venue',
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
    );
  }
}

Widget buildImage(String img) {
  if (img.startsWith('http')) {
    return Image.network(img);
  } else {
    return Image.file(File(img));
  }
}