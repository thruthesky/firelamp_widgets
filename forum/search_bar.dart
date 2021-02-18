import 'dart:async';

import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SearchBar extends StatefulWidget {
  SearchBar({
    @required this.display,
    @required this.categories,
    @required this.onCategoryChange,
    @required this.onSearch,
    @required this.onCancel,
    this.defaultValue = '',
    this.searchOnInputChange = true,
  });
  final bool display;
  // final String category;
  final String categories;
  final Function onCategoryChange;
  final Function onSearch;
  final Function onCancel;
  final String defaultValue;

  /// When `true`, search will work everytime the text input changes.
  /// If `false`, the user must click the search icon button to search.
  final bool searchOnInputChange;

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
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.display == false
        ? SizedBox.shrink()
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.all(Space.xs),
                child: TextField(
                  autofocus: false,
                  onChanged: widget.searchOnInputChange
                      ? (value) => input.add(value)
                      : (value) => searchKey = value,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: Icon(Icons.close, color: Colors.redAccent),
                      onPressed: widget.onCancel,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: Space.xxs),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => widget.onSearch(searchKey),
                    ),
                  ),
                ),
              ),
              DropdownButton<String>(
                isDense: true,
                value: widget.defaultValue.isNotEmpty
                    ? widget.defaultValue
                    : selected ?? widget.categories.split(',').first,
                items: widget.categories.split(',').map((cat) {
                  return DropdownMenuItem<String>(value: cat, child: Text('$cat'));
                }).toList(),
                onChanged: (selectedCat) {
                  if (selected == selectedCat) return;
                  setState(() => selected = selectedCat);
                  widget.onCategoryChange(selected);
                },
              ),
            ],
          );
  }
}
