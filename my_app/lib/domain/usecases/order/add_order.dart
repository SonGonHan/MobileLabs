import '../../entities/order.dart';
import '../../repositories/order_repository.dart';

class AddOrder {
  final OrderRepository repository;
  AddOrder(this.repository);

  Future<void> call(Order order) => repository.addOrder(order);
}
