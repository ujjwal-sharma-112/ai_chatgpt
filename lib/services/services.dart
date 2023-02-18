import 'package:ai_chatgpt/constants/constants.dart';
import 'package:ai_chatgpt/widgets/drop_down_widget.dart';
import 'package:ai_chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        backgroundColor: scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Flexible(
                  child: TextWidget(label: "Chosen Model:"),
                ),
                SizedBox(width: 10),
                Flexible(
                  flex: 2,
                  child: ModelIsDropDownWidget(
                    key: ValueKey("ModelIsDropDownWidget"),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
