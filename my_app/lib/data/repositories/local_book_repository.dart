import 'dart:math';

import '../remote/openlibrary_api_service.dart';

import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/services/storage/book_storage.dart';

class LocalBookRepository implements BookRepository {
  final OpenLibraryApiService remoteService;
  final BookStorage bookStorage;

  LocalBookRepository({
    required this.remoteService,
    required this.bookStorage,
  });

  final subjects = [
      'fantasy',
      'science fiction',
      'sci-fi',
      'mystery',
      'thriller',
      'romance',
      'horror',
      'history',
      'biography',
      'poetry',
      'adventure',
      'children',
      'juvenile fiction',
      'young adult',
      'crime',
      'philosophy',
      'psychology',
      'science',
      'magic',
      'wizards',
      'fiction',
      'classic',
    ];

  @override
  Future<List<Book>> getAllBooks() async {
    final randomSubject = subjects[Random().nextInt(subjects.length)];

    try {
      final books = await remoteService.searchBooks(randomSubject);
      await bookStorage.save(books);
      return books;
    } catch (e) {
      final cached = await bookStorage.getAll();
      return cached;
    }
  }

  @override
  Future<List<Book>> searchBooks(String query) async {
    
    final cached = await bookStorage.search(query);
    if (cached.isNotEmpty) {
      return cached;
    }

    try {
      final books = await remoteService.searchBooks(query);
      await bookStorage.save(books);
      return books;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Book> getByIsbn(String isbn) async {
    final cached = await bookStorage.getByIsbn(isbn);
    if (cached != null) {
      return cached;
    }

    try {
      final books = await remoteService.searchBooks(isbn);
      if (books.isNotEmpty) {
        await bookStorage.save(books);
        return books.first;
      }
    } catch (_) {}

    throw Exception('Книга с ISBN $isbn не найдена');
  }

  @override
  Future<List<Book>> getBooksPage({required int limit, required int offset}) async {
    final randomSubject = subjects[Random().nextInt(subjects.length)];

    try {
      final books = await remoteService.searchBooks(randomSubject);
      await bookStorage.save(books);
      
      return books.skip(offset).take(limit).toList();
    } catch (e) {
      return await bookStorage.getBooksPage(limit, offset);
    }
  }

}
