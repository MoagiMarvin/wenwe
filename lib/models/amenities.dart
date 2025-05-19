import 'package:flutter/material.dart';

/// A class that defines all possible amenities for properties
class Amenities {
  // Basic amenities
  static const List<Map<String, dynamic>> basicAmenities = [
    {'id': 'wifi', 'name': 'WiFi', 'icon': Icons.wifi},
    {'id': 'tv', 'name': 'TV', 'icon': Icons.tv},
    {'id': 'kitchen', 'name': 'Kitchen', 'icon': Icons.kitchen},
    {'id': 'washer', 'name': 'Washer', 'icon': Icons.local_laundry_service},
    {'id': 'parking', 'name': 'Free Parking', 'icon': Icons.local_parking},
    {'id': 'aircon', 'name': 'Air Conditioning', 'icon': Icons.ac_unit},
    {'id': 'heating', 'name': 'Heating', 'icon': Icons.whatshot},
    {'id': 'workspace', 'name': 'Workspace', 'icon': Icons.laptop},
  ];

  // Bedroom and laundry
  static const List<Map<String, dynamic>> bedroomAmenities = [
    {'id': 'bed_linen', 'name': 'Bed Linen', 'icon': Icons.bed},
    {'id': 'hangers', 'name': 'Hangers', 'icon': Icons.checkroom},
    {'id': 'iron', 'name': 'Iron', 'icon': Icons.iron},
    {'id': 'dryer', 'name': 'Dryer', 'icon': Icons.dry},
    {'id': 'extra_pillows', 'name': 'Extra Pillows', 'icon': Icons.airline_seat_individual_suite},
  ];

  // Bathroom amenities
  static const List<Map<String, dynamic>> bathroomAmenities = [
    {'id': 'hot_water', 'name': 'Hot Water', 'icon': Icons.hot_tub},
    {'id': 'shower', 'name': 'Shower', 'icon': Icons.shower},
    {'id': 'bathtub', 'name': 'Bathtub', 'icon': Icons.bathtub},
    {'id': 'hair_dryer', 'name': 'Hair Dryer', 'icon': Icons.dry_cleaning},
    {'id': 'toiletries', 'name': 'Toiletries', 'icon': Icons.sanitizer},
    {'id': 'towels', 'name': 'Towels', 'icon': Icons.dry},
  ];

  // Entertainment amenities
  static const List<Map<String, dynamic>> entertainmentAmenities = [
    {'id': 'pool', 'name': 'Swimming Pool', 'icon': Icons.pool},
    {'id': 'gym', 'name': 'Gym', 'icon': Icons.fitness_center},
    {'id': 'bbq', 'name': 'BBQ Grill', 'icon': Icons.outdoor_grill},
    {'id': 'game_console', 'name': 'Game Console', 'icon': Icons.sports_esports},
    {'id': 'books', 'name': 'Books', 'icon': Icons.menu_book},
    {'id': 'streaming', 'name': 'Streaming Services', 'icon': Icons.movie},
    {'id': 'sound_system', 'name': 'Sound System', 'icon': Icons.speaker},
  ];

  // Outdoor amenities
  static const List<Map<String, dynamic>> outdoorAmenities = [
    {'id': 'balcony', 'name': 'Balcony', 'icon': Icons.balcony},
    {'id': 'garden', 'name': 'Garden', 'icon': Icons.grass},
    {'id': 'patio', 'name': 'Patio', 'icon': Icons.deck},
    {'id': 'beach_access', 'name': 'Beach Access', 'icon': Icons.beach_access},
    {'id': 'lake_access', 'name': 'Lake Access', 'icon': Icons.water},
    {'id': 'outdoor_furniture', 'name': 'Outdoor Furniture', 'icon': Icons.chair},
    {'id': 'outdoor_dining', 'name': 'Outdoor Dining', 'icon': Icons.outdoor_grill},
  ];

