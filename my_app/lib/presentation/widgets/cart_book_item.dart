import 'package:flutter/material.dart';

class CartBookItem extends StatelessWidget {
  final String title;
  final String author;
  final double price;
  final int quantity;
  final VoidCallback onDelete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartBookItem({
    super.key,
    required this.title,
    required this.author,
    required this.price,
    required this.quantity,
    required this.onDelete,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 4),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Автор: $author'),
            Text('Цена: ${price.toStringAsFixed(2)} ₽'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: onDecrement,
            ),
            Text('$quantity'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onIncrement,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
