import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/book/get_all_books.dart';
import '../../domain/usecases/book/search_books.dart'; 
import '../widgets/book_list_item.dart';

class HomePage extends StatefulWidget {
  final GetAllBooks getAllBooks;
  final SearchBooks searchBooks;

  const HomePage({
    super.key,
    required this.getAllBooks,
    required this.searchBooks,
  });

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  List<Book> allBooks = [];
  List<Book> visibleBooks = [];
  bool isLoading = true;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() => isLoading = true);
    try {
      final result = await widget.getAllBooks();
      setState(() {
        allBooks = result;
        visibleBooks = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        allBooks = [];
        visibleBooks = [];
        isLoading = false;
      });
    }
  }


  Future<void> applySearch(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      setState(() {
        visibleBooks = allBooks;
        isSearching = false;
      });
      return;
    }

    setState(() => isSearching = true);
    
    try {
      final results = await widget.searchBooks(q);
      setState(() {
        visibleBooks = results;
        isSearching = false;
      });
    } catch (e) {
      setState(() {
        visibleBooks = [];
        isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск книг...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (text) {
                  if (text.length > 2) {
                    applySearch(text);
                  } else if (text.isEmpty) {
                    applySearch('');
                  }
                },
              ),
            ),
            if (isLoading || isSearching)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: visibleBooks.length,
                  itemBuilder: (context, index) {
                    final book = visibleBooks[index];
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
