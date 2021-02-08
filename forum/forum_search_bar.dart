import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForumSearchBar extends StatefulWidget {
  final Function onSearch;
  final Function onCancel;

  ForumSearchBar({@required this.onSearch, this.onCancel});

  @override
  _ForumSearchBarState createState() => _ForumSearchBarState();
}

class _ForumSearchBarState extends State<ForumSearchBar> {
  final searchKey = new TextEditingController();
  Timer debounce;

  _onSearchChanged() {
    if (debounce?.isActive ?? false) debounce.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      print('searchChanged');
      widget.onSearch(searchKey.text);
    });
  }

  @override
  void initState() {
    super.initState();
    searchKey.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchKey.removeListener(_onSearchChanged);
    searchKey.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      /// todo: create definition inside `firelamp_widgets`
      padding: EdgeInsets.all(14),
      child: TextFormField(
        controller: searchKey,
        onFieldSubmitted: widget.onSearch,
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
            onPressed: () {
              widget.onSearch(searchKey.text);
            },
          ),
        ),
      ),
    );
  }
}
