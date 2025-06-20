import 'package:mylibraryapp/core/widgets/common_widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/base_import.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/bottom_sheet_helper/bottom_sheet_helper.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/common_widgets/custom_animated_button.dart';
import '../../../../core/widgets/common_widgets/custom_text.dart';
import '../../../library/presenter/provider/library_provider.dart';
import '../../../library/presenter/views/library_details_view.dart';
import '../provider/home_provider.dart';
import '../widgets/custom_library_info_card.dart';
import '../widgets/custom_user_info_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _selected = 'first';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).init();
      Provider.of<LibraryProvider>(context, listen: false).fetchLibraryData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        title: CustomText(
          text: "Home",
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        centerTitle: true,
      ),
      body: Consumer2<HomeProvider, LibraryProvider>(
        builder: (context, homeProvider, libraryProvider, _) {
          final user = homeProvider.userProfileData;
          final libraries = libraryProvider.libraryDataList;

          return RefreshIndicator(
            onRefresh: () async {
              await homeProvider.init();
              await libraryProvider.fetchLibraryData();
            },
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              children: [
                if (user.isNotEmpty)
                  CustomUserInfoCard(
                    elevation: 3,
                    role: user['role'],
                    name: user['name'],
                    email: user['email'],
                    contact: user['mobile_number'],
                    address: "",
                  )
                else
                  Center(child: SizedBox()),

                SizedBox(height: 20.h),

                libraries.length>5 ?
                CustomTextField(
                  hintText: "Search Library",
                  controller: libraryProvider.librarySearchController,
                  onChanged: (value) {
                     libraryProvider.searchLibrary(query: value);
                  },
                ): SizedBox(),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: CustomText(
                    text: "Total library : ${libraryProvider.libraryDataList.length}",
                    fontSize: 12.sp,
                  ),
                ),
                if(libraries.isNotEmpty) ...[
                  CustomText(
                    text: "Available Libraries",
                    textStyle:
                    TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 12.h),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: libraries.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (_, index) {
                      final data = libraries[index];
                      return CustomLibraryInfoCard(
                        imageUrl:
                        "https://images.pexels.com/photos/2041540/pexels-photo-2041540.jpeg",
                        libraryName: data["name"],
                        availableSeats: data["available_seat"],
                        charges: data["charges"].toDouble(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LibraryDetailsView(
                                libraryId: data["library_id"],
                                name: data["name"],
                                imageUrl:
                                "https://images.pexels.com/photos/2041540/pexels-photo-2041540.jpeg",
                                availableSeats:
                                data["available_seat"].toString(),
                                monthlyCharges:
                                data['charges'].toStringAsFixed(2),
                                address: data["address"],
                                contact: data["owner_number"],
                                timing: "Mon - Sat: 9:00 AM - 6:00 PM",
                                description:
                                "City Central Library offers a rich collection of books, magazines, and digital resources. "
                                    "It provides a peaceful environment for study and research, along with free Wi-Fi and reading rooms.",
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )

                ]
                else if (homeProvider.isLoading)
                  Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: CustomText(
                        text: "No Library Found",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                SizedBox(height: 50.h),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h),
        child: SizedBox(
          height: 50.h,
          width: 1.sw,
          child: CustomAnimatedButton(
            onTap: () => Utils.navigateTo(AppRoutes.addLibraryView),
            text: AppStrings.addLibrary,
          ),
        ),
      ),
    );
  }
}
