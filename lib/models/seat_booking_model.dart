class SeatBookingModel {
  final String seatId;
  bool isBooked;
  bool isSelected;

  SeatBookingModel({
    required this.seatId,
    this.isBooked = false,
    this.isSelected = false,
  });

  // From JSON
  factory SeatBookingModel.fromJson(Map<String, dynamic> json) {
    return SeatBookingModel(
      seatId: json['seatId'],
      isBooked: json['isBooked'] ?? false,
      isSelected: json['isSelected'] ?? false,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'seatId': seatId,
      'isBooked': isBooked,
      'isSelected': isSelected,
    };
  }
}
