class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromMap(Map<String, dynamic> map) => Post(
        id: map['id'] as int,
        userId: map['userId'] as int,
        title: (map['title'] ?? '').toString(),
        body: (map['body'] ?? '').toString(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'title': title,
        'body': body,
      };

  static List<Post> listFromDynamic(dynamic data) {
    if (data is List) {
      return data.map((e) => Post.fromMap(Map<String, dynamic>.from(e))).toList();
    }
    return const [];
  }
}
