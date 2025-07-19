import 'package:flutter/material.dart';
import '../common/form_fields.dart';
import '../common/image_picker_widget.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ShortStayRoomForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final Map<String, dynamic>? initialData;
  final String propertyType;
  final String compoundId;
  final bool isHolidayHome;

  const ShortStayRoomForm({
    super.key,
    required this.onSubmit,
    required this.propertyType,
    required this.compoundId,
    this.initialData,
    this.isHolidayHome = false,
  });

  @override
  State<ShortStayRoomForm> createState() => _ShortStayRoomFormState();
}

class _ShortStayRoomFormState extends State<ShortStayRoomForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nightlyPriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController maxGuestsController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController availableController = TextEditingController();
  
  List<dynamic> selectedImages = [];
  final int maxImages = 8;
  
  // Room type options specific to each property type
  String? selectedRoomType;
  
  List<String> getRoomTypesForProperty(String propertyType) {
    switch (propertyType.toLowerCase()) {
      case 'bachelor':
        return [
          'Standard Bachelor',
          'En-suite Bachelor',
          'Bachelor with Kitchenette',
        ];
      case 'lodge':
        return [
          'Standard Lodge Room',
          'Luxury Lodge Room',
          'Family Lodge Room',
          'Bush Suite',
          'Honeymoon Suite',
        ];
      case 'guest house':
        return [
          'Standard Room',
          'En-suite Room',
          'Family Room',
          'Deluxe Room',
          'Garden Room',
        ];
      case 'flat':
        return [
          'Studio Flat',
          '1-Bedroom Flat',
          '2-Bedroom Flat',
          'Penthouse Flat',
          'Serviced Flat',
        ];
      default:
        return [
          'Standard Room',
          'Deluxe Room',
          'Family Room',
        ];
    }
  }
  
  // Room-specific amenities for short stay
  final List<Map<String, dynamic>> roomAmenities = [
    {'name': 'Private Bathroom', 'icon': Icons.bathtub, 'selected': false},
    {'name': 'Shared Bathroom', 'icon': Icons.bathtub_outlined, 'selected': false},
    {'name': 'Air Conditioning', 'icon': Icons.ac_unit, 'selected': false},
    {'name': 'Heating', 'icon': Icons.thermostat, 'selected': false},
    {'name': 'WiFi', 'icon': Icons.wifi, 'selected': false},
    {'name': 'TV', 'icon': Icons.tv, 'selected': false},
    {'name': 'Mini Fridge', 'icon': Icons.kitchen, 'selected': false},
    {'name': 'Coffee Maker', 'icon': Icons.coffee, 'selected': false},
    {'name': 'Hair Dryer', 'icon': Icons.dry, 'selected': false},
    {'name': 'Safe', 'icon': Icons.security, 'selected': false},
    {'name': 'Balcony', 'icon': Icons.balcony, 'selected': false},
    {'name': 'Sea View', 'icon': Icons.waves, 'selected': false},
    {'name': 'Pool Access', 'icon': Icons.pool, 'selected': false},
    {'name': 'Gym Access', 'icon': Icons.fitness_center, 'selected': false},
    {'name': 'Breakfast Included', 'icon': Icons.free_breakfast, 'selected': false},
    {'name': 'Room Service', 'icon': Icons.room_service, 'selected': false},
    {'name': 'Parking', 'icon': Icons.local_parking, 'selected': false},
    {'name': 'Pet Friendly', 'icon': Icons.pets, 'selected': false},
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize form with existing data if available
    if (widget.initialData != null) {
      final data = widget.initialData!;
      if (!widget.isHolidayHome) {
        final roomTypes = getRoomTypesForProperty(widget.propertyType);
        selectedRoomType = data['roomType'] ?? roomTypes.first;
      }
      nightlyPriceController.text = data['nightlyPrice'] ?? '';
      descriptionController.text = data['description'] ?? '';
      maxGuestsController.text = data['maxGuests']?.toString() ?? '';
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
      // Set default values
      if (!widget.isHolidayHome) {
        final roomTypes = getRoomTypesForProperty(widget.propertyType);
        selectedRoomType = roomTypes.first;
      }
      maxGuestsController.text = widget.isHolidayHome ? '8' : '2';
      quantityController.text = '1';
      availableController.text = '1';
    }
  }

  @override
  void dispose() {
    nightlyPriceController.dispose();
    descriptionController.dispose();
    maxGuestsController.dispose();
    quantityController.dispose();
    availableController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      final maxGuests = int.tryParse(maxGuestsController.text) ?? 2;
      final quantity = int.tryParse(quantityController.text) ?? 0;
      final available = int.tryParse(availableController.text) ?? 0;
      
      if (maxGuests <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Maximum guests must be greater than 0'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
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
        'roomType': widget.isHolidayHome ? widget.propertyType : selectedRoomType,
        'nightlyPrice': nightlyPriceController.text,
        'description': descriptionController.text,
        'maxGuests': maxGuests,
        'quantity': quantity,
        'available': available,
        'amenities': selectedAmenitiesList,
        'images': selectedImages,
        'propertyType': widget.propertyType,
        'compoundId': widget.compoundId,
        'venueType': widget.isHolidayHome ? 'holiday_home' : 'short_stay_room',
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
            // Room type dropdown (only for non-holiday homes)
            if (!widget.isHolidayHome) ...[
              const SizedBox(height: 16),
              const Text(
                'Room Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedRoomType,
                decoration: InputDecoration(
                  hintText: 'Select room type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: getRoomTypesForProperty(widget.propertyType).map((String roomType) {
                  return DropdownMenuItem<String>(
                    value: roomType,
                    child: Text(roomType),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRoomType = newValue;
                  });
                },
                validator: (value) {
                  if (!widget.isHolidayHome && (value == null || value.isEmpty)) {
                    return 'Please select a room type';
                  }
                  return null;
                },
              ),
            ],
            
            // Nightly price and max guests
            Row(
              children: [
                Expanded(
                  child: FormFields.buildTextField(
                    label: widget.isHolidayHome ? 'Property Price per Night (R)' : 'Nightly Price (R)',
                    controller: nightlyPriceController,
                    hint: widget.isHolidayHome ? 'e.g., 2000' : 'e.g., 500',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter nightly price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FormFields.buildTextField(
                    label: widget.isHolidayHome ? 'Total Capacity' : 'Max Guests',
                    controller: maxGuestsController,
                    hint: widget.isHolidayHome ? 'e.g., 8' : 'e.g., 2',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final guests = int.tryParse(value);
                      if (guests == null || guests <= 0) {
                        return 'Must be > 0';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            
            // Quantity and Available
            Row(
              children: [
                Expanded(
                  child: FormFields.buildTextField(
                    label: widget.isHolidayHome ? 'Total Properties' : 'Total Quantity',
                    controller: quantityController,
                    hint: widget.isHolidayHome ? 'e.g., 3' : 'e.g., 10',
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
                    hint: widget.isHolidayHome ? 'e.g., 2' : 'e.g., 8',
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
            
            // Description
            FormFields.buildTextField(
              label: widget.isHolidayHome ? 'Property Description' : 'Room Type Description',
              controller: descriptionController,
              hint: widget.isHolidayHome ? 'Describe this holiday home and its features for guests' : 'Describe this room type and its features for guests',
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.isHolidayHome ? 'Please enter a property description' : 'Please enter a room type description';
                }
                return null;
              },
            ),
            
            // Room amenities
            FormFields.buildCheckboxList(
              label: widget.isHolidayHome ? 'Property Amenities' : 'Room Amenities',
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
            Text(
              widget.isHolidayHome ? 'Property Images' : 'Room Type Images',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.isHolidayHome ? 'Add high-quality images of this holiday home to attract more bookings' : 'Add high-quality images of this room type to attract more bookings',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
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
                  widget.isHolidayHome 
                    ? (isEditing ? 'Update Holiday Home' : 'Add Holiday Home')
                    : (isEditing ? 'Update Room Type' : 'Add Room Type'),
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