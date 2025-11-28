import '../../entities/order.dart';
import '../../repositories/order_repository.dart';

class GetOrdersByUser {
  final OrderRepository repository;
  GetOrdersByUser(this.repository);

  Future<List<Order>> call(String userLogin) => repository.getOrdersByUser(userLogin);
}
