import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylibraryapp/core/constants/app_colors.dart';
import 'package:mylibraryapp/core/constants/app_strings.dart';
import 'package:mylibraryapp/core/utils/utils.dart';
import 'package:mylibraryapp/core/widgets/common_widgets/custom_text.dart';
import 'package:mylibraryapp/modules/library/presenter/views/fee_details.dart';
import 'package:mylibraryapp/modules/library/presenter/views/student_details.dart';
import 'library_details.dart';

class LibraryDetailsView extends StatefulWidget {
  final String name;
  final String libraryId;
  final String imageUrl;
  final String address;
  final String contact;
  final String timing;
  final String availableSeats;
  final String monthlyCharges;
  final String description;

  const LibraryDetailsView({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.contact,
    required this.timing,
    required this.description,
    required this.availableSeats,
    required this.monthlyCharges,
    required this.libraryId,
  });

  @override
  State<LibraryDetailsView> createState() => _LibraryDetailsViewState();
}

class _LibraryDetailsViewState extends State<LibraryDetailsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppColors.white
          ),
          backgroundColor: AppColors.primaryRed,
          title: CustomText(text: widget.name,fontSize: 18.sp,fontWeight: FontWeight.bold,color: AppColors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Utils.navigateBack(),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            TabBar(
              indicatorColor: AppColors.primaryRed,
              indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: AppStrings.libraryDetails,),
                  Tab(text: AppStrings.student,),
                  Tab(text: AppStrings.fees,),
                ]
            ),
            Expanded(
                child: TabBarView(
                    children:[
                      LibraryDetails(
                        contact: widget.contact,
                        address: widget.address,
                        libraryId: widget.libraryId,
                        monthlyCharges: widget.monthlyCharges,
                        availableSeats: widget.availableSeats,
                        imageUrl: widget.imageUrl,
                        description: widget.description,
                         name: widget.name,
                         timing: widget.timing,
                      ),
                      StudentDetails(libraryId: widget.libraryId,),
                      FeeDetails(libraryId: widget.libraryId)
                    ]
                ),
            )
          ],
        ),
      ),
    );

  }
}


