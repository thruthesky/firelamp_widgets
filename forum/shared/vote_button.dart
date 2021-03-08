import 'package:firelamp/firelamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoteButton extends StatefulWidget {
  final bool isLike;
  final dynamic postOrComment;
  final Function onError;

  VoteButton({@required this.postOrComment, this.isLike = true, this.onError});

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
        onPressed: () async {
          // TODO: VOTE
          // - call to API
          // - update post or comment vote count
          // - setstate to re-render
          // print('TODO: VOTE');
          try {
            final ret = Api.instance.postVote(widget.postOrComment.idx, widget.isLike ? 'Y' : 'N');
            print("Vote result ====>> $ret");
          } catch (e) {
            if (widget.onError != null) widget.onError(e);
          }
        },
      ),
    );
  }
}
