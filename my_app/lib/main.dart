import 'package:flutter/material.dart';
import '../../domain/usecases/book/search_books.dart';

import 'data/local/database/app_database.dart';
import 'data/local/book_storage_impl.dart';
import 'data/local/order_storage_impl.dart';
import 'data/local/user_storage_impl.dart';
import 'data/remote/openlibrary_api_service.dart';

// import 'data/repositories/fake_book_repository.dart';
// import 'data/repositories/fake_order_repository.dart';
// import 'data/repositories/fake_user_repository.dart';

import 'data/repositories/local_order_repoistory.dart';
import 'data/repositories/local_user_repository.dart';
import 'data/repositories/local_book_repository.dart';


import 'domain/entities/user.dart';
import 'domain/usecases/book/get_all_books.dart';
import 'domain/usecases/order/add_order.dart';
import 'domain/usecases/order/get_orders_by_user.dart';
import 'domain/usecases/user/register_user.dart';
import 'domain/usecases/user/authenticate_user.dart';
import 'domain/usecases/user/get_by_login.dart';
import 'domain/usecases/user/update_user.dart';

import 'presentation/pages/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDb = AppDatabase();
  await appDb.database;

  final userStorage = UserStorageImpl(appDb);
  final userRepository = LocalUserRepository(userStorage);
  // final userRepository = FakeUserRepository();

  final testUser = await userRepository.getByLogin('demo');
  if (testUser == null) {
    await userRepository.saveUser(User(
      login: 'demo',
      password: '123',
      email: 'demo@example.com',
      phone: '7 900 000-00-00',
      city: 'Москва',
      street: 'Тверская',
      house: '1',
    ));
  }


  final orderStorage = OrderStorageImpl(appDb);
  final orderRepository = LocalOrderRepository(orderStorage);
  // final orderRepository = FakeOrderRepository()


  final bookStorage = BookStorageImpl(appDb);
  final openLibraryService = OpenLibraryApiService();
  final bookRepository = LocalBookRepository(
    remoteService: openLibraryService,
    bookStorage:bookStorage,
  );
  // final fakeBookRepository = FakeBookRepository();

  final getAllBooks = GetAllBooks(bookRepository);
  final searchBooks = SearchBooks(bookRepository);
  final registerUser = RegisterUser(userRepository);
  final authenticateUser = AuthenticateUser(userRepository);
  final getByLogin = GetByLogin(userRepository);
  final updateUser = UpdateUser(userRepository);
  final addOrder = AddOrder(orderRepository);
  final getOrdersByUser = GetOrdersByUser(orderRepository);

  runApp(MyApp(
    getAllBooks: getAllBooks, 
    searchBooks: searchBooks,
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
  final SearchBooks searchBooks;

  const MyApp({
    super.key,
    required this.getAllBooks,
    required this.searchBooks,
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
        searchBooks: searchBooks,
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
