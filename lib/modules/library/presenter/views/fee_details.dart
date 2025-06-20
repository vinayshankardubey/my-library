import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylibraryapp/core/constants/app_colors.dart';
import 'package:mylibraryapp/core/constants/app_strings.dart';
import 'package:mylibraryapp/core/widgets/common_widgets/custom_text.dart';
import 'package:mylibraryapp/modules/library/presenter/provider/library_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_table_view.dart';


class FeeDetails extends StatefulWidget {
  final String libraryId;
  const FeeDetails({
    super.key,
    required this.libraryId
  });

  @override
  State<FeeDetails> createState() => _FeeDetailsState();
}

class _FeeDetailsState extends State<FeeDetails> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LibraryProvider>(context,listen: false).fetchStudentFeeData(libraryId: widget.libraryId);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<LibraryProvider>(
          builder: (context,libraryProvider,child) {
            return Column(
              children: [
                SizedBox(height: 10.h,),

                Expanded(
                  child: libraryProvider.studentFeesDataList.isEmpty ? Center(child: CustomText(text: AppStrings.noStudentFound),)
                  
                 : CustomTableView(
                    libraryId: widget.libraryId,
                    rowHeadersData : libraryProvider.studentFeesDataList,
                  ),
                ),
              ],
            );
          }
      ),
    );
  }
}
