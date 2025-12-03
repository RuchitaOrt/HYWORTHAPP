
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/Utils/commonimages.dart';
import 'package:hyworth_land_survey/Utils/sizeConfig.dart';

class ConfirmationSheet extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onLogout;
  final String title;
  final String firstbutton;
  final String secondButton;

 
  final String subHeading;
  
  const ConfirmationSheet({
    super.key,
    required this.onCancel,
    required this.onLogout,
    this.title = "Are you sure you want to log out?",
    required this.subHeading, required this.firstbutton, required this.secondButton, 
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child:
               GestureDetector(
                 onTap: () => Navigator.of(context).pop(),
                 child: SvgPicture.asset(
                             CommonImagePath.close,
                           
                           ),
               ),
               
            ),
          
            // const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style:  TextStyle(
                color: CommonColors.blackshade,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
         
          subHeading!=""?  Column(
              children: [
                Text(
                  subHeading,
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                    color: CommonColors.grey75,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                 const SizedBox(height: 24),
              ],
            ):Container(),
      
         Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: CommonColors.blue,),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child:  Text(firstbutton,
                        style: TextStyle(color: CommonColors.blue,)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child:  Text(secondButton,
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
