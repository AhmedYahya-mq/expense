import 'package:get/get.dart';
import 'package:party_planner/view/profile/account_screen.dart';
import 'package:party_planner/view/home_screen.dart';
import 'package:party_planner/view/transaction/transactions_screen.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    HomeScreen(),
    TransactionsScreen(title: "الدخل", link:'/get/incomes'),
    TransactionsScreen(title: "المصروفات", link:'/get/expenses'),
    AccountScreen(),
  ];
}
