class Booking {
  final int id;
  final String attractionName;
  final String bookingTime;

  Booking({required this.id, required this.attractionName, required this.bookingTime});

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      attractionName: map['attractionName'],
      bookingTime: map['booking_time'],
    );
  }
}