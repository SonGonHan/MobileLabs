import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';

class BookListItem extends StatelessWidget {
  final Book book; // Теперь принимаем объект Book

  const BookListItem({
    super.key,
    required this.book,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 70,
          color: Colors.grey[300],
          child: const Icon(Icons.book, size: 40),
        ),
        title: Text(
          book.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Автор: ${book.author}'),
            Text('Год: ${book.year} | Жанр: ${book.genre}'),
            Text('Цена: ${book.price}'),
          ],
        ),
        onTap: () {
        Navigator.of(context).pushNamed(
            '/bookDetail',
            arguments: book, // объект Book
          );
        } 
      ),
    );
  }
}
