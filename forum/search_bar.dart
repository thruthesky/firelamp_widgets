import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// class SearchBar extends StatefulWidget {
//   final Function onSearch;
//   final Function onCancel;

//   SearchBar({@required this.onSearch, this.onCancel});

//   @override
//   _SearchBarState createState() => _SearchBarState();
// }

// class _SearchBarState extends State<SearchBar> {
//   PublishSubject<String> input = PublishSubject();
//   StreamSubscription subscription;
//   String searchKey;

//   @override
//   void initState() {
//     super.initState();
//     subscription =
//         input.debounceTime(Duration(milliseconds: 500)).distinct((a, b) => a == b).listen((value) {
//       searchKey = value;
//       widget.onSearch(value);
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     subscription.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       /// todo: create definition inside `firelamp_widgets`
//       padding: EdgeInsets.all(14),
//       child: TextField(
//         autofocus: false,
//         onChanged: (value) => input.add(value),
//         // onFieldSubmitted: widget.onSearch,
//         decoration: InputDecoration(
//           prefixIcon: IconButton(
//             icon: Icon(Icons.close, color: Colors.redAccent),
//             onPressed: widget.onCancel,
//           ),
//           filled: true,
//           fillColor: Colors.white,

//           /// todo: create definition inside `firelamp_widgets`
//           contentPadding: EdgeInsets.symmetric(horizontal: 18),
//           border: OutlineInputBorder(
//             borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
//           ),
//           suffixIcon: IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () => widget.onSearch(searchKey),
//           ),
//         ),
//       ),
//     );
//   }
// }

class SearchBar extends StatefulWidget {
  SearchBar({
    @required this.display,
    @required this.category,
    @required this.categories,
    @required this.onCategoryChange,
    @required this.onSearch,
    @required this.onCancel,
  });
  final bool display;
  final String category;
  final String categories;
  final Function onCategoryChange;
  final Function onSearch;
  final Function onCancel;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String selected;
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
    if (widget.display == false) return SizedBox.shrink();
    return Column(
      children: [
        DropdownButton<String>(
          value: widget.category,
          items: widget.categories.split(',').map((cat) {
            return DropdownMenuItem<String>(
              value: cat,
              child: Text('$cat'),
            );
          }).toList(),
          onChanged: (selectedCat) {
            if (selected == selectedCat) return;
            setState(() => selected = selectedCat);
            widget.onCategoryChange(selected);
          },
        ),
        // ForumSearchBar(onSearch: widget.onSearch, onCancel: widget.onCancel),
        Padding(
            padding: EdgeInsets.all(10),
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
            ))
      ],
    );
  }
}
