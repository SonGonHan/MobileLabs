import '../../entities/book.dart';

abstract class BookStorage {
  Future<void> save(List<Book> books);
  Future<List<Book>> getAll();
  Future<List<Book>> search(String query);
  Future<Book?> getByIsbn(String isbn);
  Future<void> clear();
  Future<List<Book>> getBooksPage(int limit, int offset);
}