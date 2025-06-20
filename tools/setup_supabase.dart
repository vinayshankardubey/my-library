import 'dart:io';

void main() async {
  final flavors = {
    'dev': {},
    'staging': {},
    'prod': {},
  };

  print('🚀 Supabase Setup with Flavors\n');

  // Collect inputs before going async
  final inputs = <String, Map<String, String>>{};

  for (final flavor in flavors.keys) {
    stdout.write('🔗 Enter Supabase URL for $flavor: ');
    final url = stdin.readLineSync()?.trim() ?? '';

    stdout.write('🔑 Enter Supabase Anon Key for $flavor: ');
    final key = stdin.readLineSync()?.trim() ?? '';

    if (url.isEmpty || key.isEmpty) {
      print('❌ Skipping $flavor due to missing inputs');
      continue;
    }

    inputs[flavor] = {'url': url, 'key': key};
  }

  await generateSupabaseFiles(inputs);
}

Future<void> generateSupabaseFiles(Map<String, Map<String, String>> flavors) async {
  // Ensure lib/supabase directory exists
  final supabaseDir = Directory('lib/supabase');
  if (!supabaseDir.existsSync()) {
    supabaseDir.createSync(recursive: true);
  }

  // 1. Generate supabase_config.dart
  final configBuffer = StringBuffer();
  configBuffer.writeln("String get supabaseUrl => _urlMap[env] ?? '';");
  configBuffer.writeln("String get supabaseAnonKey => _keyMap[env] ?? '';");
  configBuffer.writeln('');
  configBuffer.writeln("late String env;");
  configBuffer.writeln('');
  configBuffer.writeln("const _urlMap = {");
  for (final flavor in flavors.entries) {
    configBuffer.writeln("  '${flavor.key}': '${flavor.value['url']}',");
  }
  configBuffer.writeln("};");
  configBuffer.writeln('');
  configBuffer.writeln("const _keyMap = {");
  for (final flavor in flavors.entries) {
    configBuffer.writeln("  '${flavor.key}': '${flavor.value['key']}',");
  }
  configBuffer.writeln("};");

  File('lib/supabase/supabase_config.dart').writeAsStringSync(configBuffer.toString());
  print('✅ lib/supabase/supabase_config.dart created');

  // 2. Generate supabase_client.dart
  File('lib/supabase/supabase_client.dart').writeAsStringSync('''
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class SupabaseManager {
  static bool _isInitialized = false;

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize(String environment) async {
    if (_isInitialized) return;
    env = environment;
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    _isInitialized = true;
  }
}
''');
  print('✅ lib/supabase/supabase_client.dart created');

  // 3. Optional test file
  File('lib/supabase/supabase_test.dart').writeAsStringSync('''
import 'package:flutter/material.dart';
import 'supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseManager.initialize('dev'); // change env if needed
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Demo',
      home: Scaffold(
        appBar: AppBar(title: Text('Supabase Connected')),
        body: Center(child: Text('🎉 Supabase is ready!')),
      ),
    );
  }
}
''');
  print('✅ lib/supabase/supabase_test.dart created');

  // 4. Generate main_<flavor>.dart files
  for (final flavor in flavors.keys) {
    final fileName = 'lib/main_$flavor.dart';
    final file = File(fileName);
    if (!file.existsSync()) {
      file.writeAsStringSync('''
import 'main.dart' as app;

void main() {
  const env = '$flavor';
  app.main(env);
}
''');
      print('✅ $fileName created');
    } else {
      print('ℹ️ $fileName already exists');
    }
  }

  // 5. Add supabase_flutter package
  print('\n📦 Adding supabase_flutter to your project...');
  final result = await Process.run('flutter', ['pub', 'add', 'supabase_flutter']);
  if (result.exitCode == 0) {
    print('✅ Package added:\n${result.stdout}');
  } else {
    print('❌ Failed to add package:\n${result.stderr}');
  }

  print('\n🎉 Supabase setup complete with static SupabaseManager and flavor support!');
}
