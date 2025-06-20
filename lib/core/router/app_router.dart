import 'package:mylibraryapp/modules/home/presenter/views/home_view.dart';
import '../../modules/authentication/presenter/views/add_details_view.dart';
import '../../modules/authentication/presenter/views/sign_in_view.dart';
import '../../modules/authentication/presenter/views/sign_up_view.dart';
import '../../modules/bottom_nav_bar/presenter/views/bottom_nav_bar.dart';
import '../../modules/history/presenter/views/booking_history_view.dart';
import '../../modules/library/presenter/views/add_library_view.dart';
import '../../modules/onboarding/presenter/views/splash_view.dart';
import '../base_import.dart';
import 'app_routes.dart';


CustomTransitionPage<T> buildTransitionPage<T>({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 50),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splashView,
  routes: [

    GoRoute(
      path: AppRoutes.splashView,
      builder: (context, state) => const SplashView(),
    ),

    GoRoute(
      path: AppRoutes.signInView,
      builder: (context, state) => const SignInView(),
    ),

    GoRoute(
      path: AppRoutes.signUpView,
      builder: (context, state) => const SignUpView(),
    ),

    GoRoute(
      path: AppRoutes.homeView,
      builder: (context, state) => const HomeView(),
    ),

  GoRoute(
      path: AppRoutes.addLibraryView,
      builder: (context, state) => const AddLibraryView(),
    ),

    GoRoute(
      path: AppRoutes.addDetailsView,
      builder: (context, state) => const AddDetailsView(),
    ),

    GoRoute(
      path: AppRoutes.bottomNavBar,
      builder: (context, state) => const BottomNavBar(),
    ),
    GoRoute(
      path: AppRoutes.bookingHistoryView,
      builder: (context, state) =>  BookingHistoryView(),
    ),

   // GoRoute(
   //    path: AppRoutes.libraryDetailsView,
   //    pageBuilder: (context, state) {
   //    final data = state.extra;
   //    return  buildTransitionPage(state: state,child: LibraryDetailsView(libraryDetailsData: data));
   //    },
   //  ),

  ],
);
