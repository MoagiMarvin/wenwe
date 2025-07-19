class Booking {
  final String id;
  final String roomId;
  final String propertyId;
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;
  final double totalPrice;
  final BookingStatus status;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  Booking({
    required this.id,
    required this.roomId,
    required this.propertyId,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.metadata = const {},
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      roomId: json['roomId'],
      propertyId: json['propertyId'],
      guestName: json['guestName'],
      guestEmail: json['guestEmail'],
      guestPhone: json['guestPhone'],
      checkInDate: DateTime.parse(json['checkInDate']),
      checkOutDate: DateTime.parse(json['checkOutDate']),
      numberOfGuests: json['numberOfGuests'],
      totalPrice: json['totalPrice'].toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == 'BookingStatus.${json['status']}',
      ),
      createdAt: DateTime.parse(json['createdAt']),
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'propertyId': propertyId,
      'guestName': guestName,
      'guestEmail': guestEmail,
      'guestPhone': guestPhone,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'numberOfGuests': numberOfGuests,
      'totalPrice': totalPrice,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  int get numberOfNights {
    return checkOutDate.difference(checkInDate).inDays;
  }

  bool isActiveBooking() {
    return status == BookingStatus.confirmed && 
           DateTime.now().isBefore(checkOutDate);
  }

  bool conflictsWith(DateTime startDate, DateTime endDate) {
    return !(endDate.isBefore(checkInDate) || startDate.isAfter(checkOutDate));
  }
}

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
  noShow,
}