import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/booking.dart';

class CalendarBookingWidget extends StatefulWidget {
  final Map<String, dynamic> room;
  final List<Booking> existingBookings;
  final Function(DateTime checkIn, DateTime checkOut, int guests) onBookingConfirmed;
  final VoidCallback onCancel;

  const CalendarBookingWidget({
    super.key,
    required this.room,
    required this.existingBookings,
    required this.onBookingConfirmed,
    required this.onCancel,
  });

  @override
  State<CalendarBookingWidget> createState() => _CalendarBookingWidgetState();
}

class _CalendarBookingWidgetState extends State<CalendarBookingWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
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

  bool _isDateBlocked(DateTime date) {
    // Check if date is in the past
    if (date.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return true;
    }
    
    // Check if date conflicts with existing bookings
    for (var booking in widget.existingBookings) {
      if (booking.status == BookingStatus.confirmed || booking.status == BookingStatus.pending) {
        if (date.isAfter(booking.checkInDate.subtract(const Duration(days: 1))) &&
            date.isBefore(booking.checkOutDate)) {
          return true;
        }
      }
    }
    
    return false;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (_isDateBlocked(selectedDay)) {
      return;
    }

    setState(() {
      _focusedDay = focusedDay;
      
      if (_selectedCheckIn == null) {
        // First selection - check in date
        _selectedCheckIn = selectedDay;
        _selectedCheckOut = null;
      } else if (_selectedCheckOut == null && selectedDay.isAfter(_selectedCheckIn!)) {
        // Second selection - check out date
        _selectedCheckOut = selectedDay;
      } else {
        // Reset selection
        _selectedCheckIn = selectedDay;
        _selectedCheckOut = null;
      }
    });
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
          
          // Calendar
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            
            // Styling
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: const TextStyle(color: Colors.red),
              holidayTextStyle: const TextStyle(color: Colors.red),
              
              // Selected dates
              selectedDecoration: BoxDecoration(
                color: const Color(0xFF4F6CAD),
                shape: BoxShape.circle,
              ),
              
              // Range dates
              rangeStartDecoration: BoxDecoration(
                color: const Color(0xFF4F6CAD),
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: BoxDecoration(
                color: const Color(0xFF4F6CAD),
                shape: BoxShape.circle,
              ),
              withinRangeDecoration: BoxDecoration(
                color: const Color(0xFF4F6CAD).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              
              // Blocked dates
              disabledDecoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            
            // Selection logic
            selectedDayPredicate: (day) {
              if (_selectedCheckIn != null && _selectedCheckOut != null) {
                return day.isAfter(_selectedCheckIn!.subtract(const Duration(days: 1))) &&
                       day.isBefore(_selectedCheckOut!.add(const Duration(days: 1)));
              }
              return isSameDay(_selectedCheckIn, day);
            },
            
            enabledDayPredicate: (day) => !_isDateBlocked(day),
            
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          
          const SizedBox(height: 20),
          
          // Selection info
          if (_selectedCheckIn != null) ...[
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Check-in',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${_selectedCheckIn!.day}/${_selectedCheckIn!.month}/${_selectedCheckIn!.year}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (_selectedCheckOut != null) ...[
                        const Icon(Icons.arrow_forward, color: Colors.grey),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Check-out',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '${_selectedCheckOut!.day}/${_selectedCheckOut!.month}/${_selectedCheckOut!.year}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  
                  if (_selectedCheckOut != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$nights night${nights != 1 ? 's' : ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'R${totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F6CAD),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                onPressed: _selectedCheckOut != null ? _confirmBooking : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F6CAD),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _selectedCheckOut != null 
                    ? 'Book Now - R${totalPrice.toStringAsFixed(0)}'
                    : 'Select check-out date',
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
                    'Select your check-in date',
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