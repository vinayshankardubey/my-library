import 'package:provider/provider.dart';

import '../../../../core/base_import.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common_widgets/custom_text.dart';
import '../provider/library_provider.dart';
import '../views/library_details.dart';

class CustomTableView extends StatelessWidget {
  final List<Map<String, dynamic>> rowHeadersData;
  final String libraryId;

  const CustomTableView({
    super.key,
    required this.rowHeadersData,
    required this.libraryId,
  });

  @override
  Widget build(BuildContext context) {
    final int totalRows = rowHeadersData.length;

    // Generate last 6 months
    final now = DateTime.now();
    final List<String> visibleMonths = List.generate(6, (i) {
      final DateTime date = DateTime(now.year, now.month - 5 + i);
      return _monthName(date.month);
    });

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Consumer<LibraryProvider>(
        builder: (context, libraryProvider, _) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Row Headers (Name)
              Column(
                children: List.generate(totalRows + 1, (index) {
                  return index == 0
                      ? _headerCell("Name")
                      : InkWell(
                    onTap: () async {
                      await libraryProvider.checkStudentData(
                        libraryId: libraryId,
                        seatId: rowHeadersData[index - 1]["seat_id"],
                      );
                      showStudentDetailsBottomSheet(
                        context: context,
                        libraryProvider: libraryProvider,

                      );
                    },
                    child: _dataCell(rowHeadersData[index - 1]['name']),
                  );
                }),
              ),

               /// Status Columns
               Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: List.generate(totalRows + 1, (rowIndex) {
                      return Row(
                        children: List.generate(6, (monthIndex) {
                          String cellText = '';

                          if (rowIndex == 0) {
                            // Header Row
                            cellText = visibleMonths[monthIndex];
                          } else {
                            final student = rowHeadersData[rowIndex - 1];
                            List<dynamic> statusList = student["status"];

                            if (monthIndex < statusList.length) {
                              cellText = statusList[monthIndex].toString();
                            } else {
                              cellText = "-";
                            }
                          }
                          return rowIndex == 0
                              ? _headerCell(cellText)
                              : InkWell(
                                onTap: () async{
                                    await libraryProvider.checkStudentData(
                                      libraryId: libraryId,
                                      seatId: rowHeadersData[rowIndex-1]["seat_id"],
                                    );
                                    showStudentDetailsBottomSheet(
                                      context: context,
                                      libraryProvider: libraryProvider,
                                      index: rowIndex-1,
                                      isPaid: cellText.toLowerCase()=="paid" ? true : false
                                    );
                                },
                                child: _dataCell(cellText));
                        }),
                      );
                    }),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _headerCell(String text) {
    return Container(
      width: 100.w,
      height: 50.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey),
        color: AppColors.lightGrey,
      ),
      child: CustomText(
        text: text,
        fontWeight: FontWeight.w500,
        fontSize: 15.sp,
        color: AppColors.primaryRed,
      ),
    );
  }

  Widget _dataCell(String text) {
    return Container(
      width: 100.w,
      height: 50.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey),
        color: AppColors.white,
      ),
      child: CustomText(
        text: text,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color:   text.toLowerCase() == "paid" ? AppColors.green  :  AppColors.black     ),
    );
  }

  String _monthName(int monthIndex) {
    const List<String> months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[(monthIndex - 1) % 12];
  }
}
