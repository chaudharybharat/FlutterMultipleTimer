import 'package:flutter/cupertino.dart';

import '../utils/constants_style.dart';

class DotCustomWidget extends StatelessWidget {
  const DotCustomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        ":",
        style: dotTextStyle,
      ),
    );
  }
}
