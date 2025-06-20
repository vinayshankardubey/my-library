import 'package:mylibraryapp/modules/home/presenter/provider/home_provider.dart';
import 'package:mylibraryapp/modules/library/presenter/provider/library_provider.dart';
import 'package:mylibraryapp/modules/profile/presenter/provider/profile_provider.dart';
import 'package:mylibraryapp/supabase/supabase_config.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/base_import.dart';
import 'core/router/app_router.dart';
import 'modules/authentication/presenter/provider/auth_provider.dart';
import 'modules/history/presenter/provider/booking_history_provider.dart';

void main({String env = 'dev'}) async{
   WidgetsFlutterBinding.ensureInitialized();

   await Supabase.initialize(
     url: supabaseUrl,
     anonKey: supabaseAnonKey,
   );

   runApp(MyApp(env: env));
}

class MyApp extends StatelessWidget {
  final String env;

  const MyApp({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => HomeProvider()),
            ChangeNotifierProvider(create: (_) => LibraryProvider()),
            ChangeNotifierProvider(create: (_) => BookingHistoryProvider()),
            ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ],
          builder: (context,child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter,
              title: 'Flutter App [$env]',
            );
          }
        );
      },
    );
  }
}
