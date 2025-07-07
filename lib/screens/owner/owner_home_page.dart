import 'package:flutter/material.dart';
import '../../widgets/forms/compound_form.dart';
import '../../models/compound.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({Key? key}) : super(key: key);

  @override
  State<OwnerHomePage> createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  // Mock list of compounds (for demo)
  List<Compound> _compounds = [
    Compound(
      id: '1',
      name: 'Green Acres',
      street: '123 Main St',
      city: 'Polokwane',
      province: 'Limpopo',
      postalCode: '0700',
      description: 'Modern apartments close to University of Limpopo.',
      amenities: ['WiFi', 'Parking', 'Security'],
      tags: ['student', 'university', 'affordable'],
      latitude: -23.9045,
      longitude: 29.4689,
      images: [
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
        'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
      ],
    ),
    Compound(
      id: '2',
      name: 'Sunset Villas',
      street: '456 Oak Ave',
      city: 'Cape Town',
      province: 'Western Cape',
      postalCode: '8001',
      description: 'Luxury villas with mountain views.',
      amenities: ['Pool', 'Gym', 'Parking'],
      tags: ['luxury', 'mountain', 'villa'],
      latitude: -33.9249,
      longitude: 18.4241,
      images: [
        'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
        'https://images.unsplash.com/photo-1465101178521-c1a9136a3b99',
      ],
    ),
  ];

  void _showAddCompoundDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Compound'),
        content: SizedBox(
          width: 400,
          child: CompoundForm(
            onSubmit: (compoundData) {
              setState(() {
                _compounds.add(
                  Compound(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: compoundData['name'],
                    street: compoundData['street'],
                    city: compoundData['city'],
                    province: compoundData['province'],
                    postalCode: compoundData['postalCode'],
                    description: compoundData['description'],
                    amenities: List<String>.from(compoundData['amenities']),
                    tags: List<String>.from(compoundData['tags']),
                    latitude: compoundData['latitude'],
                    longitude: compoundData['longitude'],
                    images: List<String>.from(compoundData['images']),
                  ),
                );
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  void _viewProperties(Compound compound) {
    // TODO: Navigate to CompoundDetailsPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompoundDetailsPage(compound: compound),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        automaticallyImplyLeading: false, // No back button
        title: const Text('Welcome, Owner!'),
        backgroundColor: const Color(0xFF4F6CAD),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              'You have ${_compounds.length} compound${_compounds.length == 1 ? '' : 's'}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3142),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _compounds.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No compounds found. Add your first compound to get started!',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _showAddCompoundDialog,
                          child: const Text('Add Compound'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _compounds.length,
                    itemBuilder: (context, index) {
                      final compound = _compounds[index];
                      return Card(
                        elevation: 6,
                        margin: const EdgeInsets.only(bottom: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (compound.images.isNotEmpty)
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                                child: Image.network(
                                  compound.images[0],
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    height: 180,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          compound.name,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2D3142),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => _viewProperties(compound),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF4F6CAD),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                        ),
                                        child: const Text('View Properties'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          '${compound.street}, ${compound.city}, ${compound.province}',
                                          style: const TextStyle(fontSize: 15, color: Colors.grey),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    compound.description,
                                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    children: compound.tags
                                        .map((tag) => Chip(
                                              label: Text(tag),
                                              backgroundColor: Colors.grey[200],
                                            ))
                                        .toList(),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    children: compound.amenities
                                        .map((amenity) => Chip(
                                              label: Text(amenity),
                                              backgroundColor: const Color(0xFFD1E3FF),
                                              labelStyle: const TextStyle(color: Color(0xFF4F6CAD)),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCompoundDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Compound'),
        backgroundColor: const Color(0xFF4F6CAD),
      ),
    );
  }
}

// Stub for CompoundDetailsPage
class CompoundDetailsPage extends StatelessWidget {
  final Compound compound;
  const CompoundDetailsPage({Key? key, required this.compound}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(compound.name),
        backgroundColor: const Color(0xFF4F6CAD),
        foregroundColor: Colors.white,
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Add property to this compound
            },
            icon: const Icon(Icons.add_business),
            label: const Text('Add Property'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4F6CAD),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('Properties for ${compound.name} will be listed here.'),
      ),
    );
  }
}

class LocationPickerDialog extends StatefulWidget {
  final LatLng initialLocation;
  const LocationPickerDialog({required this.initialLocation, Key? key}) : super(key: key);

  @override
  State<LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog> {
  late LatLng _pickedLocation;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pick Location'),
      content: SizedBox(
        width: 350,
        height: 400,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: _pickedLocation, zoom: 15),
          markers: {
            Marker(
              markerId: MarkerId('picked'),
              position: _pickedLocation,
              draggable: true,
              onDragEnd: (newPos) {
                setState(() {
                  _pickedLocation = newPos;
                });
              },
            ),
          },
          onTap: (latLng) {
            setState(() {
              _pickedLocation = latLng;
            });
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Cancel
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _pickedLocation), // Confirm
          child: Text('Select'),
        ),
      ],
    );
  }
}