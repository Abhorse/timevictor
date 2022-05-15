import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/widgets/platform_dropdown.dart';

class PlatformAddressDropdown extends StatelessWidget {
  List<String> _getAllStates () {
    return kStatesList;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: Text('Your State', style: TextStyle(fontSize: 15.0),)),
            Expanded(
              flex: 3,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: PlatformDropdown(
                    items: _getAllStates(),
                    defaultItem: kDefaultState,
                    onchange: (value) {
                      print(value);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: Text('Your City', style: TextStyle(fontSize: 15.0),)),
            Expanded(
              flex: 2,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: PlatformDropdown(
                    items: ['New Delhi', 'Mumbai', 'MP'],
                    defaultItem: 'MP',
                    onchange: (value) {
                      print(value);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

}
