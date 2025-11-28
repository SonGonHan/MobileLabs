import '../entities/book.dart';
import '../entities/cart_item.dart';

class CartService {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool containsBook(String isbn) {
    return _items.any((item) => item.book.isbn == isbn);
  }

  void addBook(Book book) {
    final index = _items.indexWhere((item) => item.book.isbn == book.isbn);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(book: book, quantity: 1));
    }
  }

  void increment(String isbn) {
    final index = _items.indexWhere((item) => item.book.isbn == isbn);
    _items[index].quantity += 1;
  }

  void decrement(String isbn) {
    final index = _items.indexWhere((item) => item.book.isbn == isbn);
    if (index >= 0 && _items[index].quantity > 1) {
      _items[index].quantity -= 1;
    }
  }

  void remove(String isbn) {
    _items.removeWhere((item) => item.book.isbn == isbn);
  }

  void clear() {
    _items.clear();
  }
}
