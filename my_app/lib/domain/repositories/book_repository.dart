import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> getAllBooks();
  Future<Book> getByIsbn(String isbn);
  Future<List<Book>> searchBooks(String query);
  Future<List<Book>> getBooksPage({required int limit, required int offset});
}