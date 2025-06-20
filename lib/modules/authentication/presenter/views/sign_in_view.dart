import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylibraryapp/core/constants/app_colors.dart';
import 'package:mylibraryapp/core/constants/app_strings.dart';
import 'package:mylibraryapp/core/constants/image_constant.dart';
import 'package:mylibraryapp/core/router/app_routes.dart';
import 'package:mylibraryapp/core/utils/utils.dart';
import 'package:mylibraryapp/core/widgets/common_widgets/custom_animated_button.dart';
import 'package:mylibraryapp/modules/home/presenter/provider/home_provider.dart';

import '../../../../core/widgets/common_widgets/custom_text.dart';
import '../../../../core/widgets/common_widgets/custom_text_field.dart';
import '../provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Consumer<AuthProvider>(
            builder: (context,authProvider,child) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30.h,),
                      SizedBox(
                        height: 200.h,
                        child: Image.asset(ImageConstant.appLogoImg,fit: BoxFit.cover,),
                      ),

                      CustomText(
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        text: AppStrings.welcomeToMyLibrary,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.sp,
                        color: AppColors.green,
                      ),
                      SizedBox(height: 50,),
                      CustomTextField(hintText: AppStrings.enterEmail,controller: authProvider.emailController,
                       validator: (value)=> authProvider.validateEmail(value),
                      ),

                      SizedBox(height: 20.h,),
                      CustomTextField(hintText: AppStrings.enterPassword,controller: authProvider.passwordController,
                          validator: (value)=> authProvider.validateNotEmpty(value),
                      ),

                      SizedBox(height: 10.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(text: AppStrings.dontHaveAccount,),
                          SizedBox(width: 5.w,),
                          InkWell(
                             onTap: (){
                               Utils.navigateTo(AppRoutes.signUpView);
                             },
                              child: CustomText(text: AppStrings.signUp,color: AppColors.primaryRed,fontWeight: FontWeight.bold,)),
                        ],
                      ),
                      SizedBox(height: 40.h,),
                     SizedBox(
                       width: 1.sw,
                       child: CustomAnimatedButton(
                         isLoading: authProvider.isLoading,
                          insidePadding: EdgeInsets.symmetric(vertical: 12.h),
                           onTap: () async{
                            if(_formKey.currentState!.validate()){
                             await  authProvider.signInWithEmailAndPassword(
                                  email: authProvider.emailController.text,
                                  password: authProvider.passwordController.text,
                              );
                             authProvider.clearControllers();
                            }else{
                              debugPrint("Something is missing");
                            }
                           },
                           text: AppStrings.signIn
                       ),
                     )
                    ],
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