  // Safety amenities
  static const List<Map<String, dynamic>> safetyAmenities = [
    {'id': 'smoke_alarm', 'name': 'Smoke Alarm', 'icon': Icons.smoke_free},
    {'id': 'carbon_monoxide_alarm', 'name': 'Carbon Monoxide Alarm', 'icon': Icons.co2},
    {'id': 'fire_extinguisher', 'name': 'Fire Extinguisher', 'icon': Icons.fire_extinguisher},
    {'id': 'first_aid_kit', 'name': 'First Aid Kit', 'icon': Icons.medical_services},
    {'id': 'security_cameras', 'name': 'Security Cameras', 'icon': Icons.videocam},
    {'id': 'safe', 'name': 'Safe', 'icon': Icons.lock},
  ];

  // Accessibility amenities
  static const List<Map<String, dynamic>> accessibilityAmenities = [
    {'id': 'step_free_access', 'name': 'Step-free Access', 'icon': Icons.accessible},
    {'id': 'wide_doorway', 'name': 'Wide Doorway', 'icon': Icons.door_sliding},
    {'id': 'wide_hallway', 'name': 'Wide Hallway', 'icon': Icons.door_front},
    {'id': 'accessible_bathroom', 'name': 'Accessible Bathroom', 'icon': Icons.accessible_forward},
    {'id': 'elevator', 'name': 'Elevator', 'icon': Icons.elevator},
  ];

  // Services
  static const List<Map<String, dynamic>> serviceAmenities = [
    {'id': 'breakfast', 'name': 'Breakfast', 'icon': Icons.free_breakfast},
    {'id': 'cleaning', 'name': 'Cleaning Service', 'icon': Icons.cleaning_services},
    {'id': 'self_check_in', 'name': 'Self Check-in', 'icon': Icons.vpn_key},
    {'id': 'long_term_stays', 'name': 'Long Term Stays', 'icon': Icons.calendar_month},
    {'id': 'luggage_dropoff', 'name': 'Luggage Dropoff', 'icon': Icons.luggage},
  ];

  // Get all amenities as a single list
  static List<Map<String, dynamic>> getAllAmenities() {
    return [
      ...basicAmenities,
      ...bedroomAmenities,
      ...bathroomAmenities,
      ...entertainmentAmenities,
      ...outdoorAmenities,
      ...safetyAmenities,
      ...accessibilityAmenities,
      ...serviceAmenities,
    ];
  }

  // Get amenity by ID
  static Map<String, dynamic>? getAmenityById(String id) {
    return getAllAmenities().firstWhere(
      (amenity) => amenity['id'] == id,
      orElse: () => {},
    );
  }

  // Get amenities by category
  static List<Map<String, dynamic>> getAmenitiesByCategory(String category) {
    switch (category) {
      case 'basic':
        return basicAmenities;
      case 'bedroom':
        return bedroomAmenities;
      case 'bathroom':
        return bathroomAmenities;
      case 'entertainment':
        return entertainmentAmenities;
      case 'outdoor':
        return outdoorAmenities;
      case 'safety':
        return safetyAmenities;
      case 'accessibility':
        return accessibilityAmenities;
      case 'service':
        return serviceAmenities;
      default:
        return [];
    }
  }

  // Get all categories
  static List<String> getAllCategories() {
    return [
      'basic',
      'bedroom',
      'bathroom',
      'entertainment',
      'outdoor',
      'safety',
      'accessibility',
      'service',
    ];
  }

  // Get category names (display friendly)
  static Map<String, String> getCategoryNames() {
    return {
      'basic': 'Basic Amenities',
      'bedroom': 'Bedroom & Laundry',
      'bathroom': 'Bathroom',
      'entertainment': 'Entertainment',
      'outdoor': 'Outdoor',
      'safety': 'Safety & Security',
      'accessibility': 'Accessibility',
      'service': 'Services',
    };
  }
}

// Extension to help with amenity selection in forms
extension AmenitySelectionHelper on List<Map<String, dynamic>> {
  // Convert amenities to a list of IDs for storage
  List<String> toIdList() {
    return map((amenity) => amenity['id'] as String).toList();
  }
  
  // Check if an amenity is in the list
  bool containsAmenity(String id) {
    return any((amenity) => amenity['id'] == id);
  }
}