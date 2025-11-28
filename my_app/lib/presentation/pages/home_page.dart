import 'package:flutter/material.dart';

import '../../domain/usecases/book/get_all_books.dart';
import '../../domain/entities/book.dart';

import '../widgets/book_list_item.dart';

class HomePage extends StatefulWidget {
  final GetAllBooks getAllBooks;

  const HomePage({super.key, required this.getAllBooks});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  List<Book> _allBooks = [];
  List<Book> _visibleBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await widget.getAllBooks();
    setState(() {
      _allBooks = result;
      _visibleBooks = result; // по умолчанию показываем все книги
      _isLoading = false;
    });
  }

  void _applySearch(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _visibleBooks = _allBooks;
      } else {
        _visibleBooks = _allBooks.where((book) {
          return book.title.toLowerCase().contains(q) ||
              book.author.toLowerCase().contains(q) ||
              book.genre.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Поле поиска + кнопка
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Поиск по названию, автору, жанру...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: _applySearch,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _applySearch(_searchController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Найти'),
                  ),
                ],
              ),
            ),

            // Список книг / загрузка / пустой результат
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _visibleBooks.isEmpty
                      ? const Center(
                          child: Text('Книги не найдены'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: _visibleBooks.length,
                          itemBuilder: (context, index) {
                            final book = _visibleBooks[index];
                            return BookListItem(book: book);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
