import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylibraryapp/core/constants/app_colors.dart';
import 'package:mylibraryapp/core/constants/app_strings.dart';
import 'package:mylibraryapp/core/widgets/common_widgets/custom_animated_button.dart';
import 'package:mylibraryapp/modules/library/presenter/provider/library_provider.dart';
import '../../../../core/widgets/common_widgets/custom_text.dart';
import '../../../../core/widgets/common_widgets/custom_text_field.dart';
import '../provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AddDetailsView extends StatefulWidget {
  const AddDetailsView({super.key});

  @override
  State<AddDetailsView> createState() => _AddDetailsViewState();
}

class _AddDetailsViewState extends State<AddDetailsView> {
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
                        SizedBox(height: 50.h,),

                        CustomText(
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          text: "Fill Details",
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                          color: AppColors.primaryRed,
                        ),
                        SizedBox(height: 40.h,),
                        CustomTextField(hintText: AppStrings.enterEmail,controller: authProvider.emailController,
                          validator: (value) => authProvider.validateEmail(value),
                        ),

                        SizedBox(height: 20.h,),
                        CustomTextField(
                          hintText: AppStrings.pleaseSelect,
                          controller: authProvider.roleController,
                          suffixIcon: PopupMenuButton<String>(
                            icon: Icon(Icons.arrow_drop_down),
                            onSelected: (String value) {
                              if(value == "1"){
                                authProvider.isOwner = true;
                                authProvider.roleController.text = AppStrings.libraryOwner;
                              }else{
                                authProvider.isOwner = false;
                                authProvider.roleController.text = AppStrings.student;
                              }
                              authProvider.update();
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: "1",
                                child: CustomText(text: AppStrings.libraryOwner,fontSize: 13.sp,),
                              ),
                              PopupMenuItem(
                                value:"2",
                                child: CustomText(text: AppStrings.student,fontSize: 13.sp,),
                              ),
                            ],
                          ),
                          validator: (value) => authProvider.validateNotEmpty(value),
                        ),

                        SizedBox(height: 20.h,),
                        CustomTextField(hintText: authProvider.isOwner ? AppStrings.ownerName : AppStrings.studentName,controller: authProvider.nameController,
                          validator: (value) => authProvider.validateNotEmpty(value),
                        ),

                        SizedBox(height: 20.h,),
                        CustomTextField(hintText: AppStrings.mobileNumber,controller: authProvider.mobileNumberController,
                          validator: (value) => authProvider.validateMobile(value),
                        ),

                        if(authProvider.isOwner) ...[
                          SizedBox(height: 20.h,),
                          CustomTextField(hintText: AppStrings.libraryName,controller: authProvider.libraryNameController,
                            validator: (value) => authProvider.validateNotEmpty(value),),

                          SizedBox(height: 20.h,),
                          CustomTextField(hintText: AppStrings.monthlyCharges,controller: authProvider.libraryChargesController,
                            validator: (value) => authProvider.validateNotEmpty(value),),
                          SizedBox(height: 20.h,),
                          CustomTextField(hintText: AppStrings.availableSeats,controller: authProvider.totalSeatController,
                            validator: (value) => authProvider.validateNotEmpty(value),),

                          SizedBox(height: 20.h,),
                          CustomTextField(hintText: AppStrings.fillLibraryAddress,controller: authProvider.libraryAddressController,),

                        ],
                        SizedBox(height: 30.h,),

                        SizedBox(
                          width: 1.sw,
                          child: CustomAnimatedButton(
                            isLoading: authProvider.isLoading,
                              insidePadding: EdgeInsets.symmetric(vertical: 12.h),
                              onTap: () async{
                                final libraryProvider = Provider.of<LibraryProvider>(context,listen: false);
                                if(_formKey.currentState!.validate()){
                                  await authProvider.insertUserProfileData();
                                  await authProvider.insertLibraryData(
                                      libraryProvider: libraryProvider,
                                      ownerName: authProvider.nameController.text
                                  );
                                }
                              },
                              text: "Continue"
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
