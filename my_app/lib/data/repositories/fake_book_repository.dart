import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';

class FakeBookRepository implements BookRepository {
  final List<Book> _books = const [
    Book(
      title: 'Мастер и Маргарита',
      author: 'Михаил Булгаков',
      year: '1967',
      genre: 'Роман',
      isbn: '978-5-17-098341-7',
      price: 450,
    ),
    Book(
      title: 'Война и мир',
      author: 'Лев Толстой',
      year: '1869',
      genre: 'Роман',
      isbn: '978-5-17-098342-8',
      price: 550,
    ),
    Book(
      title: 'Преступление и наказание',
      author: 'Фёдор Достоевский',
      year: '1866',
      genre: 'Роман',
      isbn: '978-5-17-098343-9',
      price: 480,
    ),
    Book(
      title: '1984',
      author: 'Джордж Оруэлл',
      year: '1949',
      genre: 'Антиутопия',
      isbn: '978-5-17-098344-0',
      price: 420,
    ),
  ];

  @override
  Future<List<Book>> getAllBooks() async {
    return _books;
  }

  @override
  Future<Book> getByIsbn(String isbn) async {
    return _books.firstWhere((b) => b.isbn == isbn);
  }

}
