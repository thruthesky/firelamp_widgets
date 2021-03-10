import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/forum/post/post_meta.dart';
import 'package:dalgona/firelamp_widgets/user/user_avatar.dart';
import 'package:dalgona/firelamp_widgets/widgets/image.cache.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';

class PostPreview extends StatelessWidget {
  PostPreview(this.post, this.forum, {this.onTap});
  final ApiPost post;
  final ApiForum forum;
  final Function onTap;

  // String get commentLine {
  //   final commentCount = post.comments.length;
  //   final t = '$commentCount comment';
  //   return commentCount == 0
  //       ? 'No comments yet ...'
  //       : commentCount > 1
  //           ? t + 's'
  //           : t;
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (post.hasFiles)
            Stack(
              overflow: Overflow.visible,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedImage(
                    post.files[0].url,
                    width: 100,
                    height: 80,
                  ),
                ),
                Positioned(
                  left: 10,
                  top: -15,
                  child: UserAvatar(post.user.photoUrl, size: 40),
                ),
              ],
            ),
          if (!post.hasFiles)
            Container(
              constraints: BoxConstraints(minWidth: 70),
              child: Column(
                children: [
                  UserAvatar(post.user.photoUrl, size: 55),
                  SizedBox(height: Space.xs),
                  Text('${post.user.name}')
                ],
              ),
            ),
          SizedBox(width: Space.xsm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostMeta(post, showAvatar: false),
                Text(
                  '${post.title}',
                  style: stylePostTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Space.xxs),
                Text(
                  '${post.content}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Space.xxs),
                Row(
                  children: [
                    if (post.comments.isEmpty) Text('No comments yet ..', style: TextStyle(fontSize: Space.xsm),),
                    if (post.comments.isNotEmpty) ...[
                      Icon(Icons.chat_bubble_outlined, size: Space.sm, color: Colors.grey[400]),
                      SizedBox(width: Space.xs),
                      Text('${post.comments.length}'),
                      SizedBox(width: Space.sm),
                    ],
                    if (forum.showLike && post.y > 0) ...[
                      Icon(Icons.thumb_up_rounded, size: Space.sm, color: Colors.grey[400]),
                      SizedBox(width: Space.xs),
                      Text('${post.y}'),
                      SizedBox(width: Space.sm),
                    ],
                    if (forum.showDislike && post.n > 0) ...[
                      Icon(Icons.thumb_down_rounded, size: Space.sm, color: Colors.grey[400]),
                      SizedBox(width: Space.xs),
                      Text('${post.n}')
                    ]
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
