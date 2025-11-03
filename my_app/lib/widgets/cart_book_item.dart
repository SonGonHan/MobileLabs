import 'package:flutter/material.dart';

class CartBookItem extends StatelessWidget {
  final String title;
  final String author;
  final String isbn;

  const CartBookItem({
    super.key,
    required this.title,
    required this.author,
    required this.isbn,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 60,
          color: Colors.grey[300],
          child: const Icon(Icons.book, size: 30),
        ),
        title: Text(title),
        subtitle: Text('Автор: $author'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: null,
        ),
      ),
    );
  }
}
