import 'package:mylibraryapp/core/constants/app_colors.dart';
import 'package:mylibraryapp/modules/home/presenter/views/home_view.dart';
import 'package:mylibraryapp/modules/profile/presenter/views/profile_view.dart';
import '../../../../core/base_import.dart';
import '../../../history/presenter/views/booking_history_view.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeView(),
    BookingHistoryView(),
    ProfileView()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: AppColors.primaryRed,
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(MaterialState.selected)) {
              return TextStyle(
                color: AppColors.primaryRed,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              );
            }
            return TextStyle(
              color: AppColors.black,
              fontSize: 11.sp,
            );
          }),
        ),child:  NavigationBar(

           indicatorColor: AppColors.primaryRed,
           elevation: 3,

           selectedIndex: _currentIndex,
            onDestinationSelected: (index){
             setState(() {
               _currentIndex = index;
             });
            },
            destinations: [
             NavigationDestination(
                 icon: Icon(Icons.home),
                 label: "Home",
                 selectedIcon: Icon(Icons.home_filled,color: AppColors.white,),
             ),
             NavigationDestination(icon: Icon(Icons.history), label: "History",selectedIcon: Icon(Icons.history_sharp,color: AppColors.white,),),
             NavigationDestination(icon: Icon(Icons.person), label: "Profile",selectedIcon: Icon(Icons.person_pin,color: AppColors.white,),),
            ]
        ),
      ),
    );

  }
}
