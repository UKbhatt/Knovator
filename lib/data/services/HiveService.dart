import 'package:hive/hive.dart';

class HiveService {
  Box get postsBox => Hive.box('postsBox');
  Box get readBox => Hive.box('readBox');
  Box get metaBox => Hive.box('metaBox');

  // Posts
  List<Map<String, dynamic>> getCachedPosts() {
    final list = postsBox.get('posts', defaultValue: <Map<String, dynamic>>[]) as List?;
    return (list ?? []).cast<Map<String, dynamic>>();
  }

  Future<void> savePosts(List<Map<String, dynamic>> posts) async {
    await postsBox.put('posts', posts);
    await metaBox.put('lastSync', DateTime.now().toIso8601String());
  }

  // Read statuses
  List<int> getReadIds() {
    final list = readBox.get('readIds', defaultValue: <int>[]) as List?;
    return (list ?? []).cast<int>();
  }

  Future<void> setRead(int id, {bool read = true}) async {
    final current = getReadIds().toSet();
    if (read) {
      current.add(id);
    } else {
      current.remove(id);
    }
    await readBox.put('readIds', current.toList());
  }
}
