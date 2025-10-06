import 'package:get/get.dart';
import '../../../core/utils/Results.dart';
import '../../../data/models/ModelPost.dart';
import '../../../data/repositories/PostRepository.dart';

enum PostsStatus { idle, loading, refreshing, error }

class PostsController extends GetxController {
  final PostRepository repo;
  PostsController(this.repo);

  final posts = <Post>[].obs;
  final readIds = <int>{}.obs;
  final status = PostsStatus.idle.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final cached = repo.loadCachedPosts();
    if (cached is Ok<List<Post>>) {
      posts.assignAll(cached.value);
    }

    readIds.addAll(repo.getReadIds());

    await refreshFromServer(silent: posts.isNotEmpty);
  }

  Future<void> refreshFromServer({bool silent = false}) async {
    if (!silent) {
      status.value = PostsStatus.loading;
    } else {
      status.value = PostsStatus.refreshing;
    }
    final result = await repo.syncPosts();
    if (result is Ok<List<Post>>) {
      posts.assignAll(result.value);
      status.value = PostsStatus.idle;
    } else if (result is Err<List<Post>>) {
      status.value = PostsStatus.error;
      errorMessage.value = result.error.toString();
    }
  }

  bool isRead(int id) => readIds.contains(id);

  Future<void> markAsRead(int id) async {
    if (!readIds.contains(id)) {
      readIds.add(id);
      await repo.markRead(id);
    }
  }
}
