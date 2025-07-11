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
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final List<TextEditingController> rulesControllers = [TextEditingController()];
  
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
  
  final List<String> statusOptions = [
    'Available Now',
    'Available from Date',
    'Pending',
    'Occupied',
  ];
  
  String selectedStatus = 'Available Now';
  DateTime? availableFromDate;
  final availableDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Initialize form with existing data if available
    if (widget.initialData != null) {
      final data = widget.initialData!;
      titleController.text = data['title'] ?? '';
      priceController.text = data['price'] ?? '';
      descriptionController.text = data['description'] ?? '';
      sizeController.text = data['size'] ?? '';
      
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
        for (var amenity in roomAmenities) {
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
    priceController.dispose();
    descriptionController.dispose();
    sizeController.dispose();
    availableDateController.dispose();
    for (var controller in rulesControllers) {
      controller.dispose();
    }
    super.dispose();
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
      List<String> selectedAmenitiesList = roomAmenities
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
        'price': priceController.text,
        'description': descriptionController.text,
        'size': sizeController.text,
        'status': selectedStatus,
        'amenities': selectedAmenitiesList,
        'rules': rules,
        'images': selectedImages,
        'propertyType': widget.propertyType,
        'compoundId': widget.compoundId,
        'venueType': 'room',
        'availableFromDate': availableFromDate?.toIso8601String(),
      };
      
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isEditing ? 'Edit ${widget.propertyType} Room' : 'Add ${widget.propertyType} Room',
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
            
            // Room title/name
            FormFields.buildTextField(
              label: 'Room Name/Number',
              controller: titleController,
              hint: 'e.g., Bachelor Room 1, Suite A',
            ),
            
            // Room size and price
            Row(
              children: [
                Expanded(
                  child: FormFields.buildTextField(
                    label: 'Size (sqm)',
                    controller: sizeController,
                    hint: 'Room size',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FormFields.buildTextField(
                    label: 'Price (R)',
                    controller: priceController,
                    hint: 'Monthly/Daily rate',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            
            // Description
            FormFields.buildTextField(
              label: 'Room Description',
              controller: descriptionController,
              hint: 'Describe the room features',
              maxLines: 3,
            ),
            
            // Status dropdown
            FormFields.buildDropdown<String>(
              label: 'Availability Status',
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
            
            // Rules
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Room Rules',
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
                              hintText: 'Enter room rule',
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
          ],
        ),
      ),
    );
  }
}