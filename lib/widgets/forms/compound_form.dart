import 'package:flutter/material.dart';
// Import your image picker widget if available
import '../common/image_picker_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../common/location_picker_dialog.dart';

class CompoundForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;
  const CompoundForm({super.key, required this.onSubmit});

  @override
  State<CompoundForm> createState() => _CompoundFormState();
}

class _CompoundFormState extends State<CompoundForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _street = '';
  String _city = '';
  String _province = '';
  String _postalCode = '';
  String _description = '';
  final List<String> _amenities = [];
  final List<String> _tags = [];
  double? _latitude;
  double? _longitude;
  List<dynamic> _images = [];

  // Example options for dropdowns and chips
  final List<String> _provinceOptions = [
    'Eastern Cape',
    'Free State',
    'Gauteng',
    'KwaZulu-Natal',
    'Limpopo',
    'Mpumalanga',
    'Northern Cape',
    'North West',
    'Western Cape',
  ];
  final List<String> _amenityOptions = [
    'WiFi', 'Parking', 'Security', 'Pool', 'Laundry', 'Gym', 'Other'
  ];

  // Add a TextEditingController for tag input
  final TextEditingController _tagController = TextEditingController();

  // Add a TextEditingController for coordinates
  final TextEditingController _coordinatesController = TextEditingController();

  void _pickLocation() async {
    // TODO: Integrate with your map/location picker
    setState(() {
      _latitude = -26.2041;
      _longitude = 28.0473;
    });
  }

  void _pickImages(List<dynamic> images) {
    setState(() {
      _images = images;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _latitude != null &&
        _longitude != null &&
        _images.isNotEmpty &&
        _province.isNotEmpty &&
        _amenities.isNotEmpty) {
      if (_tags.length > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can add up to 5 search tags only.')),
        );
        return;
      }
      widget.onSubmit({
        'name': _name,
        'street': _street,
        'city': _city,
        'province': _province,
        'postalCode': _postalCode,
        'description': _description,
        'amenities': _amenities,
        'tags': _tags,
        'latitude': _latitude,
        'longitude': _longitude,
        'images': _images,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Compound Name'),
              validator: (value) => value == null || value.isEmpty ? 'Enter compound name' : null,
              onChanged: (value) => _name = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Street'),
              validator: (value) => value == null || value.isEmpty ? 'Enter street' : null,
              onChanged: (value) => _street = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'City'),
              validator: (value) => value == null || value.isEmpty ? 'Enter city' : null,
              onChanged: (value) => _city = value,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Province'),
              value: _province.isNotEmpty ? _province : null,
              items: _provinceOptions.map((province) => DropdownMenuItem(
                value: province,
                child: Text(province),
              )).toList(),
              onChanged: (value) => setState(() => _province = value ?? ''),
              validator: (value) => value == null || value.isEmpty ? 'Select province' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Postal Code'),
              validator: (value) => value == null || value.isEmpty ? 'Enter postal code' : null,
              onChanged: (value) => _postalCode = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (value) => value == null || value.isEmpty ? 'Enter description' : null,
              onChanged: (value) => _description = value,
            ),
            const SizedBox(height: 16),
            // Amenities chips
            Text('Amenities (select at least one):'),
            Wrap(
              spacing: 8,
              children: _amenityOptions.map((amenity) {
                final selected = _amenities.contains(amenity);
                return FilterChip(
                  label: Text(amenity),
                  selected: selected,
                  onSelected: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        _amenities.add(amenity);
                      } else {
                        _amenities.remove(amenity);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Tags input
            Text('Search Tags (up to 5, each max 30 chars):'),
            Wrap(
              spacing: 8,
              children: [
                ..._tags.map((tag) => Chip(
                  label: Text(tag),
                  onDeleted: () {
                    setState(() {
                      _tags.remove(tag);
                    });
                  },
                )),
                if (_tags.length < 5)
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _tagController,
                      maxLength: 30,
                      decoration: InputDecoration(
                        hintText: 'Add tag',
                        counterText: '',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      onSubmitted: (value) {
                        final tag = value.trim();
                        if (tag.isNotEmpty && tag.length <= 30 && !_tags.contains(tag)) {
                          setState(() {
                            _tags.add(tag);
                            _tagController.clear();
                          });
                        }
                      },
                    ),
                  ),
              ],
            ),
            if (_tags.length > 5)
              Text('Maximum 5 tags allowed.', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            // Coordinates input
            Text('Coordinates (latitude, longitude):'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _coordinatesController,
                    decoration: const InputDecoration(hintText: 'e.g. -26.2041, 28.0473'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter coordinates or pick on map';
                      }
                      final parts = value.split(',');
                      if (parts.length != 2) return 'Enter valid coordinates';
                      final lat = double.tryParse(parts[0].trim());
                      final lng = double.tryParse(parts[1].trim());
                      if (lat == null || lng == null) return 'Enter valid numbers';
                      return null;
                    },
                    onChanged: (value) {
                      final parts = value.split(',');
                      if (parts.length == 2) {
                        final lat = double.tryParse(parts[0].trim());
                        final lng = double.tryParse(parts[1].trim());
                        if (lat != null && lng != null) {
                          setState(() {
                            _latitude = lat;
                            _longitude = lng;
                          });
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    LatLng initial;
                    // Try to get current location
                    try {
                      final pos = await Geolocator.getCurrentPosition();
                      initial = LatLng(pos.latitude, pos.longitude);
                    } catch (_) {
                      initial = LatLng(-26.2041, 28.0473); // Default
                    }
                    final LatLng? picked = await showDialog<LatLng>(
                      context: context,
                      builder: (context) => LocationPickerDialog(
                        initialLocation: (_latitude != null && _longitude != null)
                            ? LatLng(_latitude!, _longitude!)
                            : initial,
                      ),
                    );
                    if (picked != null) {
                      setState(() {
                        _latitude = picked.latitude;
                        _longitude = picked.longitude;
                        _coordinatesController.text =
                            '${picked.latitude.toStringAsFixed(6)}, ${picked.longitude.toStringAsFixed(6)}';
                      });
                    }
                  },
                  child: const Text('Pick on Map'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Images picker
            Text('Compound Images (required):'),
            ImagePickerWidget(
              selectedImages: _images,
              maxImages: 5,
              onImagesSelected: (imgs) {
                setState(() {
                  _images = imgs;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Create Compound'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
