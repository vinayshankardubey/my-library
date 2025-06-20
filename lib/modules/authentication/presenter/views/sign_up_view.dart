import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylibraryapp/core/constants/app_colors.dart';
import 'package:mylibraryapp/core/constants/app_strings.dart';
import 'package:mylibraryapp/core/constants/image_constant.dart';
import 'package:mylibraryapp/core/router/app_routes.dart';
import 'package:mylibraryapp/core/utils/utils.dart';
import 'package:mylibraryapp/core/widgets/common_widgets/custom_animated_button.dart';

import '../../../../core/widgets/common_widgets/custom_text.dart';
import '../../../../core/widgets/common_widgets/custom_text_field.dart';
import '../../../home/presenter/provider/home_provider.dart';
import '../provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Consumer<AuthProvider>(
              builder: (context,authProvider,child) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50.h,),
                      SizedBox(
                        height: 180.h,
                        child: Image.asset(ImageConstant.appLogoImg,fit: BoxFit.cover,),
                      ),
                  
                      CustomText(
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        text: AppStrings.signUp,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.sp,
                        color: AppColors.green,
                      ),
                      SizedBox(height: 30.h,),
                      CustomTextField(hintText: AppStrings.enterEmail,controller: authProvider.emailController,),
                  
                      SizedBox(height: 20.h,),
                      CustomTextField(hintText: AppStrings.enterPassword,controller: authProvider.passwordController),
                  
                      SizedBox(height: 10.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(text: AppStrings.alreadyHaveAccount,),
                          SizedBox(width: 5.w,),
                          InkWell(
                              onTap: (){
                                Utils.navigateToOffAll(AppRoutes.signInView);
                              },
                              child: CustomText(text: AppStrings.signIn,color: AppColors.primaryRed,fontWeight: FontWeight.bold,)),
                        ],
                      ),
                      SizedBox(height: 50.h,),
                      SizedBox(
                        width: 1.sw,
                        child: CustomAnimatedButton(
                            isLoading: authProvider.isLoading,
                            insidePadding: EdgeInsets.symmetric(vertical: 12.h),
                            onTap: () async{
                                if(authProvider.emailController.text.isNotEmpty && authProvider.passwordController.text.isNotEmpty){
                                    await authProvider.signUpWithEmailAndPassword(
                                      email: authProvider.emailController.text,
                                      password: authProvider.passwordController.text,
                                    );
                                }else{
                                  debugPrint("Something is missing");
                                }
                            },
                            text: AppStrings.signUp
                        ),
                      ),
                  

                  
                  
                    ],
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}
