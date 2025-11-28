import 'package:flutter/material.dart';
import 'presentation/pages/main_shell.dart';
import 'domain/repositories/book_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/order_repository.dart';
import 'data/repositories/fake_book_repository.dart';
import 'data/repositories/fake_order_repository.dart';
import 'data/repositories/fake_user_repository.dart';
import 'domain/usecases/book/get_all_books.dart';
import 'domain/usecases/order/add_order.dart';
import 'domain/usecases/order/get_orders_by_user.dart';
import 'domain/usecases/user/register_user.dart';
import 'domain/usecases/user/authenticate_user.dart';
import 'domain/usecases/user/get_by_login.dart';
import 'domain/usecases/user/update_user.dart';

void main() {
  // заглушка, пока не подключу БД
  final BookRepository bookRepository = FakeBookRepository();
  final UserRepository userRepository = FakeUserRepository();
  final OrderRepository orderRepository = FakeOrderRepository();

  final getAllBooks = GetAllBooks(bookRepository);
  final registerUser = RegisterUser(userRepository);
  final authenticateUser = AuthenticateUser(userRepository);
  final getByLogin = GetByLogin(userRepository);
  final updateUser = UpdateUser(userRepository);
  final addOrder = AddOrder(orderRepository);
  final getOrdersByUser = GetOrdersByUser(orderRepository);

  runApp(MyApp(
    getAllBooks: getAllBooks, 
    registerUser: registerUser,
    authenticateUser: authenticateUser,
    getByLogin: getByLogin,
    updateUser: updateUser, 
    addOrder: addOrder,
    getOrdersByUser: getOrdersByUser,
    ));
}

class MyApp extends StatelessWidget {
  final GetAllBooks getAllBooks;
  final RegisterUser registerUser;
  final AuthenticateUser authenticateUser;
  final GetByLogin getByLogin; 
  final UpdateUser updateUser;
  final AddOrder addOrder;
  final GetOrdersByUser getOrdersByUser;

  const MyApp({
    super.key,
    required this.getAllBooks,
    required this.registerUser,
    required this.authenticateUser,
    required this.getByLogin,
    required this.updateUser,
    required this.addOrder,
    required this.getOrdersByUser,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookStore',
      home: MainShell(
        getAllBooks: getAllBooks, 
        registerUser: registerUser,
        authenticateUser: authenticateUser,
        getByLogin: getByLogin,
        updateUser: updateUser,
        addOrder: addOrder,
        getOrdersByUser: getOrdersByUser,
        ),
    );
  }
}
