import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/forum/basic/post_title.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';

class ForumBasicPostView extends StatefulWidget {
  ForumBasicPostView(
    this.post, {
    this.actions = const [],
    Key key,
  }) : super(key: key);

  final ApiPost post;
  final List<Widget> actions;

  @override
  _ForumBasicPostViewState createState() => _ForumBasicPostViewState();
}

class _ForumBasicPostViewState extends State<ForumBasicPostView> {
  bool displayContent = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ForumBasicPostTitle(widget.post,
            onTap: () => setState(() => displayContent = !displayContent)),
        if (displayContent) DisplayContent(widget.post),
      ],
    );
  }
}

class DisplayContent extends StatelessWidget {
  const DisplayContent(this.post);
  final ApiPost post;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (post.files.length > 0)
            Container(
              padding: EdgeInsets.all(Space.sm),
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  for (final file in post.files)
                    Image.network(
                      file.thumbnailUrl,
                      width: 100,
                      height: 100,
                    ),
                ],
              ),
            ),
          Container(
            padding: EdgeInsets.all(Space.sm),
            width: double.infinity,
            color: Colors.grey[100],
            child: Text(post.postContent),
          ),
        ],
      ),
    );
  }
}
