import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoteButton extends StatefulWidget {
  final bool isLike;
  final dynamic postOrComment;

  VoteButton({@required this.postOrComment, this.isLike = true});

  @override
  _VoteButtonState createState() => _VoteButtonState();
}

class _VoteButtonState extends State<VoteButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        // TODO: show vote count.
        child: Text('${widget.isLike ? 'Like' : 'Dislike'}'),
        onPressed: () {
          // TODO: VOTE
          // - call to API
          // - update post or comment vote count
          // - setstate to re-render
          // print('TODO: VOTE');
        },
      ),
    );
  }
}
