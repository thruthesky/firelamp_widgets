import 'dart:async';

import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/widgets/popup_button.dart';
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
    this.defaultCategoryValue = '',
    this.defaultSearchKeyValue = '',
    this.searchOnInputChange = true,
  });
  final bool display;
  final String categories;
  final Function onCategoryChange;
  final Function onSearch;
  final Function onCancel;
  final String defaultCategoryValue;
  final String defaultSearchKeyValue;

  /// When `true`, search will work everytime the text input changes.
  /// If `false`, the user must click the search icon button to search.
  final bool searchOnInputChange;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _editingController;

  String selected = '';
  PublishSubject<String> input = PublishSubject();
  StreamSubscription subscription;
  String searchKey;

  @override
  void initState() {
    super.initState();

    _editingController = TextEditingController(text: widget.defaultSearchKeyValue);
    subscription =
        input.debounceTime(Duration(milliseconds: 500)).distinct((a, b) => a == b).listen((value) {
      searchKey = value;
      if (widget.onSearch != null) widget.onSearch(value);
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
        : Padding(
            padding: EdgeInsets.only(top: Space.xs, bottom: Space.xs),
            child: Row(
              children: [
                Container(
                  width: 40,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.redAccent),
                    onPressed: widget.onCancel,
                  ),
                ),
                Flexible(
                  child: TextField(
                    autofocus: false,
                    controller: _editingController,
                    onChanged: widget.searchOnInputChange
                        ? (value) => input.add(value)
                        : (value) => searchKey = value,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: Space.sm),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          widget.onSearch(searchKey);
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: Space.xsm),
                  constraints: BoxConstraints(minWidth: 50),
                  child: Text(
                    '${selected.isNotEmpty ? selected : widget.defaultCategoryValue.isNotEmpty ? widget.defaultCategoryValue : widget.categories.split(',').first}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                PopUpButton(
                  items: [
                    for (final category in widget.categories.split(','))
                      PopupMenuItem(
                        child: Text('$category'),
                        value: category,
                        textStyle: selected == category
                            ? TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700)
                            : null,
                      )
                  ],
                  onSelected: (selectedCat) {
                    if (selected == selectedCat) return;
                    setState(() => selected = selectedCat);
                    widget.onCategoryChange(selected);
                  },
                ),
              ],
            ),
          );
  }
}
