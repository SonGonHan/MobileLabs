import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карточка книги'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 200,
                  height: 300,
                  color: Colors.grey[300],
                  child: const Icon(Icons.book, size: 100),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Мастер и Маргарита',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Автор: Михаил Булгаков'),
              const SizedBox(height: 5),
              const Text('Год: 1967'),
              const SizedBox(height: 5),
              const Text('Жанр: Роман'),
              const SizedBox(height: 5),
              const Text('ISBN: 978-5-17-098341-7'),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Добавить в корзину',),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}