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
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      p.body, // Body = description per requirements
                      style: Theme.of(context).textTheme.bodyLarge,
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
