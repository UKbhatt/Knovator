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
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('📮', style: TextStyle(fontSize: 18)),
                SizedBox(width: 6),
                Text('PostBox' , style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
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

            final total = controller.posts.length;
            final readCount = controller.readIds.length.clamp(0, total);
            final unreadCount = (total - readCount).clamp(0, total);

            return RefreshIndicator(
              onRefresh: () => controller.refreshFromServer(silent: true),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.posts.length + 1,
                itemBuilder: (_, i) {
                  if (i == 0) {
                    return _SummaryHeader(
                      unreadCount: unreadCount,
                      readCount: readCount,
                    );
                  }
                  final p = controller.posts[i - 1];
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

class _SummaryHeader extends StatelessWidget {
  final int unreadCount;
  final int readCount;
  const _SummaryHeader({required this.unreadCount, required this.readCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _CountChip(
            label: 'Unread',
            count: unreadCount,
            color: const Color(0xFFFFC107),
            textColor: Colors.black87,
          ),
          const SizedBox(width: 8),
          _CountChip(
            label: 'Read',
            count: readCount,
            color: const Color(0xFF4CAF50),
            textColor: Colors.white,
          ),
          const Spacer(),
          const Icon(Icons.swipe_down_alt, size: 18, color: Colors.black45),
          const SizedBox(width: 4),
          const Text(
            'Pull to refresh',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color textColor;
  const _CountChip({
    required this.label,
    required this.count,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
