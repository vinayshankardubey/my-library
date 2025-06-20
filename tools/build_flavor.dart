import 'dart:io';

void main() {
  final flavors = {
    'dev': 'dev',
    'staging': 'staging',
    'prod': 'prod',
  };

  for (final entry in flavors.entries) {
    final fileName = 'lib/main_${entry.key}.dart';
    final envValue = entry.value;

    final file = File(fileName);
    if (!file.existsSync()) {
      file.writeAsStringSync('''
import 'main.dart' as app;

void main() {
  const env = '$envValue';
  app.main(env);
}
''');
      print('✅ $fileName created');
    } else {
      print('ℹ️ $fileName already exists');
    }
  }

  print('\n🎉 Flavor files generated!');
}
