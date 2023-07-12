import 'package:hive_flutter/adapters.dart';
import 'package:task_manager/task%20model.dart';

class HiveDataStore{

  static const taskBoxName="task";

  final Box<Task> box=Hive.box<Task>(taskBoxName);

  addTask(Task task)async{
    box.put(task.id, task);
  }
  getTask(String id){
    box.get(id);
  }

  updateTask(Task task)async{
  await task.save();
  }

  deleteTask(Task task)async{
  await task.delete();
  }

   valueListenable(){
    return box.listenable();
  }


}