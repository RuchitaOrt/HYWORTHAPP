import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hyworth_land_survey/Screens/login_screen.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/Utils/commonimages.dart';
import 'package:hyworth_land_survey/main.dart';
import 'package:hyworth_land_survey/widgets/LogoutConfirmationSheet.dart';
import 'package:hyworth_land_survey/widgets/createSlideFromLeftRoute.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isbackVisible;
  final PreferredSizeWidget? bottom;
  final bool isCloseIconVisible;
  final bool islogout;

  const CommonAppBar({
    Key? key,
    required this.title,
    this.isbackVisible = true,
    this.bottom,
    this.isCloseIconVisible = false,
    this.islogout = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CommonColors.white,
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back button
          isbackVisible
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: CommonColors.blacklight),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : Container(),

          // Title and optional stepTitle
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.mulish(
                      fontWeight: FontWeight.w800, // ExtraBold
                      color: CommonColors.blackshade,
                      fontSize: 22,
                    )),
              ],
            ),
          ),
          Icon(
            Icons.sync,
            color: CommonColors.blue,
          ),
          SizedBox(
            width: 10,
          ),
          isCloseIconVisible
              ? GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: SvgPicture.asset(
                    CommonImagePath.close,
                    height: 24,
                    width: 24,
                  ),
                )
              : Container(),
          islogout
              ? GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false, // user must tap a button
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(t(context, 'logout')), // optional title
                          content: Text(t(context,
                              'are_you_sure_logout')), // optional content
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                  t(context, 'cancel')), // Use localization
                            ),
                            ElevatedButton(
                              onPressed: () {
                                //  Navigator.of(context)
                                //                                           .push(
                                //                                     createSlideFromBottomRoute(
                                //                                       LoginScreen(),
                                //                                     ),
                                //                                   );
                                Navigator.push(
                                  routeGlobalKey.currentContext!,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoginScreen()), // Open Search Screen
                                );
                              },
                              child: Text(
                                  t(context, 'logout')), // Use localization
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.logout,
                    color: CommonColors.blue,
                  ),
                )
              : Container(),
        ],
      ),

      bottom: bottom, // ✅ Forward to AppBar
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
