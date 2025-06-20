import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylibraryapp/modules/home/presenter/provider/home_provider.dart';
import 'package:mylibraryapp/modules/library/presenter/provider/library_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/common_widgets/custom_animated_button.dart';
import '../../../../core/widgets/common_widgets/custom_text.dart';
import '../../../../core/widgets/common_widgets/custom_text_field.dart';
import '../../../authentication/presenter/provider/auth_provider.dart';

class AddLibraryView extends StatefulWidget {
  const AddLibraryView({super.key});

  @override
  State<AddLibraryView> createState() => _AddLibraryViewState();
}

class _AddLibraryViewState extends State<AddLibraryView> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        title: CustomText(text:AppStrings.addLibrary,fontWeight: FontWeight.bold,color: AppColors.white),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
          child: Consumer3<AuthProvider,LibraryProvider,HomeProvider>(
              builder: (context,authProvider,libraryProvider,homeProvider,child) {
                return SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                         CustomTextField(
                           hintText: AppStrings.ownerName,
                           controller: TextEditingController(text: homeProvider.userProfileData["name"]),
                           readOnly: true,
                         ),

                        SizedBox(height: 20.h,),
                         CustomTextField(hintText: AppStrings.mobileNumber,controller: authProvider.mobileNumberController,
                         validator: (value) => authProvider.validateMobile(value),
                           keyboardType: TextInputType.number,
                         ),


                        SizedBox(height: 20.h,),
                          CustomTextField(hintText: AppStrings.libraryName,controller: authProvider.libraryNameController,
                           validator: (value) => authProvider.validateNotEmpty(value),
                          ),

                        SizedBox(height: 20.h,),
                          CustomTextField(hintText: AppStrings.monthlyCharges,controller: authProvider.libraryChargesController,
                            validator: (value) => authProvider.validateNotEmpty(value),
                            keyboardType: TextInputType.number,

                          ),
                        SizedBox(height: 20.h,),
                          CustomTextField(hintText: AppStrings.availableSeats,controller: authProvider.totalSeatController,
                            validator: (value) => authProvider.validateNotEmpty(value),
                            keyboardType: TextInputType.number,

                          ),

                        SizedBox(height: 20.h,),
                        CustomTextField(
                          hintText: AppStrings.libraryAddress,controller: authProvider.libraryAddressController,
                        ),

                        SizedBox(height: 50.h,),

                          SizedBox(
                          width: 1.sw,
                          child: CustomAnimatedButton(
                                  isLoading: authProvider.isLoading,
                              insidePadding: EdgeInsets.symmetric(vertical: 12.h),
                              onTap: () async{
                                  if(_formKey.currentState!.validate()){
                                    await authProvider.insertLibraryData(
                                         libraryProvider: libraryProvider,
                                         ownerName: homeProvider.userProfileData["name"],
                                    );
                                    await libraryProvider.fetchLibraryData();
                                  }
                              },
                              text: AppStrings.addLibrary
                          ),
                        ),

                          SizedBox(height: 30.h,),

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
