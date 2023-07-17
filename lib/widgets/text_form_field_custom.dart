import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_color.dart';
import '../utils/constants_style.dart';

class TextFormFiledCustom extends StatelessWidget {
  TextFormFiledCustom(
      {Key? key,
      required this.controller,
      required this.validationError,
      required this.title})
      : super(key: key);
  TextEditingController controller;
  String validationError;
  String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 64,
          width: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.lightGreyColor,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: TextFormField(
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 16)),
              controller: controller,
              style: dialogTimerTextStyle,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(2),
                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
              ],
              onChanged: (value) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return validationError;
                } else {
                  return null;
                }
              }),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          title,
          style: dialogContainTextStyle,
        )
      ],
    );
  }
}
