import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/auth/login_screen_controller.dart';
import 'package:party_planner/controllers/request_controller.dart';
import 'package:party_planner/core/routes/app_routes.dart';
import 'package:party_planner/core/widgets/header.dart';
import 'package:party_planner/core/widgets/request_card.dart';
import 'package:party_planner/models/user.dart';

class RequestsScreen extends StatelessWidget {
  RequestsScreen({super.key});
  final RequestController _controller = Get.put(RequestController());
  final UserModel user = Get.find<LoginScreenController>().user;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    _controller.initRequestUser(id: user.id!);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.requestEntry);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Header(
                theme: theme,
                title: "الطلبات",
              ),
              Expanded(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: isDarkMode ? Colors.grey[900] : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Obx(
                            () {
                              if (_controller.isLoading.value &&
                                  _controller.requests.isEmpty) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (_controller.requests.isEmpty) {
                                return Center(
                                  child: Text(
                                    "لا توجد طلبات لعرضها",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isDarkMode
                                          ? Colors.grey[400]
                                          : Colors.black54,
                                    ),
                                  ),
                                );
                              }

                              return NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  if (scrollInfo.metrics.pixels ==
                                          scrollInfo.metrics.maxScrollExtent &&
                                      !_controller.isLoading.value) {
                                    _controller.loadMoreUserId(user.id!);
                                  }
                                  return true;
                                },
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    await _controller.initRequestUser(
                                        id: user.id!, reset: true);
                                  },
                                  child: ListView.builder(
                                    itemCount: _controller.requests.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index < _controller.requests.length) {
                                        var request =
                                            _controller.requests[index];
                                        return RequestCard(
                                          theme: theme,
                                          request: request,
                                          isSelf: true,
                                          index: index,
                                        );
                                      } else {
                                        return _controller.hasMore.value
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : const SizedBox.shrink();
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
