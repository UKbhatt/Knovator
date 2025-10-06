import 'package:get/get.dart';
import '../../../core/utils/Results.dart';
import '../../../data/models/ModelPost.dart';
import '../../../data/repositories/PostRepository.dart';
import '../../Post/controllers/PostController.dart';

class PostDetailController extends GetxController {
  final PostRepository repo;
  PostDetailController(this.repo);

  final status = Rx<DetailStatus>(DetailStatus.loading);
  final post = Rxn<Post>();
  final error = ''.obs;

  late final int postId;

  @override
  void onInit() {
    super.onInit();
    postId = Get.arguments as int;
    final postsController = Get.isRegistered<PostsController>()
        ? Get.find<PostsController>()
        : null;
    postsController?.markAsRead(postId);

    _load();
  }

  Future<void> _load() async {
    status.value = DetailStatus.loading;
    final res = await repo.getPostDetail(postId);
    if (res is Ok<Post>) {
      post.value = res.value;
      status.value = DetailStatus.ready;
    } else if (res is Err<Post>) {
      error.value = res.error.toString();
      status.value = DetailStatus.error;
    }
  }
}

enum DetailStatus { loading, ready, error }
