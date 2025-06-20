import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylibraryapp/core/constants/app_colors.dart';
import 'package:mylibraryapp/core/constants/app_strings.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/common_widgets/custom_text.dart';
import '../provider/booking_history_provider.dart';

class BookingHistoryView extends StatefulWidget {
  @override
  State<BookingHistoryView> createState() => _BookingHistoryViewState();
}

class _BookingHistoryViewState extends State<BookingHistoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingHistoryProvider>(context, listen: false).fetchBookingHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        title: CustomText(
          text: AppStrings.bookingHistory,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Provider.of<BookingHistoryProvider>(context, listen: false).fetchBookingHistory();
          return Future.delayed(Duration(seconds: 1));
        },
        child: Consumer<BookingHistoryProvider>(
          builder: (context, bookingHistoryProvider, child) {
            if (bookingHistoryProvider.isLoading) {
              return Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
            }
            if (bookingHistoryProvider.bookingHistoryList.isEmpty) {
              return Center(child: CustomText(text: "No History Found", fontSize: 16.sp));
            }

            return ListView.builder(
              padding: EdgeInsets.all(12.r),
              itemCount: bookingHistoryProvider.bookingHistoryList.length,
              itemBuilder: (context, index) {
                final booking = bookingHistoryProvider.bookingHistoryList[index];

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: booking.status.toLowerCase() == 'paid'
                                  ? AppColors.green
                                  : AppColors.primaryRed,
                              child: Icon(Icons.event_seat, color: AppColors.white),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(text: booking.studentName, fontSize: 16.sp, fontWeight: FontWeight.bold),
                                  SizedBox(height: 2.h),
                                  CustomText(text: "Library: ${booking.libraryName}", fontSize: 14.sp),
                                  CustomText(text: "Seat: ${booking.seat}", fontSize: 14.sp),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomText(
                                  text: booking.status,
                                  color: booking.status.toLowerCase() == 'paid' ? AppColors.green : AppColors.primaryRed,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                                CustomText(
                                  text: "${bookingHistoryProvider.monthShortNames[int.parse(booking.month)-1]} / ${booking.year}",
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Divider(),
                        SizedBox(height: 4.h),
                        CustomText(
                          text: "Booked On: ${booking.bookingDate.toString().split('T').first}",
                          fontSize: 13.sp,),
                        CustomText(
                          text: "Payment Date: ${  booking.status.toLowerCase() == 'paid' ? booking.paymentDate.toString().split('T').first  : "Pending"}",
                          fontSize: 13.sp,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
