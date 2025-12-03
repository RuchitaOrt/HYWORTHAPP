
import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Utils/CommonStyles.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';



class TextWithAsterisk extends StatelessWidget {
  final String text;
  final bool isAstrick;

   const TextWithAsterisk({Key? key, required this.text, this.isAstrick=true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: CommonStyles.textFieldHeading,
        children:  [
        // TextSpan(
        //     text:isAstrick? ' *':'',
        //     style: TextStyle(
        //       color: CommonColors.marron,
        //     ),
        //   ),
        ],
      ),
    );
  }
}
