import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerMap extends StatefulWidget {
  final Function(LatLng) onLocationSelected;
  final LatLng? initialLocation;

  const LocationPickerMap({
    Key? key,
    required this.onLocationSelected,
    this.initialLocation,
  }) : super(key: key);

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  late GoogleMapController _mapController;
  LatLng _selectedLocation = const LatLng(0.3476, 32.5825); // Default to Kampala
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check if we have an initial location from the parent widget
      if (widget.initialLocation != null) {
        _selectedLocation = widget.initialLocation!;
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Otherwise, get the current location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled
        setState(() {
          _isLoading = false;
          _selectedLocation = const LatLng(0.3476, 32.5825); // Default fallback
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied
          setState(() {
            _isLoading = false;
            _selectedLocation = const LatLng(0.3476, 32.5825); // Default fallback
          });
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        // Permissions are permanently denied
        setState(() {
          _isLoading = false;
          _selectedLocation = const LatLng(0.3476, 32.5825); // Default fallback
        });
        return;
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      // If there's an error, use a default location
      setState(() {
        _isLoading = false;
        _selectedLocation = const LatLng(0.3476, 32.5825); // Default fallback
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _selectedLocation,
                  zoom: 14.0,
                ),
                onMapCreated: _onMapCreated,
                onTap: (LatLng location) {
                  setState(() {
                    _selectedLocation = location;
                    widget.onLocationSelected(location);
                  });
                },
                markers: {
                  Marker(
                    markerId: const MarkerId('selectedLocation'),
                    position: _selectedLocation,
                    draggable: true,
                    onDragEnd: (newPosition) {
                      setState(() {
                        _selectedLocation = newPosition;
                        widget.onLocationSelected(newPosition);
                      });
                    },
                  ),
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                mapToolbarEnabled: true,
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Coordinates: ${_selectedLocation.latitude.toStringAsFixed(6)}, ${_selectedLocation.longitude.toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
  }
}