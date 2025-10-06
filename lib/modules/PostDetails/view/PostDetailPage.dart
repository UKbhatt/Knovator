import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/Error.view.dart';
import '../../../widgets/Loading.view.dart';
import '../controllers/PostDetailController.dart';
import '../../../data/repositories/PostRepository.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostDetailController>(
      init: PostDetailController(Get.find<PostRepository>()),
      builder: (c) => Scaffold(
        appBar: AppBar(title: const Text('Post Detail')),
        body: Obx(() {
          switch (c.status.value) {
            case DetailStatus.loading:
              return const Center(child: PrimaryLoader());
            case DetailStatus.error:
              return ErrorView(message: c.error.value, onRetry: () {});
            case DetailStatus.ready:
              final p = c.post.value!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.article,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Post #${p.id}  •  by User ${p.userId}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Divider(color: Colors.grey.shade200, height: 1),
                            const SizedBox(height: 16),
                            Text(
                              p.body,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
          }
        }),
      ),
    );
  }
}
