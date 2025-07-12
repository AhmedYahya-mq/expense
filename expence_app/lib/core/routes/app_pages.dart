import 'package:get/get.dart';
import 'package:party_planner/core/routes/app_routes.dart';
import 'package:party_planner/view/auth/login/login.dart';
import 'package:party_planner/view/forms/budget_form.dart';
import 'package:party_planner/view/forms/income_form.dart';
import 'package:party_planner/view/forms/users_form.dart';
import 'package:party_planner/view/notification/notification_screen.dart';
import 'package:party_planner/view/profile/edit_account_screen.dart';
import 'package:party_planner/view/request/manager_requests_screen.dart';
import 'package:party_planner/view/navigation_menu.dart';
import 'package:party_planner/view/profile/account_screen.dart';
import 'package:party_planner/view/profile/details_payment_screen.dart';
import 'package:party_planner/view/profile/profile_screen.dart';
import 'package:party_planner/view/profile/pymenet_screen.dart';
import 'package:party_planner/view/profile/settings_screen.dart';
import 'package:party_planner/view/request/request_details_screen.dart';
import 'package:party_planner/view/request/request_setting/request_screen.dart';
import 'package:party_planner/view/splash_screen.dart';
import 'package:party_planner/view/transaction/transaction_details_screen.dart';
import 'package:party_planner/view/transaction/transactions_screen.dart';
import 'package:party_planner/view/request/request_entry_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const NavigationMenu(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.transaction,
      page: () => TransactionsScreen(
        isBack: true,
      ),
    ),
    GetPage(
      name: AppRoutes.transactionDetail,
      page: () => TransactionDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.editAccount,
      page: () => EditAccountScreen(),
    ),
    GetPage(
      name: AppRoutes.account,
      page: () => AccountScreen(),
    ),
    GetPage(
      name: AppRoutes.payment,
      page: () => PaymentScreen(),
    ),
    GetPage(
      name: AppRoutes.paymentDetails,
      page: () => DetailsPaymentScreen(),
    ),
    GetPage(
      name: AppRoutes.managerRequests,
      page: () => ManagerRequestsScreen(),
    ),
    GetPage(
      name: AppRoutes.requestsDetails,
      page: () => RequestDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingsScreen(),
    ),
    GetPage(
      name: AppRoutes.users,
      page: () => UsersForm(),
    ),
    GetPage(
      name: AppRoutes.budget,
      page: () => BudgetForm(),
    ),
    GetPage(
      name: AppRoutes.income,
      page: () => IncomeForm(),
    ),
    GetPage(
      name: AppRoutes.requestEntry,
      page: () => RequestEntryScreen(),
    ),
    GetPage(
      name: AppRoutes.request,
      page: () => RequestsScreen(),
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => NotificationManagementScreen(),
    ),
  ];
}
