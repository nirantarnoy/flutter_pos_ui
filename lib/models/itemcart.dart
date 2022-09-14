class ItemCart {
  final id;
  final code;
  final name;
  String qty;
  final price;
  final line_discount;

  ItemCart({
    this.id,
    this.code,
    this.name,
    required this.qty,
    this.price,
    this.line_discount,
  });
}
