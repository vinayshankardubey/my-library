import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/app_colors.dart';
import '../router/app_router.dart';

class Utils {

  static navigateBack(){
    appRouter.pop();
  }

  static navigateTo(String routeName, {Function? onReturn}) {
    appRouter.push(routeName).then((_) {
      if (onReturn != null) {
        onReturn();
      }
    });
  }

  static navigateToOffAll(String routeName){
    while(appRouter.canPop()){
      appRouter.pop();
    }
    appRouter.pushReplacement(routeName);
  }

  static navigateToWithData(String routeName,data){
    appRouter.push(routeName,extra: data);
  }

  ///This method is used for show debug Prints
  static printDebug(String msg){
    print("${DateTime.now()}  $msg");
  }


  static void showToast ({String msg = "InValid Credential"}){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryRed,
        textColor: AppColors.white,
        fontSize: 16.sp
    );
  }


}