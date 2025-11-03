import 'package:flutter/material.dart';
import 'package:my_app/widgets/book_list_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookStore'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Поиск по названию, автору, жанру...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Найти'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: const [
                BookListItem(
                  title: 'Мастер и Маргарита',
                  author: 'Михаил Булгаков',
                  year: '1967',
                  genre: 'Роман',
                  isbn: '978-5-17-098341-7',
                ),
                BookListItem(
                  title: 'Война и мир',
                  author: 'Лев Толстой',
                  year: '1869',
                  genre: 'Роман',
                  isbn: '978-5-17-098342-8',
                ),
                BookListItem(
                  title: 'Преступление и наказание',
                  author: 'Федор Достоевский',
                  year: '1866',
                  genre: 'Роман',
                  isbn: '978-5-17-098343-9',
                ),
                BookListItem(
                  title: '1984',
                  author: 'Джордж Оруэлл',
                  year: '1949',
                  genre: 'Антиутопия',
                  isbn: '978-5-17-098344-0',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}