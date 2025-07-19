import 'package:flutter/material.dart';
import '../common/form_fields.dart';
import '../common/image_picker_widget.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class RoomForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final Map<String, dynamic>? initialData;
  final String propertyType;
  final String compoundId;

  const RoomForm({
    super.key,
    required this.onSubmit,
    required this.propertyType,
    required this.compoundId,
    this.initialData,
  });

  @override
  State<RoomForm> createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController availableController = TextEditingController();
  
  List<dynamic> selectedImages = [];
  final int maxImages = 8;
  
  // Room-specific amenities
  final List<Map<String, dynamic>> roomAmenities = [
    {'name': 'Private Bathroom', 'icon': Icons.bathtub, 'selected': false},
    {'name': 'Shared Bathroom', 'icon': Icons.bathtub_outlined, 'selected': false},
    {'name': 'Kitchenette', 'icon': Icons.kitchen, 'selected': false},
    {'name': 'Air Conditioning', 'icon': Icons.ac_unit, 'selected': false},
    {'name': 'Heating', 'icon': Icons.thermostat, 'selected': false},
    {'name': 'WiFi', 'icon': Icons.wifi, 'selected': false},
    {'name': 'Desk', 'icon': Icons.desk, 'selected': false},
    {'name': 'Wardrobe', 'icon': Icons.checkroom, 'selected': false},
    {'name': 'Balcony', 'icon': Icons.balcony, 'selected': false},
    {'name': 'TV', 'icon': Icons.tv, 'selected': false},
    {'name': 'Microwave', 'icon': Icons.microwave, 'selected': false},
    {'name': 'Mini Fridge', 'icon': Icons.kitchen, 'selected': false},
    {'name': 'Safe', 'icon': Icons.security, 'selected': false},
  ];
  

  @override
  void initState() {
    super.initState();
    
    // Initialize form with existing data if available
    if (widget.initialData != null) {
      final data = widget.initialData!;
      titleController.text = data['title'] ?? '';
      priceController.text = data['price'] ?? '';
      quantityController.text = data['quantity']?.toString() ?? '';
      availableController.text = data['available']?.toString() ?? '';
      
      if (data['images'] != null && data['images'] is List) {
        selectedImages = List<dynamic>.from(data['images']);
      }
      
      if (data['amenities'] != null && data['amenities'] is List) {
        final selectedAmenitiesList = data['amenities'] as List;
        for (var amenity in roomAmenities) {
          if (selectedAmenitiesList.contains(amenity['name'])) {
            amenity['selected'] = true;
          }
        }
      }
    } else {
      // Set default quantity and available
      quantityController.text = '1';
      availableController.text = '1';
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    quantityController.dispose();
    availableController.dispose();
    super.dispose();
  }


  void submitForm() {
    if (formKey.currentState!.validate()) {
      // Validate quantity and available
      final quantity = int.tryParse(quantityController.text) ?? 0;
      final available = int.tryParse(availableController.text) ?? 0;
      
      if (quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quantity must be greater than 0'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      if (available > quantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Available rooms cannot exceed total quantity'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Get selected amenities
      List<String> selectedAmenitiesList = roomAmenities
          .where((amenity) => amenity['selected'] as bool)
          .map((amenity) => amenity['name'] as String)
          .toList();
      
      final Map<String, dynamic> formData = {
        'title': titleController.text,
        'price': priceController.text,
        'quantity': quantity,
        'available': available,
        'amenities': selectedAmenitiesList,
        'images': selectedImages,
        'propertyType': widget.propertyType,
        'compoundId': widget.compoundId,
        'venueType': 'room',
      };
      
      widget.onSubmit(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;
    
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room title/name
            FormFields.buildTextField(
              label: 'Room Name',
              controller: titleController,
              hint: 'e.g., Standard Bachelor, Premium Single',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a room name';
                }
                return null;
              },
            ),
            
            // Price
            FormFields.buildTextField(
              label: 'Price (R)',
              controller: priceController,
              hint: 'e.g., 3000',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),
            
            // Quantity and Available
            Row(
              children: [
                Expanded(
                  child: FormFields.buildTextField(
                    label: 'Total Quantity',
                    controller: quantityController,
                    hint: 'e.g., 10',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final num = int.tryParse(value);
                      if (num == null || num <= 0) {
                        return 'Must be > 0';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FormFields.buildTextField(
                    label: 'Available',
                    controller: availableController,
                    hint: 'e.g., 8',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final available = int.tryParse(value);
                      final quantity = int.tryParse(quantityController.text);
                      if (available == null || available < 0) {
                        return 'Must be ≥ 0';
                      }
                      if (quantity != null && available > quantity) {
                        return 'Cannot exceed quantity';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            
            // Room amenities
            FormFields.buildCheckboxList(
              label: 'Room Amenities',
              items: roomAmenities,
              onChanged: (newItems) {
                setState(() {
                  for (int i = 0; i < roomAmenities.length; i++) {
                    roomAmenities[i]['selected'] = newItems[i]['selected'];
                  }
                });
              },
            ),
            
            
            // Image picker
            const SizedBox(height: 16),
            const Text(
              'Room Images',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
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
                  isEditing ? 'Update Room' : 'Add Room',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Add some bottom padding for better scrolling
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}