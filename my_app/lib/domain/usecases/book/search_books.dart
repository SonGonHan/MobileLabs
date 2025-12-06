import '../../entities/book.dart';
import '../../repositories/book_repository.dart';

class SearchBooks {
  final BookRepository repository;

  SearchBooks(this.repository);

  Future<List<Book>> call(String query) async {
    return await repository.searchBooks(query);
  }
}
