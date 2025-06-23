import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mylibraryapp/modules/library/presenter/provider/library_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slide_action/slide_action.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/widgets/common_widgets/custom_text.dart';
import '../../../../../core/widgets/common_widgets/custom_text_field.dart';
import '../../../../../models/seat_booking_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../authentication/presenter/provider/auth_provider.dart';

class LibraryDetails extends StatefulWidget {
  final String name;
  final String libraryId;
  final String imageUrl;
  final String address;
  final String contact;
  final String timing;
  final String availableSeats;
  final String monthlyCharges;
  final String description;
  const LibraryDetails({
    super.key,
    required this.name,
    required this.libraryId,
    required this.imageUrl,
    required this.address,
    required this.contact,
    required this.timing,
    required this.availableSeats,
    required this.monthlyCharges,
    required this.description
  });

  @override
  State<LibraryDetails> createState() => _LibraryDetailsState();
}

class _LibraryDetailsState extends State<LibraryDetails> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LibraryProvider>(context,listen: false).fetchAllSeats(libraryId: widget.libraryId);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(20.r),
        child: Consumer<LibraryProvider>(
            builder: (context,libraryProvider,child) {
              int rowCount = (libraryProvider.totalSeats.length / 4).ceil();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText( text:"Total Seats : ${widget.availableSeats}", textStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold)),
                  SizedBox(height: 15.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: rowCount,
                    itemBuilder: (context, rowIndex) {
                      int startIndex = rowIndex * 4;

                      List<SeatBookingModel> rowSeats = [];
                      for (int i = 0; i < 4; i++) {
                        int seatIndex = startIndex + i;
                        if (seatIndex < libraryProvider.totalSeats.length) {
                          rowSeats.add(libraryProvider.totalSeats[seatIndex]);
                        }
                      }

                      // Split seats into left 2 and right 2
                      List<SeatBookingModel> leftSeats = rowSeats.take(2).toList();
                      List<SeatBookingModel> rightSeats = rowSeats.skip(2).toList();

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: List.generate(leftSeats.length, (i) {
                                return buildSeat( provider: libraryProvider,seat: leftSeats[i],libraryId: widget.libraryId);
                              }),
                            ),
                            Spacer(),
                            Row(
                              children: List.generate(rightSeats.length, (i) {
                                return buildSeat(seat: rightSeats[i],provider: libraryProvider,libraryId: widget.libraryId);
                              }),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 16.h),

                  CustomText(
                    text: widget.name,
                    textStyle:  TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                  ),
                  _buildRowLabelData(icon : Icons.location_on, label: widget.address),
                  _buildRowLabelData(icon : Icons.phone, label: widget.contact),
                  _buildRowLabelData(icon : Icons.money, label: "${AppStrings.rupeeSymbol} ${widget.monthlyCharges} Per month"),
                  _buildRowLabelData(icon : Icons.access_time, label: widget.timing),

                  SizedBox(height: 16.h),

                  CustomText(
                    text: "About Library",
                    textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6.h),
                  CustomText(
                    maxLines: 10,
                    text: widget.description,
                    textStyle:  TextStyle(fontSize: 15.sp),
                  ),
                  SizedBox(height: 40.h),

                ],
              );
            }
        ),
      ),

      floatingActionButton:  Consumer<LibraryProvider>(
          builder: (context,libraryProvider,child) {
            return InkWell(
              onTap: (){
                showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        title:  CustomText(text: AppStrings.confirmSeatBooking,color: AppColors.primaryRed,fontWeight: FontWeight.w500,),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 8),
                            CustomTextField(
                              hintText: "Enter Seat Number",
                              controller: libraryProvider.seatNumberController,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Utils.navigateBack(),
                            child:  CustomText(text:AppStrings.cancel,color: AppColors.primaryRed,fontWeight: FontWeight.bold,),
                          ),
                          TextButton(
                            onPressed: () async{
                              int seatNumber = int.parse(libraryProvider.seatNumberController.text.trim());
                              if( await libraryProvider.checkSeatAvailability(
                                libraryId: widget.libraryId,
                                seatId: seatNumber.toString(),
                              )){
                                SeatBookingModel seat =  SeatBookingModel(
                                    seatId: seatNumber.toString(),
                                    isBooked: false,
                                    isSelected: false
                                );

                                libraryProvider.seatNumberController.clear();
                                seat.isBooked = true;
                                seat.isSelected = false;
                                Utils.navigateBack();
                                libraryProvider.update();

                                showSeatBookingBottomSheet(
                                    context: context,
                                    seat: seat,
                                    libraryProvider: libraryProvider,libraryId: widget.libraryId,


                                );
                              }else{
                                Utils.showToast(msg: AppStrings.seatIsAlreadyBooked);
                              }

                            },
                            child:   CustomText(text:AppStrings.confirm,color: AppColors.green,fontWeight: FontWeight.bold,),
                          ),

                        ],
                      );
                    }
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryRed,
                ),
                padding: EdgeInsets.all(10.r),
                child: Icon(Icons.add,color: AppColors.white,size: 30.r,),
              ),
            );
          }
      ),
    );
  }
   ///this is used for building seat for library
  Widget buildSeat({required SeatBookingModel seat,required LibraryProvider provider,required String libraryId}) {
    Color color;
    if (seat.isBooked) {
      color = AppColors.primaryRed;
    } else if (seat.isSelected) {
      color = AppColors.green;
    } else {
      color = AppColors.lightGrey!;
    }

    return GestureDetector(
      onTap: () async{
        if (seat.isBooked) {
           await provider.checkStudentData(libraryId: libraryId,seatId: int.parse(seat.seatId)).then((_){
              showStudentDetailsBottomSheet(context: context,libraryProvider: provider);
           });
        }else {
          seat.isSelected = !seat.isSelected;
          provider.update();
          showSeatBookingBottomSheet(context: context, seat: seat,libraryProvider: provider,libraryId: libraryId);
        }
      },
      child: Container(
        width: 50.w,
        height: 50.h,
        margin: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.black.withOpacity(0.5)),
        ),
        alignment: Alignment.center,
        child: CustomText(
          text : "S${seat.seatId}",
          textStyle: TextStyle(
            color: seat.isBooked || seat.isSelected ? AppColors.white : AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  ///This is used for building row with label data
  Widget _buildRowLabelData({required IconData icon, required String label}){
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 6.w),
          CustomText(text: label),
        ],
      ),
    );
  }


  void showSeatBookingBottomSheet({
    required BuildContext context,
    required SeatBookingModel seat,
    required LibraryProvider libraryProvider,
    required String libraryId
  }) {
    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,

      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height:  350.h,
          padding: EdgeInsets.all(16.r),
          child: Consumer<AuthProvider>(
              builder: (context,authProvider,child) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomText(text: AppStrings.doYouWantToBookYourSeat,fontWeight: FontWeight.bold,color: AppColors.primaryRed,),

                      CustomTextField(hintText: AppStrings.studentName,controller: authProvider.nameController,
                        validator: (value) => authProvider.validateNotEmpty(value),
                      ),

                      CustomTextField(hintText: AppStrings.enterEmail,controller: authProvider.emailController,
                        validator: (value) => authProvider.validateEmail(value),
                      ),
                      CustomTextField(hintText: AppStrings.mobileNumber,controller: authProvider.mobileNumberController,keyboardType: TextInputType.number,
                        validator: (value) => authProvider.validateMobile(value),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: () {
                            seat.isSelected = false;
                            libraryProvider.update();
                            Utils.navigateBack();
                          }, child: CustomText(text:AppStrings.cancel,color: AppColors.primaryRed,fontWeight: FontWeight.bold,)),
                          TextButton(
                              onPressed: () async{
                                if(_formKey.currentState!.validate()){
                                  if(await libraryProvider.bookSeat(seatId : seat.seatId,libraryId: libraryId)){
                                    await libraryProvider.insertStudentData(
                                        seatId:  int.parse(seat.seatId),
                                        libraryId: libraryId,
                                        studentName: authProvider.nameController.text.trim(),
                                        studentEmail: authProvider.emailController.text.trim(),
                                        studentMobileNumber: authProvider.mobileNumberController.text.trim()
                                    );
                                    seat.isBooked = true;
                                    seat.isSelected = false;
                                    Utils.navigateBack();
                                    authProvider.clearControllers();
                                    libraryProvider.update();
                                  }else{
                                    Utils.showToast(msg: "Seat booking failed");
                                  }

                                }
                              }, child: CustomText(text:'Continue',color: AppColors.green,fontWeight: FontWeight.bold,)),
                        ],
                      )
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
void showStudentDetailsBottomSheet({
  required BuildContext context,
  required LibraryProvider libraryProvider,
  bool isPaid = true,
  int? index
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    backgroundColor: Colors.white,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: 15.w,
        right: 15.w,
        top: 15.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(height: 10.h),

          /// Title
          CustomText(
            text:AppStrings.studentInformation,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: AppColors.primaryRed,
          ),
          SizedBox(height: 20.h),

          /// Profile Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 38.r,
                backgroundColor: Colors.grey.shade300,
                child: CustomText(
                   text: libraryProvider.singleStudentData["name"]!=null?  libraryProvider.singleStudentData["name"][0].toUpperCase() : "",
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: libraryProvider.singleStudentData["name"],
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      maxLines: 2,
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        AppStrings.student,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    )
                  ],
                ),
              ),


              
              Visibility(
                visible: !isPaid,
                child: InkWell(
                  onTap: () async{
                    final String message = "Please submit your fees for this month";
                    await Share.share(message,subject: 'Fee Reminder',);
                  }, child: Icon(Icons.notifications_paused_rounded)),
              )
            ],
          ),
          SizedBox(height: 20.h),

          /// Info Rows
          _infoRow(Icons.email, AppStrings.email, libraryProvider.singleStudentData["email"]),
          _infoRow(Icons.phone, AppStrings.contact, libraryProvider.singleStudentData["mobile_number"]),
          _infoRow(Icons.event_seat, AppStrings.seat, "S${libraryProvider.singleStudentData["seat_id"]}"),
          _infoRow(Icons.calendar_month, AppStrings.joiningDate, convertDate(dateString: libraryProvider.singleStudentData["created_at"])),

           index!=null
               ? _infoRow(Icons.timer, "Payment ${AppStrings.timing}", convertDate(dateString: libraryProvider.studentFeesDataList[index]["created_at"],timing: true))
               : SizedBox(),
         SizedBox(height: 5.h,),
         Visibility(
           visible: !isPaid,
           child: SlideAction(
                   action: () async{
           await libraryProvider.updateStudentFeeStatus(studentId: libraryProvider.singleStudentData["id"], status: "Paid");
           libraryProvider.fetchStudentFeeData(libraryId: libraryProvider.singleStudentData["library_id"]);
           Utils.navigateBack();
           },
               trackBuilder: (context, state) {
                 return Container(
                   height: 60.h,
                   decoration: BoxDecoration(
            color: AppColors.primaryRed.withOpacity(.9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
                   ),
                   alignment: Alignment.center,
                   child: CustomText(
            text:
            "SLIDE TO CONFIRM PAYMENT",
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,

                   ),
                 );
               },
               thumbBuilder: (context, state) {
                 return Container(
                   margin: EdgeInsets.all(2.r),
                   decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.lightGrey!,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
                   ),
                   child: Icon(Icons.arrow_forward, color: AppColors.primaryRed),
                 );
               },
             ),
         )
      ],
      ),
    ),
  );
}

Widget _infoRow(IconData icon, String label, String value) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.r, color: AppColors.primaryRed),
        SizedBox(width: 10.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
              children: [
                TextSpan(
                  text: "$label: ",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: value,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

String convertDate({required String dateString, bool timing = false}) {
  DateTime date = DateTime.parse(dateString);
  if(timing==false){
    String formattedDate = '${date.day}-${date.month}-${date.year}';
    return formattedDate;
    }else{
    DateTime localTime = date.toUtc().toLocal();
    return DateFormat('hh:mm a').format(localTime);
  }
  }
