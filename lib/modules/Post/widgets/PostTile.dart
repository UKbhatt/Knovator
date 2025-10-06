import 'package:flutter/material.dart';
import '../../../data/models/ModelPost.dart';

class PostTile extends StatelessWidget {
  final Post post;
  final bool read;
  final VoidCallback onTap;
  const PostTile({
    super.key,
    required this.post,
    required this.read,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = read ? Colors.white : const Color(0xFFFFF9C4);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Card(
        color: bg,
        child: ListTile(
          title: Text(
            post.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            post.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon(
            read ? Icons.mark_email_read : Icons.mark_email_unread,
            size: 20,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
