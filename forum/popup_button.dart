import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnSelectedFunction(dynamic selected);

class PopUpButton extends StatelessWidget {
  final OnSelectedFunction onSelected;
  final List<PopupMenuItem> items;
  final Icon icon;

  PopUpButton({
    @required this.items,
    @required this.onSelected,
    this.icon = const Icon(Icons.more_vert),
  }) : assert(icon != null);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PopupMenuButton<dynamic>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      itemBuilder: (context) => items
      // [
      //   PopupMenuItem(
      //     child: Row(children: [
      //       Icon(Icons.edit, size: Space.sm, color: Colors.greenAccent),
      //       SizedBox(width: Space.xs),
      //       Text('Edit')
      //     ]),
      //     value: 'edit',
      //   ),
      //   PopupMenuItem(
      //     child: Row(children: [
      //       Icon(Icons.delete, size: Space.sm, color: Colors.redAccent),
      //       SizedBox(width: Space.xs),
      //       Text('Delete')
      //     ]),
      //     value: 'delete',
      //   )
      // ]
      ,
      icon: icon,
      offset: Offset(10.0, 10.0),
      onSelected: onSelected,
    ));
  }
}
