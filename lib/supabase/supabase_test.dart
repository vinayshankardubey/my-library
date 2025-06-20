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
