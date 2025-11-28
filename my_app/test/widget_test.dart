import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/data/repositories/fake_order_repository.dart';
import 'package:my_app/data/repositories/fake_user_repository.dart';
import 'package:my_app/domain/repositories/book_repository.dart';
import 'package:my_app/domain/repositories/order_repository.dart';
import 'package:my_app/domain/repositories/user_repository.dart';
import 'package:my_app/domain/usecases/book/get_all_books.dart';
import 'package:my_app/domain/usecases/order/add_order.dart';
import 'package:my_app/domain/usecases/order/get_orders_by_user.dart';
import 'package:my_app/domain/usecases/user/authenticate_user.dart';
import 'package:my_app/domain/usecases/user/get_by_login.dart';
import 'package:my_app/domain/usecases/user/register_user.dart';
import 'package:my_app/domain/usecases/user/update_user.dart';

import 'package:my_app/main.dart';
import 'package:my_app/data/repositories/fake_book_repository.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    final BookRepository  bookRepository = FakeBookRepository();
    final UserRepository userRepository = FakeUserRepository();
    final OrderRepository orderRepository = FakeOrderRepository();
    
    // Domain layer
    final GetAllBooks getAllBooks = GetAllBooks(bookRepository);
    final RegisterUser registerUser = RegisterUser(userRepository);
    final AuthenticateUser authenticateUser = AuthenticateUser(userRepository);
    final GetByLogin getByLogin = GetByLogin(userRepository);
    final UpdateUser updateUser = UpdateUser(userRepository);
    final AddOrder addOrder = AddOrder(orderRepository);
    final GetOrdersByUser getOrdersByUser = GetOrdersByUser(orderRepository);
    
    MyApp myApp = MyApp(
      getAllBooks: getAllBooks, 
      registerUser: registerUser,
      authenticateUser: authenticateUser,
      getByLogin: getByLogin,
      updateUser: updateUser,
      addOrder: addOrder,
      getOrdersByUser: getOrdersByUser,
    );

    await tester.pumpWidget(myApp);

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
