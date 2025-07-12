import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controllers/request_controller.dart';
import 'package:party_planner/core/widgets/custom_tabs.dart';
import 'package:party_planner/core/widgets/header.dart';
import 'package:party_planner/core/widgets/request_card.dart';

class ManagerRequestsScreen extends StatelessWidget {
  ManagerRequestsScreen({super.key});
  final RequestController _controller = Get.put(RequestController());

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    _controller.initRequest();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Header(
                theme: theme,
                title: "الطلبات",
              ),
              const SizedBox(height: 20),
              CustomTabs(theme: theme),
              const SizedBox(height: 20),
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
                        Text(
                          "الطلبات",
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
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
                                    _controller.loadMore();
                                  }
                                  return true;
                                },
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    await _controller.initRequest(reset: true);
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
