import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';
import '../../widgets/common_widgets/custom_text.dart';

class BottomSheetHelper{


  static Future<void> showSortByBottomSheet({required BuildContext ctx, required Function(String? value) onSelected}){
    final String selected = '';
   return showModalBottomSheet(
        context: ctx,
        builder:(ctx){
          return Container(
            width: 1.sw,
            padding: EdgeInsets.all(10.r),
            child : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
              CustomText(text:"SORT BY",color: AppColors.grey),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0.w,vertical: 0.h),
                  title: CustomText(text: 'Newest First',fontSize: 14.sp,fontWeight: FontWeight.bold,),
                  trailing: Radio(
                    value: "first",
                    groupValue: selected,
                    onChanged: onSelected,
                  ),
                  onTap: () {

                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0.w,vertical: 0.h),

                  title: CustomText(text:'Charge -- Low to High',fontSize: 14.sp,fontWeight: FontWeight.bold,),
                  trailing: Radio(
                    value: "low",
                    groupValue: selected,
                    onChanged:  onSelected,
                  ),
                  onTap: () {

                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0.w,vertical: 0.h),

                  title: CustomText(text: 'Charge -- High to Low',fontSize: 14.sp,fontWeight: FontWeight.bold,),
                  trailing: Radio(
                    value: "high",
                    groupValue: selected,
                    onChanged:  onSelected,
                  ),
                  onTap: () {

                  },
                ),

                SizedBox(height: 20.h,)
              ],
            )
          );
        }
    );

  }

}