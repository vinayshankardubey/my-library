import 'dart:io';

void main() async {
  print('🛠️ Setting up ISAR Local Database...');

  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('❌ pubspec.yaml not found! Make sure you are in project root.');
    return;
  }

  var pubspecContent = pubspecFile.readAsStringSync();

  // Step 1: Add ISAR packages after flutter sdk: flutter
  if (!pubspecContent.contains('isar:')) {
    print('➕ Adding ISAR packages under flutter sdk...');
    final flutterSdkPattern = RegExp(r'flutter:\n\s+sdk:\s+flutter');
    final match = flutterSdkPattern.firstMatch(pubspecContent);
    if (match != null) {
      final insertIndex = match.end;
      pubspecContent = '${pubspecContent.substring(0, insertIndex)}\n  isar: ^3.1.0\n  isar_flutter_libs: ^3.1.0\n  path_provider: ^2.0.0${pubspecContent.substring(insertIndex)}';
    }
  } else {
    print('✅ ISAR already present.');
  }

  // Step 2: Add ISAR Generator under dev_dependencies
  if (!pubspecContent.contains('isar_generator:')) {
    print('➕ Adding ISAR Generator under dev_dependencies...');
    final devDependenciesPattern = RegExp(r'dev_dependencies:');
    final match = devDependenciesPattern.firstMatch(pubspecContent);
    if (match != null) {
      final insertIndex = match.end;
      pubspecContent = '${pubspecContent.substring(0, insertIndex)}\n  build_runner: ^2.4.0\n  isar_generator: ^3.1.0${pubspecContent.substring(insertIndex)}';
    }
  } else {
    print('✅ ISAR Generator already present.');
  }

  // Step 3: Save updated pubspec.yaml
  pubspecFile.writeAsStringSync(pubspecContent);
  print('✅ pubspec.yaml updated!');

  // Step 4: Run flutter pub get
  print('🚀 Running flutter pub get...');
  try {
    final result = await Process.run('flutter', ['pub', 'get']);
    if (result.exitCode == 0) {
      print('✅ flutter pub get successful!');
    } else {
      print('❌ flutter pub get failed:');
      print(result.stderr);
      return; // stop here if pub get failed
    }
  } catch (e) {
    print('❌ Error running flutter pub get: $e');
    return;
  }

  // Step 5: Create necessary folders
  final dbDir = Directory('lib/db');
  if (!dbDir.existsSync()) {
    dbDir.createSync(recursive: true);
  }
  final modelsDir = Directory('lib/models');
  if (!modelsDir.existsSync()) {
    modelsDir.createSync(recursive: true);
  }

  // Step 6: Create example files
  final dbServiceFile = File('lib/db/isar_service.dart');
  if (!dbServiceFile.existsSync()) {
    dbServiceFile.writeAsStringSync(_isarServiceTemplate);
    print('✅ Created lib/db/isar_service.dart');
  }
  final modelExampleFile = File('lib/models/example_model.dart');
  if (!modelExampleFile.existsSync()) {
    modelExampleFile.writeAsStringSync(_isarModelTemplate);
    print('✅ Created lib/models/example_model.dart');
  }

  // Step 7: Run build_runner to generate .g.dart
  print('🚀 Running build_runner...');
  try {
    final result = await Process.start(
      'flutter',
      ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      runInShell: true,
    );
    await stdout.addStream(result.stdout);
    await stderr.addStream(result.stderr);
    final exitCode = await result.exitCode;
    if (exitCode == 0) {
      print('✅ build_runner completed successfully!');
    } else {
      print('❌ build_runner failed.');
    }
  } catch (e) {
    print('❌ Error running build_runner: $e');
  }

  print('🎉 ISAR setup fully complete! Happy coding!');
}

const _isarServiceTemplate = '''
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/example_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [ExampleModelSchema],
      directory: dir.path,
    );
  }
}
''';

const _isarModelTemplate = '''
import 'package:isar/isar.dart';

part 'example_model.g.dart';

@collection
class ExampleModel {
  Id id = Isar.autoIncrement;

  late String name;
}
''';
