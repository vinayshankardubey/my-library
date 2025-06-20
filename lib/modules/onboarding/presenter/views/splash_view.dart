import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/image_constant.dart' show ImageConstant;
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/common_widgets/custom_text.dart';

/// A splash screen that navigates to the home page after a delay.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final SupabaseClient supabaseClient = Supabase.instance.client;
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  /// Navigates to the home screen after a 3-second delay.
  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
        if(supabaseClient.auth.currentUser!=null && supabaseClient.auth.currentSession!=null ){
          Utils.navigateToOffAll(AppRoutes.bottomNavBar);
        }else{
          Utils.navigateToOffAll(AppRoutes.signInView);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageConstant.appLogoImg),
          ],
        ),
      ),
    );
  }
}