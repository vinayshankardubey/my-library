import 'package:isar/isar.dart';

part 'example_model.g.dart';

@collection
class ExampleModel {
  Id id = Isar.autoIncrement; // Auto-increment ID

  late String name;
}
