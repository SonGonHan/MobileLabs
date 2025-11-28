import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> getAllBooks();
  Future<Book> getByIsbn(String isbn);
}