import 'package:flutter/material.dart';
import 'package:mylibraryapp/core/constants/app_colors.dart';
import 'package:mylibraryapp/core/constants/app_strings.dart';
import '../../../../core/base_import.dart';
import '../../../../core/widgets/common_widgets/custom_text.dart';

class CustomUserInfoCard extends StatelessWidget {
  final String role;
  final double? elevation;
  final double? radius;
  final String name;
  final String email;
  final String contact;
  final String address;
  final String? seatNumber;
  final String? imageUrl;

  const CustomUserInfoCard({
    super.key,
    required this.role,
    required this.email,
    required this.contact,
    required this.address,
    this.imageUrl,
    this.elevation,
    this.radius = 16,
    required this.name,
    this.seatNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius!.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: profile + name + badge
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.primaryRed.withOpacity(0.8), Colors.orangeAccent],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 35.r,
                    backgroundImage: imageUrl != null
                        ? NetworkImage(imageUrl!)
                        : null,
                    backgroundColor: Colors.white,
                    child: imageUrl == null
                        ? CustomText(
                      text :name[0].toUpperCase(),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                    )
                        : null,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: name,
                        textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                     role.isNotEmpty ? _buildRoleBadge(role) : SizedBox()
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            Divider(thickness: 1, color: Colors.grey[300]),

            // Info section
            _infoTile(Icons.email, AppStrings.email, email),
            _infoTile(Icons.phone, AppStrings.contact, contact),

            if (role == AppStrings.libraryOwner)
              _infoTile(Icons.location_on, AppStrings.address, address),

            if (seatNumber != null)
              _infoTile(Icons.event_seat, AppStrings.seat, seatNumber!),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: value.isNotEmpty
             ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.r, color: AppColors.primaryRed),
          SizedBox(width: 12.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: value,
                  ),
                ],
              ),
            ),
          ),
        ],
      )
             : SizedBox()
    );
  }

  Widget _buildRoleBadge(String role) {
    final isOwner = role == AppStrings.libraryOwner;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isOwner ? AppColors.green.withOpacity(.4) : Colors.blue[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: CustomText(
        text: role,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: isOwner ? AppColors.green : AppColors.blue,
      ),
    );
  }
}
