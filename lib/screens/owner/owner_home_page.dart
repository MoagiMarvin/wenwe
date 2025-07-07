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
  // Use a list of Compound objects
  List<Compound> _compounds = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Compounds'),
        backgroundColor: const Color(0xFF4F6CAD),
        foregroundColor: Colors.white,
      ),
      body: _compounds.isEmpty
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
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: compound.images.isNotEmpty
                        ? Image.network(
                            compound.images[0],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.home, size: 40, color: Color(0xFF4F6CAD)),
                    title: Text(compound.name),
                    subtitle: Text(
                      '${compound.street}, ${compound.city}, ${compound.province}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_business, color: Color(0xFF4F6CAD)),
                      onPressed: () {
                        // TODO: Navigate to add/manage properties for this compound
                      },
                    ),
                    onTap: () {
                      // TODO: Navigate to compound details/properties management
                    },
                  ),
                );
              },
            ),
      floatingActionButton: _compounds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _showAddCompoundDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Compound'),
              backgroundColor: const Color(0xFF4F6CAD),
            )
          : null,
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