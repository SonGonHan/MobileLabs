import '../../entities/book.dart';
import '../../repositories/book_repository.dart';

class GetBooksPage {
  final BookRepository repository;

  GetBooksPage(this.repository);

  Future<List<Book>> call({
    required int limit,
    required int offset,
  }) async {
    return await repository.getBooksPage(limit: limit, offset: offset);
  }
}
