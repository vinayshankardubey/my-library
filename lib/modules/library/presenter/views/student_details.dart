import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mylibraryapp/core/constants/app_colors.dart';
import 'package:mylibraryapp/core/widgets/common_widgets/custom_text.dart';
import 'package:mylibraryapp/core/widgets/common_widgets/custom_text_field.dart';
import 'package:mylibraryapp/modules/library/presenter/provider/library_provider.dart';
import 'package:provider/provider.dart';
import '../../../home/presenter/widgets/custom_user_info_card.dart';


class StudentDetails extends StatefulWidget {
  final String libraryId;
  const StudentDetails({
    super.key,
    required this.libraryId
  });

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LibraryProvider>(context,listen: false).init(libraryId: widget.libraryId);

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<LibraryProvider>(
        builder: (context,libraryProvider,child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h,),

                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 10.w),
                  child: CustomTextField(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search Student",
                    onChanged: (searchQuery)=> libraryProvider.searchStudent(
                        query: searchQuery,
                        libraryId: widget.libraryId
                    )
                ),),

                SizedBox(height: 10.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                           text: "Total Student : ${libraryProvider.studentsData.length}",
                           fontSize: 12.sp,
                      ),

                    // PopupMenuButton<String>(
                    //   onSelected: (value) {
                    //     if (value == 'today') {
                    //     } else if (value == 'month') {
                    //     }
                    //   },
                    //   itemBuilder: (BuildContext context) => [
                    //     PopupMenuItem(
                    //       value: 'today',
                    //       child: CustomText(text:'Today',fontSize: 14.sp),
                    //     ),
                    //     PopupMenuItem(
                    //       value: 'month',
                    //       child: CustomText(text:'last month',fontSize: 14.sp,),
                    //     ),
                    //   ],
                    //   child: Chip(label: Icon(Icons.filter_list),
                    //   )
                    //   ),
                  ],),
                ),
                SizedBox(height: 10.h,),
                libraryProvider.studentsData.isNotEmpty ?
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: libraryProvider.studentsData.length,
                  separatorBuilder: (context,index) => SizedBox(height: 5.h,),
                    itemBuilder: (context,index){
                    return Slidable(
                        key:  ValueKey(index),
                      startActionPane: ActionPane(
                      motion: const ScrollMotion(),

                      children:  [
                        SizedBox(width: 3.w,),
                        CustomSlidableAction(
                          borderRadius: BorderRadius.circular(16.r),
                          onPressed: (context) async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Row(
                                  children: [
                                    Icon(Icons.warning_amber_rounded, color: Colors.redAccent,size: 25.r,),
                                    SizedBox(width: 10),
                                    CustomText(
                                      text: "Confirm Deletion",
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.black,
                                    ),
                                  ],
                                ),
                                content: CustomText(
                                  text: "Do you really want to delete this student?",
                                  maxLines: 3,
                                  fontSize: 16.sp,
                                  color: AppColors.grey,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(false),
                                    child: CustomText(text: "Cancel",fontWeight: FontWeight.bold,color: AppColors.green),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(true),
                                    child: CustomText(text: "Delete",fontWeight: FontWeight.bold,color: AppColors.primaryRed,),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              final studentId = libraryProvider.studentsData[index]['id'];
                              await libraryProvider.deleteStudent(
                                libraryId: widget.libraryId,
                                seatId: libraryProvider.studentsData[index]['seat_id'],
                                studentId: studentId,
                              ); // your method or use notifyListeners
                            }
                          },
                          backgroundColor: AppColors.primaryRed,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                size: 32.r,
                                color: AppColors.white,
                              ),
                              SizedBox(height: 4),
                              CustomText(
                                text:'Delete',
                                  fontSize: 15.sp,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),

                      ],
                      ),
                      child: CustomUserInfoCard(
                        name: libraryProvider.studentsData[index]['name'],
                        email: libraryProvider.studentsData[index]['email'],
                        contact: libraryProvider.studentsData[index]['mobile_number'],
                        address: "",
                        role : "",
                        seatNumber: "S${libraryProvider.studentsData[index]['seat_id']}",
                      ),
                      );
                    },
            
                  )
                : Center(
                  child: CustomText(text: "No Student Found"),
                )    
              ],
            ),
          );
        }
      ),
    );
  }
}
