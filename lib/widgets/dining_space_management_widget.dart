import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'common/image_picker_widget.dart';

class DiningSpaceManagementWidget extends StatefulWidget {
  final String restaurantType;
  final String compoundId;
  final List<Map<String, dynamic>> existingSpaces;
  final Function(List<Map<String, dynamic>>) onSpacesChanged;

  const DiningSpaceManagementWidget({
    Key? key,
    required this.restaurantType,
    required this.compoundId,
    required this.existingSpaces,
    required this.onSpacesChanged,
  }) : super(key: key);

  @override
  State<DiningSpaceManagementWidget> createState() => _DiningSpaceManagementWidgetState();
}

class _DiningSpaceManagementWidgetState extends State<DiningSpaceManagementWidget> {
  late List<Map<String, dynamic>> _spaces;
  int _spaceCounter = 1;

  final List<String> _spaceTypes = [
    'Main Dining Area',
    'Private Dining Room',
    'Outdoor Seating',
    'Bar Area',
    'VIP Section',
    'Lounge Area',
    'Terrace',
    'Garden Area',
  ];

  @override
  void initState() {
    super.initState();
    _spaces = List.from(widget.existingSpaces);
    if (_spaces.isNotEmpty) {
      _spaceCounter = _spaces.length + 1;
    }
  }

  void _addSpace() {
    setState(() {
      _spaces.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'spaceName': 'Dining Space $_spaceCounter',
        'spaceType': _spaceTypes[0],
        'capacity': '',
        'pricePerPerson': '',
        'description': '',
        'amenities': <String>[],
        'images': <String>[],
        'isAvailable': true,
        'restaurantType': widget.restaurantType,
        'compoundId': widget.compoundId,
      });
      _spaceCounter++;
    });
    widget.onSpacesChanged(_spaces);
  }

  void _removeSpace(int index) {
    setState(() {
      _spaces.removeAt(index);
    });
    widget.onSpacesChanged(_spaces);
  }

  void _updateSpace(int index, String field, dynamic value) {
    setState(() {
      _spaces[index][field] = value;
    });
    widget.onSpacesChanged(_spaces);
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
            const Text(
              'Dining Spaces',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _addSpace,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Space'),
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

        // Spaces list
        if (_spaces.isEmpty)
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
                    Icons.restaurant,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No dining spaces added yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Click "Add Space" to start adding dining areas',
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
            itemCount: _spaces.length,
            itemBuilder: (context, index) {
              return _buildSpaceCard(index);
            },
          ),
      ],
    );
  }

  Widget _buildSpaceCard(int index) {
    final space = _spaces[index];
    
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
            // Space header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: space['spaceName'],
                    decoration: const InputDecoration(
                      labelText: 'Space Name',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (value) => _updateSpace(index, 'spaceName', value),
                  ),
                ),
                const SizedBox(width: 16),
                Switch(
                  value: space['isAvailable'] ?? true,
                  onChanged: (value) => _updateSpace(index, 'isAvailable', value),
                  activeColor: const Color(0xFF4F6CAD),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeSpace(index),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Space type dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Space Type',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              value: space['spaceType'],
              items: _spaceTypes.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (value) => _updateSpace(index, 'spaceType', value),
            ),
            const SizedBox(height: 16),

            // Capacity and Price
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: space['capacity'],
                    decoration: const InputDecoration(
                      labelText: 'Seating Capacity',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      suffixText: 'people',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => _updateSpace(index, 'capacity', value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: space['pricePerPerson'],
                    decoration: const InputDecoration(
                      labelText: 'Price per Person',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      prefixText: 'R ',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => _updateSpace(index, 'pricePerPerson', value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              initialValue: space['description'],
              decoration: const InputDecoration(
                labelText: 'Space Description',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLines: 3,
              onChanged: (value) => _updateSpace(index, 'description', value),
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
    final space = _spaces[index];
    final List<String> amenities = List<String>.from(space['amenities'] ?? []);
    
    final List<String> availableAmenities = [
      'Private Entrance',
      'Sound System',
      'Projector/Screen',
      'Air Conditioning',
      'Heating',
      'WiFi',
      'Private Bar',
      'Dance Floor',
      'Stage Area',
      'Outdoor View',
      'Fireplace',
      'VIP Service',
      'Wheelchair Accessible',
      'Smoking Area',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Space Amenities',
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
                  _updateSpace(index, 'amenities', amenities);
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
    final space = _spaces[index];
    final List<String> images = List<String>.from(space['images'] ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Space Images',
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
            _updateSpace(index, 'images', selectedImages);
          },
        ),
      ],
    );
  }
}