import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/AppRoutes.dart';
import '../../../widgets/Error.view.dart';
import '../../../widgets/Loading.view.dart';
import '../controllers/PostController.dart';
import '../widgets/PostTile.dart';
import '../../../data/repositories/PostRepository.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostsController>(
      init: PostsController(Get.find<PostRepository>()),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Posts'),
            actions: [
              IconButton(
                onPressed: () => controller.refreshFromServer(),
                icon: const Icon(Icons.refresh),
                tooltip: 'Sync',
              ),
            ],
          ),
          body: Obx(() {
            if (controller.status.value == PostsStatus.loading &&
                controller.posts.isEmpty) {
              return const Center(child: PrimaryLoader());
            }
            if (controller.status.value == PostsStatus.error &&
                controller.posts.isEmpty) {
              return ErrorView(
                message: controller.errorMessage.value,
                onRetry: () => controller.refreshFromServer(),
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.refreshFromServer(silent: true),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.posts.length,
                itemBuilder: (_, i) {
                  final p = controller.posts[i];
                  return Obx(() {
                    final read = controller.readIds.contains(p.id);
                    return PostTile(
                      post: p,
                      read: read,
                      onTap: () async {
                        await controller.markAsRead(p.id);
                        Get.toNamed(Routes.postDetail, arguments: p.id);
                      },
                    );
                  });
                },
              ),
            );
          }),
        );
      },
    );
  }
}
