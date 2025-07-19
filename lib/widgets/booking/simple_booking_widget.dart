import 'package:flutter/material.dart';
import '../../models/booking.dart';

class SimpleBookingWidget extends StatefulWidget {
  final Map<String, dynamic> room;
  final List<Booking> existingBookings;
  final Function(DateTime checkIn, DateTime checkOut, int guests) onBookingConfirmed;
  final VoidCallback onCancel;

  const SimpleBookingWidget({
    super.key,
    required this.room,
    required this.existingBookings,
    required this.onBookingConfirmed,
    required this.onCancel,
  });

  @override
  State<SimpleBookingWidget> createState() => _SimpleBookingWidgetState();
}

class _SimpleBookingWidgetState extends State<SimpleBookingWidget> {
  DateTime? _selectedCheckIn;
  DateTime? _selectedCheckOut;
  int _numberOfGuests = 1;
  
  final TextEditingController _guestsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _numberOfGuests = 1;
    _guestsController.text = '1';
  }

  @override
  void dispose() {
    _guestsController.dispose();
    super.dispose();
  }

  Future<void> _selectCheckInDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _selectedCheckIn = picked;
        _selectedCheckOut = null; // Reset checkout when checkin changes
      });
    }
  }

  Future<void> _selectCheckOutDate() async {
    if (_selectedCheckIn == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select check-in date first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedCheckIn!.add(const Duration(days: 1)),
      firstDate: _selectedCheckIn!.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _selectedCheckOut = picked;
      });
    }
  }

  double _calculateTotalPrice() {
    if (_selectedCheckIn == null || _selectedCheckOut == null) {
      return 0.0;
    }
    
    final nights = _selectedCheckOut!.difference(_selectedCheckIn!).inDays;
    final nightlyRate = double.tryParse(widget.room['price']?.toString() ?? '0') ?? 0.0;
    
    return nights * nightlyRate;
  }

  void _confirmBooking() {
    if (_selectedCheckIn == null || _selectedCheckOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select check-in and check-out dates'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_numberOfGuests <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid number of guests'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final maxGuests = widget.room['maxGuests'] ?? 2;
    if (_numberOfGuests > maxGuests) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum $maxGuests guests allowed'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onBookingConfirmed(_selectedCheckIn!, _selectedCheckOut!, _numberOfGuests);
  }

  @override
  Widget build(BuildContext context) {
    final nights = _selectedCheckIn != null && _selectedCheckOut != null
        ? _selectedCheckOut!.difference(_selectedCheckIn!).inDays
        : 0;
    final totalPrice = _calculateTotalPrice();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Book ${widget.room['propertyName'] ?? 'Property'}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              IconButton(
                onPressed: widget.onCancel,
                icon: const Icon(Icons.close),
                color: Colors.grey,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Check-in date picker
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today, color: Color(0xFF4F6CAD)),
              title: const Text('Check-in Date'),
              subtitle: Text(
                _selectedCheckIn != null
                    ? '${_selectedCheckIn!.day}/${_selectedCheckIn!.month}/${_selectedCheckIn!.year}'
                    : 'Select check-in date',
                style: TextStyle(
                  color: _selectedCheckIn != null ? Colors.black : Colors.grey,
                ),
              ),
              onTap: _selectCheckInDate,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Check-out date picker
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today, color: Color(0xFF4F6CAD)),
              title: const Text('Check-out Date'),
              subtitle: Text(
                _selectedCheckOut != null
                    ? '${_selectedCheckOut!.day}/${_selectedCheckOut!.month}/${_selectedCheckOut!.year}'
                    : 'Select check-out date',
                style: TextStyle(
                  color: _selectedCheckOut != null ? Colors.black : Colors.grey,
                ),
              ),
              onTap: _selectCheckOutDate,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Booking summary
          if (_selectedCheckIn != null && _selectedCheckOut != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4F6CAD).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$nights night${nights != 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'R${totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4F6CAD),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Guests selector
            Row(
              children: [
                const Text(
                  'Guests:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: _guestsController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _numberOfGuests = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Max: ${widget.room['maxGuests'] ?? 2}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Booking button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F6CAD),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Book Now - R${totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Select your dates',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'R${widget.room['price'] ?? '0'} per night',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F6CAD),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}