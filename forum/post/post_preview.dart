import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/forum/post/post_meta.dart';
import 'package:dalgona/firelamp_widgets/user/user_avatar.dart';
import 'package:dalgona/firelamp_widgets/widgets/image.cache.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';

class PostPreview extends StatelessWidget {
  PostPreview(this.post, {this.onTap});
  final ApiPost post;
  final Function onTap;

  String get commentLine {
    final commentCount = post.comments.length;
    final t = '$commentCount comment';
    return commentCount == 0
        ? 'No comments yet ...'
        : commentCount > 1
            ? t + 's'
            : t;
  }

  /// TODO: MODE TO API
  bool get hasFiles {
    return post.files.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (hasFiles)
            Stack(
              overflow: Overflow.visible,
              children: [
                CachedImage(
                  post.files[0].url,
                  width: 100,
                  height: 80,
                ),
                Positioned(
                  left: 10,
                  top: -15,
                  child: UserAvatar(post.user.photoUrl, size: 40),
                ),
              ],
            ),
          if (!hasFiles)
            Container(
              constraints: BoxConstraints(minWidth: 70),
              child: Column(
                children: [
                  UserAvatar(post.user.photoUrl),
                  SizedBox(height: Space.xxs),
                  Text('${post.displayName}')
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
                Text('$commentLine', style: styleHintText)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
