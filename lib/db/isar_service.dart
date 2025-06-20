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
