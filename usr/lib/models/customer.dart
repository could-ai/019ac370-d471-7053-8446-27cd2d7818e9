class Customer {
  final String id;
  final String name;
  final String phone;
  final String? address;
  final DateTime? reminderDate;
  final String? note;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    this.address,
    this.reminderDate,
    this.note,
  });
}
