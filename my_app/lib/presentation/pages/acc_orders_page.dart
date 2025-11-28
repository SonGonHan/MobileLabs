import 'package:flutter/material.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/order/get_orders_by_user.dart';

class AccOrdersPage extends StatelessWidget {
  final User user;
  final GetOrdersByUser getOrdersByUser;

  const AccOrdersPage({
    super.key,
    required this.user,
    required this.getOrdersByUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои заказы')),
      body: FutureBuilder<List<Order>>(
        future: getOrdersByUser(user.login),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Ошибка загрузки заказов'));
          }

          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('У вас пока нет заказов'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 2,
                child: ExpansionTile(
                  title: Text('Заказ #${order.id}'),
                  subtitle: Text('Статус: ${_statusText(order.status)}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Состав заказа:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          // список книг заказа
                          ...order.items.map((item) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  '- ${item.title} '
                                  '(${item.quantity})'
                                  ' — ${item.price.toStringAsFixed(2)} ₽',
                                ),
                              )),
                          const SizedBox(height: 8),
                          Text(
                            'Итого: ${order.totalAmount.toStringAsFixed(2)} ₽',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('Дата: ${order.date.toLocal()}'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _statusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'В ожидании';
      case OrderStatus.confirmed:
        return 'Подтвержден';
    }
  }
}
