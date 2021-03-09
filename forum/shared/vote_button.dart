import 'package:dalgona/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoteButton extends StatelessWidget {
  VoteButton({@required this.postOrComment, this.isLike = true, this.onChange, this.onError});

  final bool isLike;
  final dynamic postOrComment;
  final Function onChange;
  final Function onError;

  @override
  Widget build(BuildContext context) {
    String choice;
    String text;
    if (isLike) {
      choice = 'Y';
      text = "Like" + (postOrComment.y > 0 ? "(${postOrComment.y})" : "");
    } else {
      choice = 'N';
      text = "Dislike" + (postOrComment.n > 0 ? "(${postOrComment.n})" : "");
    }

    return Container(
      child: TextButton(
        child: Text(text),
        onPressed: () async {
          try {
            final re = await api.vote(postOrComment, choice);
            postOrComment.y = re.y;
            postOrComment.n = re.n;
            if (onChange != null) onChange();
          } catch (e) {
            if (onError != null) onError(e);
          }
        },
      ),
    );
  }
}
