import 'dart:io';

void main() async {
  print('🛠️ Setting up GoRouter inside core/router...');

  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('❌ pubspec.yaml not found! Make sure you are in project root.');
    return;
  }

  var pubspecContent = pubspecFile.readAsStringSync();

  // Step 1: Add go_router package after flutter sdk
  if (!pubspecContent.contains('go_router:')) {
    print('➕ Adding go_router to pubspec.yaml...');
    final flutterSdkPattern = RegExp(r'flutter:\n\s+sdk:\s+flutter');
    final match = flutterSdkPattern.firstMatch(pubspecContent);
    if (match != null) {
      final insertIndex = match.end;
      pubspecContent = '${pubspecContent.substring(0, insertIndex)}\n  go_router: ^13.0.0${pubspecContent.substring(insertIndex)}';
    }
  } else {
    print('✅ go_router already present.');
  }

  // Step 2: Save pubspec.yaml
  pubspecFile.writeAsStringSync(pubspecContent);
  print('✅ pubspec.yaml updated!');

  // Step 3: Run flutter pub get
  print('🚀 Running flutter pub get...');
  try {
    final result = await Process.run('flutter', ['pub', 'get']);
    if (result.exitCode == 0) {
      print('✅ flutter pub get successful!');
    } else {
      print('❌ flutter pub get failed:');
      print(result.stderr);
      return;
    }
  } catch (e) {
    print('❌ Error running flutter pub get: $e');
    return;
  }

  // Step 4: Create core/router and route_names
  final coreRouterDir = Directory('lib/core/router');
  if (!coreRouterDir.existsSync()) {
    coreRouterDir.createSync(recursive: true);
  }

  final routerFile = File('lib/core/router/app_router.dart');
  if (!routerFile.existsSync()) {
    routerFile.writeAsStringSync(_routerTemplate);
    print('✅ Created lib/core/router/app_router.dart');
  }

  final routeNamesFile = File('lib/core/router/app_routes.dart');
  if (!routeNamesFile.existsSync()) {
    routeNamesFile.writeAsStringSync(_routeNamesTemplate);
    print('✅ Created lib/core/router/app_routes.dart');
  }

  // Step 5: Create example pages
  final pagesDir = Directory('lib/core/router/test_pages');
  if (!pagesDir.existsSync()) {
    pagesDir.createSync(recursive: true);
  }

  final homePageFile = File('lib/core/router/test_pages/home_page.dart');
  if (!homePageFile.existsSync()) {
    homePageFile.writeAsStringSync(_homePageTemplate);
    print('✅ Created lib/core/router/test_pages/home_page.dart');
  }

  final secondPageFile = File('lib/core/router/test_pages/second_page.dart');
  if (!secondPageFile.existsSync()) {
    secondPageFile.writeAsStringSync(_secondPageTemplate);
    print('✅ Created lib/core/router/test_pages/second_page.dart');
  }

  print('🎉 GoRouter setup complete under core/router! Happy navigating!');
}

const _routeNamesTemplate = '''
class RouteNames {
  static const String home = '/';
  static const String second = '/second';
}
''';

const _routerTemplate = '''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../pages/home_page.dart';
import '../../pages/second_page.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.home,
  routes: [
    GoRoute(
      path: RouteNames.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: RouteNames.second,
      builder: (context, state) => const SecondPage(),
    ),
  ],
);
''';

const _homePageTemplate = '''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/router/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go(RouteNames.second),
          child: const Text('Go to Second Page'),
        ),
      ),
    );
  }
}
''';

const _secondPageTemplate = '''
import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: const Center(
        child: Text('This is the Second Page'),
      ),
    );
  }
}
''';
