import 'package:dalgona/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoteButton extends StatelessWidget {
  VoteButton({@required this.postOrComment, this.isLike = true, this.onChange});

  final bool isLike;
  final dynamic postOrComment;
  final Function onChange;

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
          final re = await api.vote(postOrComment, choice);
          postOrComment.y = re.y;
          postOrComment.n = re.n;
          onChange();
        },
      ),
    );
  }
}
