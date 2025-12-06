import '../../entities/order.dart';
import '../../repositories/order_repository.dart';

class GetOrderById {
  final OrderRepository repository;
  GetOrderById(this.repository);

  Future<Order?> call(int? orderId) => repository.getOrderById(orderId);
}
