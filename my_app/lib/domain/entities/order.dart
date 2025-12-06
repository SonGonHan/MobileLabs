class Order {
  final int? id;
  final String userLogin;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime date;
  final OrderStatus status;

  Order({
    this.id,
    required this.userLogin,
    required this.items,
    required this.totalAmount,
    required this.date,
    required this.status
  });
}

class OrderItem {
  final String bookIsbn;
  final String title;
  final double price;
  final int quantity;

  OrderItem({
    required this.bookIsbn,
    required this.title,
    required this.price,
    required this.quantity
  });
}

enum OrderStatus {
  pending,
  confirmed
}