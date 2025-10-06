import 'package:get/get.dart';
import '../../core/utils/Failure.dart';
import '../../core/utils/Results.dart';
import '../models/ModelPost.dart';
import '../services/ApiService.dart';
import '../services/HiveService.dart';
import '../services/ConnectionService.dart';

class PostRepository {
  final ApiClient api;
  final HiveService hive;
  final ConnectivityService connectivity;

  PostRepository({
    required this.api,
    required this.hive,
    required this.connectivity,
  });

  Result<List<Post>> loadCachedPosts() {
    try {
      final cached = hive.getCachedPosts();
      final posts = cached.map((e) => Post.fromMap(e)).toList();
      return Ok(posts);
    } catch (e) {
      return Err(Failure('Failed to read local cache'));
    }
  }

  Future<Result<List<Post>>> syncPosts() async {
    try {
      if (!await connectivity.hasConnection) {
        return Err(
          Failure(
            'You appear to be offline. Please check your internet connection and try again.',
          ),
        );
      }
      final list = await api.fetchPosts();
      final posts = Post.listFromDynamic(list);
      await hive.savePosts(posts.map((e) => e.toMap()).toList());
      return Ok(posts);
    } catch (e) {
      return Err(
        Failure(
          'Unable to load posts right now. Please try again in a moment.',
        ),
      );
    }
  }

  Future<Result<Post>> getPostDetail(int id) async {
    final cached = hive.getCachedPosts();
    final map = cached.firstWhereOrNull((e) => (e['id'] as int) == id);
    if (map != null) {
      return Ok(Post.fromMap(map));
    }
    try {
      final detail = await api.fetchPostDetail(id);
      return Ok(Post.fromMap(detail));
    } catch (e) {
      return Err(
        Failure('Unable to load this post at the moment. Please try again.'),
      );
    }
  }

  List<int> getReadIds() => hive.getReadIds();
  Future<void> markRead(int id) => hive.setRead(id, read: true);

 
}
