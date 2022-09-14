class Order {
  final String id;
  final String order_no;
  final String order_date;
  final String total_amount;
  final String status;
  final String user_id;

  Order({
    required this.id,
    required this.order_no,
    required this.order_date,
    required this.total_amount,
    required this.status,
    required this.user_id,
  });
}
