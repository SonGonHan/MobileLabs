import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/services/storage/order_storage.dart';

class LocalOrderRepository implements OrderRepository {
  final OrderStorage orderStorage;

  LocalOrderRepository(this.orderStorage);

  @override
  Future<void> addOrder(Order order) async {
    await orderStorage.addOrder(order);
  }

  @override
  Future<List<Order>> getOrdersByUser(String userLogin) async {
    return await orderStorage.getOrdersByUser(userLogin);
  }

  @override
  Future<Order?> getOrderById(int? orderId) async {
    return await orderStorage.getOrderById(orderId);
  }
}
