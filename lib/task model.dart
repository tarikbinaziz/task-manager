import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  DateTime? createdAt;
  @HiveField(3)
  bool? isCompleted;

  Task({this.id, this.name, this.createdAt, this.isCompleted});

  factory Task.create({required String name, DateTime? createdAt}) => Task(
      id: Uuid().v1(),
      name: name,
      createdAt: createdAt ?? DateTime.now(),
      isCompleted: false);
}
