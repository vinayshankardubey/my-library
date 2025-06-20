import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylibraryapp/core/constants/app_colors.dart';
import 'package:mylibraryapp/core/widgets/common_widgets/custom_text.dart';
import 'package:mylibraryapp/modules/home/presenter/provider/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/common_widgets/custom_animated_button.dart';

class ProfileView extends StatefulWidget {
  final String userName;
  final String email;
  final String phoneNumber;

  const ProfileView({
    super.key,
    this.userName = 'Shivam Kumar',
    this.email = 'shivam@example.com',
    this.phoneNumber = '+91 9876543210',
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        title: CustomText(
          text: AppStrings.profile,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        centerTitle: true,
      ),
      body: Consumer<HomeProvider>(
        builder: (context,homeProvider,child) {
          return ListView(
            padding: EdgeInsets.all(20.r),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryRed,
                      child:  Icon(Icons.person, size: 50.r, color: AppColors.white),
                    ),
                    SizedBox(height: 15.h),
                    CustomText(
                     text: homeProvider.userProfileData["name"],
                      fontSize: 16.sp,
                        fontWeight: FontWeight.bold
                    ),
                    CustomText( text: homeProvider.userProfileData["email"], color: AppColors.grey,fontSize: 12.sp,)
                  ],
                ),
              ),
              SizedBox(height: 15.h),

              // SECTION: Account Info
              _buildSectionTitle(AppStrings.accountInformation),
              _buildTile(Icons.phone, AppStrings.phoneNumber, homeProvider.userProfileData["mobile_number"]),
              _buildTile(Icons.email, AppStrings.email, homeProvider.userProfileData["email"]),

              // SECTION: App Settings
              const SizedBox(height: 25),
              _buildSectionTitle(AppStrings.appSettings),
              _buildSimpleTile(Icons.notifications, AppStrings.notifications, () {}),
              _buildSimpleTile(Icons.lock, AppStrings.changePassword, () {}),


              // SECTION: Legal
              const SizedBox(height: 25),
              _buildSectionTitle(AppStrings.legalAndSupport),
              _buildSimpleTile(Icons.privacy_tip, AppStrings.privacyPolicy, () {}),
              _buildSimpleTile(Icons.description, AppStrings.termsAndConditions, () {}),
              _buildSimpleTile(Icons.help, AppStrings.helpSupport, () {}),
              _buildSimpleTile(Icons.feedback, AppStrings.sendFeedback, () {}),

              // Logout Button
              SizedBox(height: 30),
              CustomAnimatedButton(
                preWidget: Icon(Icons.logout,color: AppColors.white,),
                  insidePadding: EdgeInsets.symmetric(vertical: 10.h),
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(

                            title: Center(child: CustomText(text: AppStrings.areYouSure,fontWeight: FontWeight.bold,)),
                            content: Icon(Icons.info,size: 60.r,color: AppColors.primaryRed,),
                            actions: [
                              CustomAnimatedButton(
                                  borderRadius: 10.r,
                                  color: AppColors.green.withOpacity(.7),
                                  onTap: (){
                                    Utils.navigateBack();
                                  },
                                  text: AppStrings.cancel),
                              CustomAnimatedButton(
                                  borderRadius: 10.r,

                                  color: AppColors.primaryRed,
                                  onTap: () async{
                                    await Supabase.instance.client.auth.signOut();
                                    Utils.navigateToOffAll(AppRoutes.signInView);
                                  },
                                  text: "Logout"
                              ),
                            ],
                          );
                        }
                    );
                  },
                  text: AppStrings.logOut
              )

            ],
          );
        }
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: title,
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryRed,
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryRed),
      title: CustomText(text: title, fontSize: 14.sp,),
      subtitle: CustomText(text: value , fontSize: 12.sp,),
    );
  }

  Widget _buildSimpleTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon,color: AppColors.primaryRed,),
      title: CustomText(text:title,fontSize: 14.sp,),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
      onTap: onTap,
    );
  }
}
