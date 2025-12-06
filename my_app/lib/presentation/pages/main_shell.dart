import 'package:flutter/material.dart';
import 'package:my_app/domain/usecases/book/search_books.dart';

import '../../domain/entities/book.dart';
import '../../domain/entities/user.dart';

import '../../domain/services/cart_service.dart';

import '../../domain/usecases/book/get_all_books.dart';
import '../../domain/usecases/order/add_order.dart';
import '../../domain/usecases/order/get_orders_by_user.dart';
import '../../domain/usecases/user/authenticate_user.dart';
import '../../domain/usecases/user/get_by_login.dart';
import '../../domain/usecases/user/register_user.dart';
import '../../domain/usecases/user/update_user.dart';

import 'home_page.dart';
import 'cart_page.dart';
import 'login_page.dart';
import 'book_detail_page.dart';
import 'acc_info_page.dart';
import 'registration_page.dart';
import 'acc_settings_page.dart';
import 'acc_orders_page.dart';

class MainShell extends StatefulWidget {
  final GetAllBooks getAllBooks;
  final RegisterUser registerUser;
  final AuthenticateUser authenticateUser;
  final GetByLogin getByLogin;
  final UpdateUser updateUser;
  final AddOrder addOrder;
  final GetOrdersByUser getOrdersByUser;
  final SearchBooks searchBooks;

  const MainShell({
    super.key,
    required this.getAllBooks,
    required this.registerUser,
    required this.authenticateUser,
    required this.getByLogin,
    required this.updateUser,
    required this.addOrder,
    required this.getOrdersByUser,
    required this.searchBooks,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;
  User? curUser;

  final CartService _cart = CartService();

  // обертки вокруг сервиса + setState, чтобы обновлять UI
  void _addToCart(Book book) {
    setState(() {
      _cart.addBook(book);
    });
  }

  void _inc(String isbn) {
    setState(() {
      _cart.increment(isbn);
    });
  }

  void _dec(String isbn) {
    setState(() {
      _cart.decrement(isbn);
    });
  }

  void _deleteFromCart(String isbn) {
    setState(() {
      _cart.remove(isbn);
    });
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
    });
  }

  bool _isInCart(Book book) => _cart.containsBook(book.isbn);
  
  void _logout () {
    setState(() {
      curUser = null;
      _clearCart();
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        _navigatorKey.currentState!
            .pushNamedAndRemoveUntil('/catalog', (route) => false);
        break;
      case 1:
        _navigatorKey.currentState!
            .pushNamedAndRemoveUntil('/cart', (route) => false);
        break;
      case 2:
        _navigatorKey.currentState!
            .pushNamedAndRemoveUntil('/profile', (route) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        initialRoute: '/catalog',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/catalog':
              return MaterialPageRoute(
                builder: (_) => HomePage(
                  key: const PageStorageKey<String>('homePage'),
                  getAllBooks: widget.getAllBooks, 
                  searchBooks: widget.searchBooks,),
              );
            case '/cart':
              return MaterialPageRoute(
                builder: (_) => CartPage(
                  addOrder: widget.addOrder,
                  getByLogin: widget.getByLogin,
                  curUser: curUser,
                  cartItems: _cart.items,
                  onDelete: _deleteFromCart,
                  onIncrement: _inc,
                  onDecrement: _dec,
                  onClear: _clearCart,
                ),
              );
            case '/profile':
              final user = settings.arguments as User?;
              if (user != null) {
                curUser = user;
              }
              return MaterialPageRoute(
                builder: (_) =>
                    curUser != null ? 
                      AccInfoPage(curUser: curUser!, logout: _logout,) : 
                      LoginPage(
                        authenticateUser: widget.authenticateUser,
                        getByLogin: widget.getByLogin,
                      ),
              );
            case '/bookDetail':
              final book = settings.arguments as Book;
              return MaterialPageRoute(
                builder: (_) => BookDetailPage(
                  book: book,
                  isInCart: _isInCart(book),
                  onAddToCart: () => _addToCart(book),
                ),
              );
            case '/registration':
              return MaterialPageRoute(
                builder: (_) => RegistrationPage(registerUser: widget.registerUser,),
              );
            case '/settings':
              return MaterialPageRoute(
                builder: (_) => AccSettingsPage(
                  user: curUser!, 
                  updateUser: widget.updateUser),
              );
            case '/orders':
              return MaterialPageRoute(
                builder: (_) => AccOrdersPage(
                  user: curUser!, 
                  getOrdersByUser: widget.getOrdersByUser),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => HomePage(
                  key: const PageStorageKey<String>('homePage'),
                  getAllBooks: widget.getAllBooks, 
                  searchBooks: widget.searchBooks),
              );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Каталог',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
