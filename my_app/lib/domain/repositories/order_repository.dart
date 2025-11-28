import '../entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrdersByUser(String userLogin);
  Future<void> addOrder(Order order);
  Future<Order?> getOrderById(String orderId);
}