import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForumSearchBar extends StatelessWidget {
  final Function onSearch;
  final Function onCancel;
  final TextEditingController searchKey = TextEditingController();

  ForumSearchBar({@required this.onSearch, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      /// todo: create definition inside `firelamp_widgets`
      padding: EdgeInsets.all(14),
      child: TextFormField(
        controller: searchKey,
        onFieldSubmitted: onSearch,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            icon: Icon(Icons.close, color: Colors.redAccent),
            onPressed: onCancel,
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
              onSearch(searchKey.text);
            },
          ),
        ),
      ),
    );
  }
}
