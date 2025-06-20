import 'package:mylibraryapp/core/constants/app_colors.dart';
import 'package:mylibraryapp/core/constants/app_strings.dart';
import 'package:mylibraryapp/core/constants/image_constant.dart';
import '../../../../core/base_import.dart';
import '../../../../core/widgets/common_widgets/custom_text.dart';

class CustomLibraryInfoCard extends StatefulWidget {
  final String imageUrl;
  final String libraryName;
  final int availableSeats;
  final double charges;
  final VoidCallback? onTap;
  final double? elevation;
  final double? radius;

  const CustomLibraryInfoCard({
    super.key,
    required this.imageUrl,
    required this.libraryName,
    required this.availableSeats,
    required this.charges,
    this.onTap,
    this.elevation = 5,
    this.radius = 16,
  });

  @override
  State<CustomLibraryInfoCard> createState() => _CustomLibraryInfoCardState();
}

class _CustomLibraryInfoCardState extends State<CustomLibraryInfoCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.radius!.r),
        ),
        // margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(widget.radius!.r)),
              child: Image.network(
                widget.imageUrl,
                height: 160.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, imgUrl, error) => Icon(Icons.error),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Image.asset(ImageConstant.previewImg, fit: BoxFit.cover,height: 160.h,width: 1.sw,);
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.all(14.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Library Name
                  CustomText(
                    text: widget.libraryName,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                    maxLines: 2,
                  ),
                  SizedBox(height: 10.h),

                  // Seat and Charges Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoChip(
                        label: "${AppStrings.seat}:",
                        value: widget.availableSeats.toString(),
                        icon: Icons.event_seat,
                        bgColor: Colors.blue[50],
                        iconColor: Colors.blue,
                      ),
                      _infoChip(
                        label: "${AppStrings.monthlyCharges}:",
                        value: "${AppStrings.rupeeSymbol}${widget.charges.toStringAsFixed(2)}",
                        icon: Icons.currency_rupee,
                        bgColor: Colors.green[50],
                        iconColor: Colors.green,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip({
    required String label,
    required String value,
    required IconData icon,
    Color? bgColor,
    Color? iconColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.r, color: iconColor),
          SizedBox(width: 6.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  )),
              Text(value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
