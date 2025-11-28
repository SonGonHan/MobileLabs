import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;
  final bool isInCart;
  final VoidCallback onAddToCart;

  const BookDetailPage({
    super.key,
    required this.book,
    required this.isInCart,
    required this.onAddToCart,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Spacer(),
                ],
              ),

              const SizedBox(height: 8),
                Center(
                  child: Container(
                    width: 200,
                    height: 300,
                    color: Colors.grey[300],
                    child: const Icon(Icons.book, size: 100),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                
                Text(
                  'Автор: ${book.author}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                
                Text(
                  'Год публикации: ${book.year}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                
                Text(
                  'Жанр: ${book.genre}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                
                Text(
                  'ISBN: ${book.isbn}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),

                Text(
                  'Цена: ${book.price}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isInCart) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Книга уже добавлена в корзину!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } else {
                        onAddToCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${book.title} добавлена в корзину!'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInCart ? Colors.grey : Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      isInCart ? 'Добавлена в корзину' : 'Добавить в корзину',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}