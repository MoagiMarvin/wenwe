import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'common/image_picker_widget.dart';

class RoomTypeManagementWidget extends StatefulWidget {
  final String propertyType;
  final String compoundId;
  final List<Map<String, dynamic>> existingRoomTypes;
  final Function(List<Map<String, dynamic>>) onRoomTypesChanged;

  const RoomTypeManagementWidget({
    Key? key,
    required this.propertyType,
    required this.compoundId,
    required this.existingRoomTypes,
    required this.onRoomTypesChanged,
  }) : super(key: key);

  @override
  State<RoomTypeManagementWidget> createState() => _RoomTypeManagementWidgetState();
}

class _RoomTypeManagementWidgetState extends State<RoomTypeManagementWidget> {
  late List<Map<String, dynamic>> _roomTypes;

  @override
  void initState() {
    super.initState();
    _roomTypes = List.from(widget.existingRoomTypes);
  }

  void _addRoomType() {
    setState(() {
      _roomTypes.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': 'Standard ${widget.propertyType}',
        'quantity': 1,
        'price': '',
        'description': '',
        'size': '',
        'amenities': <String>[],
        'images': <String>[],
        'propertyType': widget.propertyType,
        'compoundId': widget.compoundId,
        'availableCount': 1, // How many are currently available
      });
    });
    widget.onRoomTypesChanged(_roomTypes);
  }

  void _removeRoomType(int index) {
    setState(() {
      _roomTypes.removeAt(index);
    });
    widget.onRoomTypesChanged(_roomTypes);
  }

  void _updateRoomType(int index, String field, dynamic value) {
    setState(() {
      _roomTypes[index][field] = value;
      
      // When quantity changes, update available count if it's higher
      if (field == 'quantity') {
        int quantity = int.tryParse(value.toString()) ?? 1;
        int currentAvailable = _roomTypes[index]['availableCount'] ?? 1;
        if (currentAvailable > quantity) {
          _roomTypes[index]['availableCount'] = quantity;
        }
      }
    });
    widget.onRoomTypesChanged(_roomTypes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.propertyType} Room Types',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _addRoomType,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Room Type'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F6CAD),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Room types list
        if (_roomTypes.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.hotel,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No ${widget.propertyType} room types added yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Click "Add Room Type" to start adding room configurations',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _roomTypes.length,
            itemBuilder: (context, index) {
              return _buildRoomTypeCard(index);
            },
          ),
      ],
    );
  }

  Widget _buildRoomTypeCard(int index) {
    final roomType = _roomTypes[index];
    final quantity = int.tryParse(roomType['quantity'].toString()) ?? 1;
    final availableCount = roomType['availableCount'] ?? quantity;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room type header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: roomType['name'],
                    decoration: const InputDecoration(
                      labelText: 'Room Type Name',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      hintText: 'e.g., Standard Bachelor, Premium Single',
                    ),
                    onChanged: (value) => _updateRoomType(index, 'name', value),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeRoomType(index),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quantity and Availability Management
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: roomType['quantity'].toString(),
                    decoration: const InputDecoration(
                      labelText: 'Total Quantity',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      suffixText: 'rooms',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => _updateRoomType(index, 'quantity', value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: availableCount.toString(),
                    decoration: InputDecoration(
                      labelText: 'Available Now',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      suffixText: '/$quantity',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      int newAvailable = int.tryParse(value) ?? 0;
                      if (newAvailable <= quantity) {
                        _updateRoomType(index, 'availableCount', newAvailable);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Price and Size
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: roomType['price'],
                    decoration: const InputDecoration(
                      labelText: 'Price per Room (R)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      prefixText: 'R ',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => _updateRoomType(index, 'price', value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: roomType['size'],
                    decoration: const InputDecoration(
                      labelText: 'Size (sqm)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      suffixText: 'sqm',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _updateRoomType(index, 'size', value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              initialValue: roomType['description'],
              decoration: const InputDecoration(
                labelText: 'Room Type Description',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hintText: 'Describe this room type...',
              ),
              maxLines: 3,
              onChanged: (value) => _updateRoomType(index, 'description', value),
            ),
            const SizedBox(height: 16),

            // Availability Status
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: availableCount > 0 ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: availableCount > 0 ? Colors.green[200]! : Colors.red[200]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    availableCount > 0 ? Icons.check_circle : Icons.cancel,
                    color: availableCount > 0 ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    availableCount > 0 
                        ? '$availableCount of $quantity rooms available'
                        : 'No rooms available (All occupied)',
                    style: TextStyle(
                      color: availableCount > 0 ? Colors.green[700] : Colors.red[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Amenities
            _buildAmenitiesSection(index),
            const SizedBox(height: 16),

            // Images
            _buildImageSection(index),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesSection(int index) {
    final roomType = _roomTypes[index];
    final List<String> amenities = List<String>.from(roomType['amenities'] ?? []);
    
    final List<String> availableAmenities = [
      'Private Bathroom',
      'Shared Bathroom',
      'Kitchenette',
      'Air Conditioning',
      'Heating',
      'WiFi',
      'Desk',
      'Wardrobe',
      'Balcony',
      'TV',
      'Microwave',
      'Mini Fridge',
      'Safe',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Room Amenities',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: availableAmenities.map((amenity) {
            final isSelected = amenities.contains(amenity);
            return FilterChip(
              label: Text(amenity),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    amenities.add(amenity);
                  } else {
                    amenities.remove(amenity);
                  }
                  _updateRoomType(index, 'amenities', amenities);
                });
              },
              selectedColor: const Color(0xFF4F6CAD).withOpacity(0.2),
              checkmarkColor: const Color(0xFF4F6CAD),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImageSection(int index) {
    final roomType = _roomTypes[index];
    final List<String> images = List<String>.from(roomType['images'] ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Room Type Images',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 8),
        ImagePickerWidget(
          selectedImages: images,
          maxImages: 8,
          onImagesSelected: (selectedImages) {
            _updateRoomType(index, 'images', selectedImages);
          },
        ),
      ],
    );
  }
}