import 'package:flutter/material.dart';

class BookListItem extends StatelessWidget {
  final String title;
  final String author;
  final String year;
  final String genre;
  final String isbn;

  const BookListItem({
    super.key,
    required this.title,
    required this.author,
    required this.year,
    required this.genre,
    required this.isbn,
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
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Автор: $author'),
            Text('Год: $year | Жанр: $genre'),
            Text('ISBN: $isbn'),
          ],
        ),
      ),
    );
  }
}
