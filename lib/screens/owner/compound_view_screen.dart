import 'package:flutter/material.dart';
import '../../models/compound.dart';
import '../../models/booking.dart';
import '../../widgets/forms/compound_property_form.dart';
import '../../widgets/forms/room_form.dart';
import '../../widgets/forms/short_stay_room_form.dart';
import '../../widgets/booking/simple_booking_widget.dart';
import '../../widgets/booking/booking_confirmation_dialog.dart';

class CompoundViewScreen extends StatefulWidget {
  final Compound compound;
  final Function(Map<String, dynamic>) onAddProperty;

  const CompoundViewScreen({
    super.key,
    required this.compound,
    required this.onAddProperty,
  });

  @override
  State<CompoundViewScreen> createState() => _CompoundViewScreenState();
}

class _CompoundViewScreenState extends State<CompoundViewScreen> {
  List<Map<String, dynamic>> _properties = [];
  List<Booking> _bookings = [];

  @override
  void initState() {
    super.initState();
    // Load properties for this compound
    // In a real app, this would come from a database
  }

  void _showAddPropertyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Business Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.hotel, color: Color(0xFF4F6CAD)),
              title: const Text('Long Stay'),
              subtitle: const Text('Bachelor, Single, Apartment, House'),
              onTap: () {
                Navigator.pop(context);
                _showPropertyTypeDialog('long_stay');
              },
            ),
            ListTile(
              leading: const Icon(Icons.event, color: Color(0xFF4F6CAD)),
              title: const Text('Short Stay'),
              subtitle: const Text('Hotel rooms, Guest house'),
              onTap: () {
                Navigator.pop(context);
                _showPropertyTypeDialog('short_stay');
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant, color: Color(0xFF4F6CAD)),
              title: const Text('Dining'),
              subtitle: const Text('Restaurant, Cafe, Bar'),
              onTap: () {
                Navigator.pop(context);
                _showPropertyTypeDialog('dining');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPropertyTypeDialog(String businessType) {
    List<Map<String, dynamic>> propertyTypes = [];
    
    if (businessType == 'long_stay') {
      propertyTypes = [
        {'type': 'Bachelor', 'description': 'Monthly rental - Single room with private bathroom'},
        {'type': 'Single Room', 'description': 'Monthly rental - One bedroom with shared facilities'},
        {'type': 'Shared Room', 'description': 'Monthly rental - Shared accommodation space'},
        {'type': 'Apartment', 'description': 'Monthly rental - Multi-room apartment unit'},
        {'type': 'House', 'description': 'Monthly rental - Full house rental'},
      ];
    } else if (businessType == 'short_stay') {
      propertyTypes = [
        {'type': 'Bachelor', 'description': 'Budget accommodation - Back rooms for exploring on a budget'},
        {'type': 'Lodge', 'description': 'Game lodges, mountain lodges, bush accommodation'},
        {'type': 'Guest House', 'description': 'B&Bs, family-run accommodation, breakfast included'},
        {'type': 'Flat', 'description': 'Short-term apartment rentals in the city'},
        {'type': 'Holiday Home', 'description': 'Villas and houses for group/family holidays'},
      ];
    } else if (businessType == 'dining') {
      propertyTypes = [
        {'type': 'Restaurant', 'description': 'Full dining establishment'},
        {'type': 'Cafe', 'description': 'Coffee shop and light meals'},
        {'type': 'Bar', 'description': 'Beverage and entertainment venue'},
        {'type': 'Fast Food', 'description': 'Quick service restaurant'},
        {'type': 'Catering', 'description': 'Catering service business'},
      ];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select ${businessType.replaceAll('_', ' ').toUpperCase()} Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: propertyTypes.map((propertyType) => ListTile(
            title: Text(propertyType['type']),
            subtitle: Text(propertyType['description']),
            onTap: () {
              Navigator.pop(context);
              _showPropertyNameDialog(businessType, propertyType['type']);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showPropertyNameDialog(String businessType, String propertyType) {
    final TextEditingController nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter ${propertyType} Name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Give your ${propertyType.toLowerCase()} a unique name that guests will recognize.',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '${propertyType} Name',
                hintText: _getPropertyNameHint(propertyType),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                _createPropertyFrame(businessType, propertyType, nameController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F6CAD),
              foregroundColor: Colors.white,
            ),
            child: const Text('Create Property'),
          ),
        ],
      ),
    );
  }

  String _getPropertyNameHint(String propertyType) {
    switch (propertyType.toLowerCase()) {
      case 'bachelor':
        return 'e.g., City Bachelor Rooms, Student Lodge';
      case 'lodge':
        return 'e.g., Mountain View Lodge, Safari Lodge';
      case 'guest house':
        return 'e.g., Rose Guest House, Sunset B&B';
      case 'flat':
        return 'e.g., Downtown Flats, Ocean View Apartments';
      case 'holiday home':
        return 'e.g., Seaside Villa, Mountain Retreat';
      case 'single room':
        return 'e.g., University Singles, Downtown Rooms';
      case 'shared room':
        return 'e.g., Shared Living Space, Community Rooms';
      case 'apartment':
        return 'e.g., Rose Apartments, City Living';
      case 'house':
        return 'e.g., Family House, Executive Home';
      default:
        return 'e.g., Your Property Name';
    }
  }

  void _createPropertyFrame(String businessType, String propertyType, String propertyName) {
    final newProperty = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'compoundId': widget.compound.id,
      'businessType': businessType,
      'propertyType': propertyType,
      'propertyName': propertyName,
      'rooms': <Map<String, dynamic>>[], // Initialize empty rooms list
    };
    
    setState(() {
      _properties.add(newProperty);
    });
    
    widget.onAddProperty(newProperty);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$propertyName created! Click it to add rooms.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  IconData _getPropertyIcon(String businessType, String propertyType) {
    if (businessType == 'dining') {
      return Icons.restaurant;
    } else if (businessType == 'short_stay') {
      switch (propertyType.toLowerCase()) {
        case 'bachelor':
          return Icons.single_bed;
        case 'lodge':
          return Icons.nature_people;
        case 'guest house':
          return Icons.home_work;
        case 'flat':
          return Icons.apartment;
        case 'holiday home':
          return Icons.villa;
        default:
          return Icons.hotel;
      }
    } else {
      // long_stay
      switch (propertyType.toLowerCase()) {
        case 'bachelor':
          return Icons.single_bed;
        case 'single room':
          return Icons.bed;
        case 'shared room':
          return Icons.group;
        case 'apartment':
          return Icons.apartment;
        case 'house':
          return Icons.house;
        default:
          return Icons.home;
      }
    }
  }

  void _navigateToPropertyFrame(Map<String, dynamic> property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyFrameScreen(
          compound: widget.compound,
          property: property,
          onRoomAdded: (room) {
            setState(() {
              if (property['rooms'] == null) {
                property['rooms'] = [];
              }
              property['rooms'].add(room);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.compound.name),
        backgroundColor: const Color(0xFF4F6CAD),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compound Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.compound.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '📍 ${widget.compound.street}, ${widget.compound.city}, ${widget.compound.province}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.compound.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: widget.compound.amenities.map((amenity) => Chip(
                        label: Text(amenity),
                        backgroundColor: const Color(0xFF4F6CAD).withOpacity(0.1),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Properties Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '🏠 Properties',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddPropertyDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Property'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Properties List
            Expanded(
              child: _properties.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _properties.length,
                      itemBuilder: (context, index) {
                        return _buildPropertyCard(_properties[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    final rooms = property['rooms'] as List<dynamic>? ?? [];
    final propertyType = property['propertyType'] ?? 'Property';
    final businessType = property['businessType'] ?? '';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 8,
      shadowColor: const Color(0xFF4F6CAD).withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: const Color(0xFF4F6CAD).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToPropertyFrame(property),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF4F6CAD).withOpacity(0.05),
                Colors.white,
                const Color(0xFF4F6CAD).withOpacity(0.02),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4F6CAD),
                          const Color(0xFF6B7FBD),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4F6CAD).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getPropertyIcon(businessType, propertyType),
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property['propertyName'] ?? '${propertyType} Property',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F6CAD).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            businessType.replaceAll('_', ' ').toUpperCase(),
                            style: TextStyle(
                              color: const Color(0xFF4F6CAD),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: rooms.isEmpty 
                          ? [Colors.orange, Colors.orangeAccent] 
                          : [Colors.green, Colors.greenAccent],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: (rooms.isEmpty ? Colors.orange : Colors.green).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      '${rooms.length} Room${rooms.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey[50]!,
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF4F6CAD).withOpacity(0.1),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F6CAD).withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (rooms.isEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F6CAD).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.add_circle_outline,
                          size: 32,
                          color: const Color(0xFF4F6CAD),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Ready to Add Rooms',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF2D3142),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Click to add ${propertyType.toLowerCase()} rooms',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.room,
                          size: 28,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Property Active',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF2D3142),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Click to manage rooms',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Properties Yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first property to start managing rooms',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showAddPropertyDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F6CAD),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Property'),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyFrameScreen extends StatefulWidget {
  final Compound compound;
  final Map<String, dynamic> property;
  final Function(Map<String, dynamic>) onRoomAdded;

  const PropertyFrameScreen({
    super.key,
    required this.compound,
    required this.property,
    required this.onRoomAdded,
  });

  @override
  State<PropertyFrameScreen> createState() => _PropertyFrameScreenState();
}

class _PropertyFrameScreenState extends State<PropertyFrameScreen> {
  List<Map<String, dynamic>> _rooms = [];
  List<Booking> _bookings = [];

  @override
  void initState() {
    super.initState();
    _rooms = List<Map<String, dynamic>>.from(widget.property['rooms'] ?? []);
  }

  void _showAddRoomDialog() {
    final businessType = widget.property['businessType'];
    
    // Use different forms based on business type
    if (businessType == 'long_stay') {
      _showLongStayRoomForm();
    } else if (businessType == 'short_stay') {
      _showShortStayRoomForm();
    } else {
      // For dining or other types, use the original form
      _showLongStayRoomForm();
    }
  }
  
  void _showLongStayRoomForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Add ${widget.property['propertyType']} Room'),
            backgroundColor: const Color(0xFF4F6CAD),
            foregroundColor: Colors.white,
          ),
          body: RoomForm(
            propertyType: widget.property['propertyType'],
            compoundId: widget.compound.id,
            onSubmit: (roomData) {
              final newRoom = {
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'propertyName': widget.property['propertyName'],
                'roomName': roomData['title'],
                'price': roomData['price'],
                'quantity': roomData['quantity'],
                'available': roomData['available'],
                'amenities': roomData['amenities'],
                'images': roomData['images'],
                'systemType': 'long_stay',
              };
              
              setState(() {
                _rooms.add(newRoom);
              });
              
              widget.onRoomAdded(newRoom);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.property['propertyType']} room added successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  void _showShortStayRoomForm() {
    final propertyType = widget.property['propertyType'];
    final isHolidayHome = propertyType == 'Holiday Home';
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(isHolidayHome ? 'Add Holiday Home' : 'Add ${propertyType} Room'),
            backgroundColor: const Color(0xFF4F6CAD),
            foregroundColor: Colors.white,
          ),
          body: ShortStayRoomForm(
            propertyType: propertyType,
            compoundId: widget.compound.id,
            isHolidayHome: isHolidayHome,
            onSubmit: (roomData) {
              final newRoom = {
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'propertyName': widget.property['propertyName'],
                'roomName': isHolidayHome ? propertyType : roomData['roomType'],
                'price': roomData['nightlyPrice'],
                'maxGuests': roomData['maxGuests'],
                'description': roomData['description'],
                'quantity': roomData['quantity'],
                'available': roomData['available'],
                'amenities': roomData['amenities'],
                'images': roomData['images'],
                'systemType': 'short_stay',
                'isHolidayHome': isHolidayHome,
              };
              
              setState(() {
                _rooms.add(newRoom);
              });
              
              widget.onRoomAdded(newRoom);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isHolidayHome ? 'Holiday Home added successfully!' : '${propertyType} room added successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
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
        title: Text('${widget.property['propertyType']} - ${widget.compound.name}'),
        backgroundColor: const Color(0xFF4F6CAD),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.property['propertyName'] ?? '${widget.property['propertyType']} Property',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.property['propertyType']} • ${widget.property['businessType'].replaceAll('_', ' ').toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Rooms Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🏠 ${widget.property['propertyType']} Rooms',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddRoomDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Room'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Rooms List
            Expanded(
              child: _rooms.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _rooms.length,
                      itemBuilder: (context, index) {
                        return _buildRoomCard(_rooms[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    final amenities = room['amenities'] as List<dynamic>? ?? [];
    final systemType = room['systemType'] ?? 'long_stay';
    final price = room['price'] ?? '0';
    
    if (systemType == 'short_stay') {
      return _buildShortStayRoomCard(room, amenities, price);
    } else {
      return _buildLongStayRoomCard(room, amenities, price);
    }
  }
  
  Widget _buildLongStayRoomCard(Map<String, dynamic> room, List<dynamic> amenities, String price) {
    final quantity = room['quantity'] ?? 0;
    final available = room['available'] ?? 0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.room,
                  color: const Color(0xFF4F6CAD),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room['propertyName'] ?? room['roomName'] ?? 'Unnamed Property',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      Text(
                        'R$price per month',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: available > 0 ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$available/$quantity Available',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Quantity info
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Total: $quantity rooms, Available: $available',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            if (amenities.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: amenities.take(4).map((amenity) => Chip(
                  label: Text(
                    amenity.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                  backgroundColor: const Color(0xFF4F6CAD).withOpacity(0.1),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )).toList(),
              ),
              if (amenities.length > 4)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+${amenities.length - 4} more amenities',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildShortStayRoomCard(Map<String, dynamic> room, List<dynamic> amenities, String price) {
    final maxGuests = room['maxGuests'] ?? 2;
    final quantity = room['quantity'] ?? 0;
    final available = room['available'] ?? 0;
    final description = room['description'] ?? '';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.hotel,
                  color: const Color(0xFF4F6CAD),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room['propertyName'] ?? 'Unnamed Property',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      Text(
                        'R$price per night • Max $maxGuests guests',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: available > 0 ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$available/$quantity Available',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Quantity info
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Total: $quantity rooms, Available: $available',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            if (description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            if (amenities.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: amenities.take(4).map((amenity) => Chip(
                  label: Text(
                    amenity.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                  backgroundColor: const Color(0xFF4F6CAD).withOpacity(0.1),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )).toList(),
              ),
              if (amenities.length > 4)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+${amenities.length - 4} more amenities',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
            
            // Add booking button for short stay
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showBookingCalendar(room),
                icon: const Icon(Icons.calendar_today, size: 16),
                label: const Text('Book Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F6CAD),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingCalendar(Map<String, dynamic> room) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: SimpleBookingWidget(
          room: room,
          existingBookings: _bookings.where((booking) => booking.roomId == room['id']).toList(),
          onBookingConfirmed: (checkIn, checkOut, guests) {
            Navigator.of(context).pop();
            _showBookingConfirmation(room, checkIn, checkOut, guests);
          },
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showBookingConfirmation(Map<String, dynamic> room, DateTime checkIn, DateTime checkOut, int guests) {
    final nights = checkOut.difference(checkIn).inDays;
    final nightlyRate = double.tryParse(room['price']?.toString() ?? '0') ?? 0.0;
    final totalPrice = nights * nightlyRate;

    showDialog(
      context: context,
      builder: (context) => BookingConfirmationDialog(
        room: room,
        checkIn: checkIn,
        checkOut: checkOut,
        numberOfGuests: guests,
        totalPrice: totalPrice,
        onBookingConfirmed: (booking) {
          setState(() {
            _bookings.add(booking);
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Booking confirmed for ${booking.guestName}!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.room_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Rooms Yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first ${widget.property['propertyType'].toLowerCase()} room',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showAddRoomDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F6CAD),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Room'),
            ),
          ],
        ),
      ),
    );
  }
}