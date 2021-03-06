import 'package:flutter_app/main.dart';
import 'package:flutter_app/providers/langText.dart';
import 'package:flutter_app/themes/appTheme.dart';
import 'package:flutter_app/themes/colorManager.dart';
import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  final dynamic chips; // map or enum of Chips
  final Map<dynamic, bool> pickedChips; //map of the picked chips
  final Function valueCallBack; //callBack with the returned value
  MultiSelectChip(this.chips, this.valueCallBack, {this.pickedChips});
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<Widget> chipList;
  Map<dynamic, bool> pickedChips = {};

  @override
  Widget build(BuildContext context) {
    chipList = [];
    if (pickedChips.isEmpty && widget.pickedChips != null) pickedChips = widget.pickedChips; // happens only once

    for (var value in widget.chips) {
      bool isSelected = pickedChips[value] != null && pickedChips[value] == true;
      chipList.add(FilterChip(
        elevation: isSelected ? 5 : 0,
        //selectedColor: ColorManager().theme.filterBackgroundColor,
        //checkmarkColor: ColorManager().theme.primary[300],
        selected: isSelected ? true : false,
        label: new Text(
          LocaleText.getLocaleSelectText(MyApp.getLocale(), value.toString()),
          style: TextStyle(color: ColorManager.mYTHEME == MYTHEME.DARK ? ColorManager().theme.primary[300] : isSelected ? ColorManager().theme.primary[300] : ColorManager().theme.secondary[300]),
        ),
        //backgroundColor: ColorManager().theme.fillColor,
        shape: StadiumBorder(
            side: ColorManager.mYTHEME == MYTHEME.DARK
                ? isSelected ? BorderSide(color: ColorManager().theme.primary[300]) : BorderSide(color: ColorManager().theme.fillColor)
                : BorderSide(
                    color: ColorManager().theme.secondary[300],
                  )),
        onSelected: (bool bvalue) {
          setState(() {
            pickedChips[value] = bvalue;
            widget.valueCallBack(value, bvalue);
          });
        },
      ));
      chipList.add(SizedBox(width: 10));
    }

    return Wrap(
      direction: Axis.horizontal,
      children: chipList,
    );
  }
}

class SelectChip extends StatefulWidget {
  final dynamic chips; // map or enum of Chips
  dynamic pickedValue; //map of the picked chips
  final Function valueCallBack; //callBack with the returned value
  SelectChip(this.chips, this.valueCallBack, {this.pickedValue});
  @override
  _SelectChipState createState() => _SelectChipState();
}

class _SelectChipState extends State<SelectChip> {
  List<Widget> chipList;

  @override
  Widget build(BuildContext context) {
    chipList = [];
    for (var value in widget.chips) {
      bool isSelected = widget.pickedValue != null && widget.pickedValue == value;
      chipList.add(FilterChip(
        showCheckmark: false,
        elevation: isSelected ? 5 : 0,

        selected: isSelected ? true : false,
        label: new Text(
          LocaleText.getLocaleSelectText(MyApp.getLocale(), value.toString()),
          style: TextStyle(color: ColorManager.mYTHEME == MYTHEME.DARK ? ColorManager().theme.primary[300] : isSelected ? ColorManager().theme.primary : ColorManager().theme.secondary[300]),
        ),
        //backgroundColor: ColorManager().theme.fillColor,
        shape: StadiumBorder(
            side: ColorManager.mYTHEME == MYTHEME.DARK
                ? isSelected ? BorderSide(color: ColorManager().theme.primary[300]) : BorderSide(color: ColorManager().theme.fillColor)
                : BorderSide(
                    color: ColorManager().theme.secondary[300],
                  )),

        // shape: StadiumBorder(side: BorderSide(color: Colors.blueGrey)),
        onSelected: (bool bvalue) {
          setState(() {
            widget.pickedValue = value;
            widget.valueCallBack(value);
          });
        },
      ));
      chipList.add(SizedBox(width: 10));
    }

    return Wrap(
      direction: Axis.horizontal,
      children: chipList,
    );
  }
}
