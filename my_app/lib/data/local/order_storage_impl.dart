import '../../domain/entities/order.dart';
import '../../domain/services/storage/order_storage.dart';
import 'database/app_database.dart';

class OrderStorageImpl implements OrderStorage {
  final AppDatabase appDb;

  OrderStorageImpl(this.appDb);

  @override
  Future<List<Order>> getOrdersByUser(String userLogin) async {
    final db = await appDb.database;
    
    final orderMaps = await db.query(
      'orders',
      where: 'userLogin = ?',
      whereArgs: [userLogin],
      orderBy: 'date DESC',
    );

    final orders = <Order>[];
    for (final orderMap in orderMaps) {
      final orderId = orderMap['id'] as int;
      final itemMaps = await db.query(
        'order_items',
        where: 'orderId = ?',
        whereArgs: [orderId],
      );

      final items = itemMaps.map((itemMap) => OrderItem(
        bookIsbn: itemMap['bookIsbn'] as String,
        title: itemMap['title'] as String,
        price: (itemMap['price'] as num).toDouble(),
        quantity: itemMap['quantity'] as int,
      )).toList();

      orders.add(Order(
        id: orderId,
        userLogin: orderMap['userLogin'] as String,
        items: items,
        totalAmount: (orderMap['totalAmount'] as num).toDouble(),
        date: DateTime.fromMillisecondsSinceEpoch(orderMap['date'] as int),
        status: OrderStatus.values[orderMap['status'] as int],
      ));
    }

    return orders;
  }


  @override
  Future<void> addOrder(Order order) async {
    final db = await appDb.database;
    

    final id = await db.insert('orders', {
      'userLogin': order.userLogin,
      'totalAmount': order.totalAmount,
      'date': order.date.millisecondsSinceEpoch,
      'status': order.status.index,
    });

    final orderId = id;

      
    final batch = db.batch();
    for (final item in order.items) {
      batch.insert('order_items', {
        'orderId': orderId,
        'bookIsbn': item.bookIsbn,
        'title': item.title,
        'price': item.price,
        'quantity': item.quantity,
      });
    }
    await batch.commit();
  }


  @override
  Future<Order?> getOrderById(int? orderId) async {
    final db = await appDb.database;
    
    final orderMaps = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [orderId],
    );
    
    if (orderMaps.isEmpty) return null;
    
    final orderMap = orderMaps.first;
    final itemMaps = await db.query(
      'order_items',
      where: 'orderId = ?',
      whereArgs: [orderId],
    );

    final items = itemMaps.map((itemMap) => OrderItem(
      bookIsbn: itemMap['bookIsbn'] as String,
      title: itemMap['title'] as String,
      price: (itemMap['price'] as num).toDouble(),
      quantity: itemMap['quantity'] as int,
    )).toList();

    return Order(
      id: orderId,
      userLogin: orderMap['userLogin'] as String,
      items: items,
      totalAmount: (orderMap['totalAmount'] as num).toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(orderMap['date'] as int),
      status: OrderStatus.values[orderMap['status'] as int],
    );
  }

  @override
  Future<void> deleteOrder(int? orderId) async {
    final db = await appDb.database;
    
    await db.delete(
      'order_items',
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
    
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}
