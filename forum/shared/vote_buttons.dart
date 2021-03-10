import 'package:dalgona/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoteButtons extends StatefulWidget {
  VoteButtons({
    @required this.postOrComment,
    this.showLike = true,
    this.showDislike,
    this.onError,
  });

  final bool showLike;
  final bool showDislike;
  final dynamic postOrComment;
  final Function onError;

  @override
  _VoteButtonsState createState() => _VoteButtonsState();
}

class _VoteButtonsState extends State<VoteButtons> {
  onVoteSuccess(dynamic re) {
    widget.postOrComment.y = re.y;
    widget.postOrComment.n = re.n;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String likeText = "Like" + (widget.postOrComment.y > 0 ? "(${widget.postOrComment.y})" : "");
    String dislikeText =
        "Dislike" + (widget.postOrComment.n > 0 ? "(${widget.postOrComment.n})" : "");

    return widget.showLike && widget.showDislike
        ? Container(
            child: Row(
            children: [
              TextButton(
                child: Text(likeText),
                onPressed: () async {
                  try {
                    final re = await api.vote(widget.postOrComment, 'Y');
                    onVoteSuccess(re);
                    // if (widget.onChange != null) widget.onChange();
                  } catch (e) {
                    if (widget.onError != null) widget.onError(e);
                  }
                },
              ),
              TextButton(
                child: Text(dislikeText),
                onPressed: () async {
                  try {
                    final re = await api.vote(widget.postOrComment, 'N');
                    onVoteSuccess(re);
                    // if (widget.onChange != null) widget.onChange();
                  } catch (e) {
                    if (widget.onError != null) widget.onError(e);
                  }
                },
              ),
            ],
          ))
        : SizedBox.shrink();
  }
}
