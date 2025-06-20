class LibraryModel {
  final String name;
  final String imageUrl;
  final String address;
  final String contact;
  final String timing;
  final String description;

  LibraryModel({
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.contact,
    required this.timing,
    required this.description,
  });


  factory LibraryModel.fromJson(Map<String, dynamic> json) {
    return LibraryModel(
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      address: json['address'] ?? '',
      contact: json['contact'] ?? '',
      timing: json['timing'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'address': address,
      'contact': contact,
      'timing': timing,
      'description': description,
    };
  }
}
