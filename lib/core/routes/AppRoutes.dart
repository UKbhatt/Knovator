import 'package:get/get.dart';
import '../../modules/Post/views/PostPage.dart';
import '../../modules/PostDetails/view/PostDetailPage.dart';

class Routes {
  static const posts = '/';
  static const postDetail = '/post-detail';
}

class AppRoutes {
  static final pages = <GetPage>[
    GetPage(name: Routes.posts, page: () => const PostsPage()),
    GetPage(name: Routes.postDetail, page: () => const PostDetailPage()),
  ];
}
