import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForumSearchBar extends StatelessWidget {
  final Function onSearch;
  final TextEditingController searchKey = TextEditingController();

  ForumSearchBar({@required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      /// todo: create definition inside `firelamp_widgets`
      padding: EdgeInsets.all(14),
      child: TextFormField(
        controller: searchKey,
        onFieldSubmitted: onSearch,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          suffixIcon: Icon(Icons.search),
          /// todo: create definition inside `firelamp_widgets`
          contentPadding: EdgeInsets.symmetric(horizontal: 18),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
