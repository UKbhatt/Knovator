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
      // Ensure cached content is English-ized too (only transforms lorem)
      final english = _englishizeList(posts);
      return Ok(english);
    } catch (e) {
      return Err(Failure('Failed to read local cache'));
    }
  }

  Future<Result<List<Post>>> syncPosts() async {
    try {
      if (!await connectivity.hasConnection) {
        final cached = loadCachedPosts();
        if (cached is Ok<List<Post>> && cached.value.isNotEmpty) {
          return Ok(cached.value);
        }
        return Err(Failure('No internet connection'));
      }
      final list = await api.fetchPosts();
      var posts = Post.listFromDynamic(list);

      // Convert lorem to simple English
      posts = _englishizeList(posts);

      // Persist
      await hive.savePosts(posts.map((e) => e.toMap()).toList());
      return Ok(posts);
    } catch (e) {
      final cached = loadCachedPosts();
      if (cached is Ok<List<Post>> && cached.value.isNotEmpty) {
        return Ok(cached.value);
      }
      return Err(Failure('Fetch failed: $e'));
    }
  }

  Future<Result<Post>> getPostDetail(int id) async {
    final cached = hive.getCachedPosts();
    final map = cached.firstWhereOrNull((e) => (e['id'] as int) == id);
    if (map != null) {
      final p = Post.fromMap(map);
      return Ok(_englishizeOne(p));
    }
    try {
      final detail = await api.fetchPostDetail(id);
      return Ok(_englishizeOne(Post.fromMap(detail)));
    } catch (e) {
      return Err(Failure('Unable to fetch post #$id: $e'));
    }
  }

  List<int> getReadIds() => hive.getReadIds();
  Future<void> markRead(int id) => hive.setRead(id, read: true);

  // ---------- English helpers ----------

  static final _loremTriggers = <String>{
    'lorem',
    'ipsum',
    'dolor',
    'sit',
    'amet',
    'consectetur',
    'adipisicing',
    'elit',
    'eiusmod',
    'tempor',
    'incididunt',
    'labore',
    'dolore',
  };

  bool _looksLikeLorem(String s) {
    final lower = s.toLowerCase();
    int hits = 0;
    for (final w in _loremTriggers) {
      if (lower.contains(w)) hits++;
      if (hits >= 2) return true; // signal
    }
    return false;
  }

  Post _englishizeOne(Post p) {
    final needsTitle = _looksLikeLorem(p.title);
    final needsBody = _looksLikeLorem(p.body);

    final title = needsTitle ? 'Post #${p.id} from user ${p.userId}' : p.title;

    final body = needsBody
        ? 'This is a sample post for demonstration. It includes a title and a short description so the UI shows readable English text.'
        : p.body;

    return Post(id: p.id, userId: p.userId, title: title, body: body);
  }

  List<Post> _englishizeList(List<Post> posts) =>
      posts.map(_englishizeOne).toList();
}
