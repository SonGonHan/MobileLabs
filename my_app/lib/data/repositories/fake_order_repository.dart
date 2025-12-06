import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

class FakeOrderRepository implements OrderRepository {
  final List<Order> _orders = [Order(
  id: 1,
  userLogin: 'demo',
  items: [
    OrderItem(
      bookIsbn: '978-5-17-098341-7',
      title: 'Мастер и Маргарита',
      price: 450,
      quantity: 1,
    ),
    OrderItem(
      bookIsbn: '978-5-17-098342-8',
      title: 'Война и мир',
      price: 550,
      quantity: 2,
    ),
  ],
  totalAmount: 1550,
  date: DateTime.now(),
  status: OrderStatus.confirmed
)];

  @override
  Future<void> addOrder(Order order) async {
    _orders.add(order);
  }

  @override
  Future<List<Order>> getOrdersByUser(String userLogin) async {
    return _orders.where((o) => o.userLogin == userLogin).toList();
  }

  @override
  Future<Order?> getOrderById(int? orderId) async {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }
}
