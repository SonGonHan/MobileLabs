import '../../entities/order.dart';

abstract class OrderStorage {
  Future<List<Order>> getOrdersByUser(String userLogin);
  Future<void> addOrder(Order order);
  Future<Order?> getOrderById(int? orderId);
  Future<void> deleteOrder(int? orderId);
}
