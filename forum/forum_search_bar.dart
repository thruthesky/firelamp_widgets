import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ForumSearchBar extends StatefulWidget {
  final Function onSearch;
  final Function onCancel;

  ForumSearchBar({@required this.onSearch, this.onCancel});

  @override
  _ForumSearchBarState createState() => _ForumSearchBarState();
}

class _ForumSearchBarState extends State<ForumSearchBar> {
  PublishSubject<String> input = PublishSubject();
  StreamSubscription subscription;
  String searchKey;

  @override
  void initState() {
    super.initState();
    subscription =
        input.debounceTime(Duration(milliseconds: 500)).distinct((a, b) => a == b).listen((value) {
      searchKey = value;
      widget.onSearch(value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      /// todo: create definition inside `firelamp_widgets`
      padding: EdgeInsets.all(14),
      child: TextField(
        autofocus: false,
        onChanged: (value) => input.add(value),
        // onFieldSubmitted: widget.onSearch,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            icon: Icon(Icons.close, color: Colors.redAccent),
            onPressed: widget.onCancel,
          ),
          filled: true,
          fillColor: Colors.white,

          /// todo: create definition inside `firelamp_widgets`
          contentPadding: EdgeInsets.symmetric(horizontal: 18),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () => widget.onSearch(searchKey),
          ),
        ),
      ),
    );
  }
}
