import 'package:flutter/material.dart';
import 'package:my_app/presentation/widgets/cart_book_item.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/order/add_order.dart';
import '../../domain/usecases/user/get_by_login.dart';

class CartPage extends StatefulWidget {
  final AddOrder addOrder;
  final GetByLogin getByLogin;
  final User? curUser;
  final List<CartItem> cartItems;
  final void Function(String isbn) onDelete;
  final void Function(String isbn) onIncrement;
  final void Function(String isbn) onDecrement;
  final VoidCallback onClear;

  const CartPage({
    super.key,
    required this.addOrder,
    required this.getByLogin,
    required this.curUser,
    required this.cartItems,
    required this.onDelete,
    required this.onIncrement,
    required this.onDecrement,
    required this.onClear,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _houseController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    _streetController.dispose();
    _houseController.dispose();
    super.dispose();
  }

  Future<void> _onOrderPressed() async {
    if (widget.curUser == null) {
      Navigator.of(context).pushNamed('/profile');
      return;
    }

    if (_cityController.text.isEmpty) _cityController.text = widget.curUser!.city;
    if (_streetController.text.isEmpty) _streetController.text = widget.curUser!.street;
    if (_houseController.text.isEmpty) _houseController.text = widget.curUser!.house;

    final items = widget.cartItems.map((cartItem) {
      final book = cartItem.book;
      return OrderItem(
        bookIsbn: book.isbn,
        title: book.title,
        price: book.price,
        quantity: cartItem.quantity,
      );
    }).toList();

    final order = Order(
      id: 0,
      userLogin: widget.curUser!.login,
      items: items,
      totalAmount: items.fold(
        0.0,
        (sum, item) => sum + item.price * item.quantity,
      ),
      date: DateTime.now(),
      status: OrderStatus.confirmed,
    );

    await widget.addOrder(order);

    widget.onClear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Заказ успешно оформлен!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: widget.cartItems.map((cartItem) {
                  final book = cartItem.book;
                  return CartBookItem(
                    title: book.title,
                    author: book.author,
                    price: book.price,
                    quantity: cartItem.quantity,
                    onDelete: () => setState(() => widget.onDelete(book.isbn)),
                    onIncrement: () => setState(() => widget.onIncrement(book.isbn)),
                    onDecrement: () => setState(() => widget.onDecrement(book.isbn)),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Адрес доставки:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'Город'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _streetController,
                    decoration: const InputDecoration(labelText: 'Улица'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _houseController,
                    decoration: const InputDecoration(labelText: 'Дом'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: widget.cartItems.isEmpty ? null : _onOrderPressed,
                    child: const Text('Оформить заказ'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
