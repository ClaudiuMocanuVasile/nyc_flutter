import 'package:flutter/material.dart';
import 'package:new_york_city/database/database_helper.dart';
import 'package:new_york_city/models/booking.dart';
import 'package:new_york_city/widgets/edit_modal.dart';

class PageBookings extends StatefulWidget {
  const PageBookings({super.key});

  @override
  State<PageBookings> createState() => _PageBookingsState();
}

class _PageBookingsState extends State<PageBookings> {
  List<Booking> bookings = [];

  void _fetchBookings() async {
    final db = await DatabaseHelper.instance.database;
    final bookingData = await db.rawQuery(
        'SELECT bookings.id, attractions.name AS attractionName, bookings.booking_time FROM bookings JOIN attractions ON bookings.attraction_id = attractions.id');
    setState(() {
      bookings = bookingData.map((b) => Booking.fromMap(b)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bookings")),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return BookingCard(
              booking: bookings[index], onUpdate: _fetchBookings);
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class BookingCard extends StatelessWidget {
  final Booking booking;
  late VoidCallback onUpdate;

  BookingCard({super.key, required this.booking, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(booking.attractionName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Booking Time: ${booking.bookingTime}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Placeholder action for editing
                    String? updatedTime =
                        await showEditModal(context, booking.bookingTime);
                    if (updatedTime != null && updatedTime.isNotEmpty) {
                      await DatabaseHelper.instance
                          .updateBookingTime(booking.id, updatedTime);
                      onUpdate();
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("Edit"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Placeholder action for deleting
                    
                    await DatabaseHelper.instance.deleteBooking(booking.id);
                    onUpdate;
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
