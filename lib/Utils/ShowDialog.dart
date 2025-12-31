  import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyworth_land_survey/Screens/login_screen.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';

   Future<void> showLoadingDialog(BuildContext context, GlobalKey key,
      {String message = "Loading, please wait...",
      bool setForLightScreen = false}) async {
    Future.delayed(
      Duration(microseconds: 300),
      () {
        showLoadingDialogWithDelay(context, key, message, setForLightScreen);
      },
    );
  }
     Future<void> showLoadingDialogWithDelay(BuildContext context,
      GlobalKey key, String message, bool setForLightScreen) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Material(
            key: key,
            type: MaterialType.transparency,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  CircularProgressIndicator()
                SpinKitCircle(
                    color: setForLightScreen ? Colors.black : Colors.white),
                SizedBox(height: 15),
                Text(message,
                    style: TextStyle(
                        color: setForLightScreen ? Colors.black : Colors.white))
              ],
            )),
          );
        });
  }
Future<bool> showConfirmDialog(BuildContext context,
      String dialogTitle, String dialogMessage, Function() onyes) async {
    bool yesNo = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: CommonColors.white,
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  child: Text(
                    '$dialogMessage',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CommonColors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
          content: Container(
            height: 80,
            //width: double.infinity-10.0,
            //  color: customcolor.greybackground1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0)),
            ),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ignore: deprecated_member_use
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0.0),
                      child: ElevatedButton(
                       
                         style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                             
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(15.0)) ),
                        // onPressed: onyes,
                        onPressed: () async {
  await onyes();                 // do your work
  Navigator.of(context).pop(true); 
},

                        // shape: new RoundedRectangleBorder(
                        //     borderRadius: new BorderRadius.circular(15.0)),
                        // color: Colors.white,
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: CommonColors.blue,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                    // ignore: deprecated_member_use
                    Padding(
                       padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0.0),
                      child: ElevatedButton(
                        //padding: EdgeInsets.fromLTRB(60.0, 10.0, 60.0, 10.0),
                       
                          style: ElevatedButton.styleFrom(
                                backgroundColor: CommonColors.blue,
                               
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(15.0)) ),
                        // shape: new RoundedRectangleBorder(
                        //     borderRadius: new BorderRadius.circular(15.0)),
                        // color: customcolor.appbarcolor,
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    return yesNo;
  }
    unAthorizedTokenErrorDialog(BuildContext context, {String? message}) {

  

    Widget okButton = ElevatedButton(
        child: Text("OK"),
        onPressed: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => LoginScreen()),
  );
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hyworth Land Survey"),
      content: Text(message!),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

   void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor:CommonColors.blue,
        backgroundColor: Colors.white,
        fontSize: 14.0);
  }