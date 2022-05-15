import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timevictor/widgets/dropdown_widget.dart';

class PlatformDropdown extends DropdownWidget{
  PlatformDropdown({
    @required this.items,
    @required this.defaultItem,
    this.onchange,
  })  : assert(items != null),
        assert(defaultItem != null);

  final List<String> items;
  final String defaultItem;
  final Function onchange;

  @override
  Widget buildCupertinoWidget(BuildContext context)
  {
    List<Text> list = [];
    for(String currency in items){
      list.add(Text(currency.toUpperCase(), style: TextStyle(color: Colors.white),));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      }, children: list,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context)
  {
    List<DropdownMenuItem<String>> list = [];
    for(String item in items) {
      list.add(DropdownMenuItem(
        child: Text(item.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w700),),
        value: item,
      ),
      );
    }

    return  DropdownButton<String>(
      underline: Container(
        height: 0,
      ),
      value: defaultItem,
      items: list,
      onChanged: onchange,
    );
  }
}