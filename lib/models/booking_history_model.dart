class BookingHistoryModel {
  final String libraryName;
  final String studentName;
  final String email;
  final String mobileNumber;
  final String seat;
  final String status;
  final String month;
  final int year;
  final String paymentDate;
  final String bookingDate;

  BookingHistoryModel({
    required this.libraryName,
    required this.studentName,
    required this.email,
    required this.mobileNumber,
    required this.seat,
    required this.status,
    required this.month,
    required this.year,
    required this.paymentDate,
    required this.bookingDate,
  });

  factory BookingHistoryModel.fromMap(Map<String, dynamic> map) {
    return BookingHistoryModel(
      libraryName: map['libraryName'] ?? '',
      studentName: map['studentName'] ?? '',
      email: map['email'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      seat: map['seat'] ?? '',
      status: map['status'] ?? '',
      month: map['month'] ?? 0,
      year: map['year'] ?? 0,
      paymentDate: map['paymentDate'] ?? '',
      bookingDate: map['bookingDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'libraryName': libraryName,
      'studentName': studentName,
      'email': email,
      'mobileNumber': mobileNumber,
      'seat': seat,
      'status': status,
      'month': month,
      'year': year,
      'paymentDate': paymentDate,
      'bookingDate': bookingDate,
    };
  }
}
