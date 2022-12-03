import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import '../models/task_model.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;

  @override
  void initState() {
    _localStorage = locator<LocalStorage>();
    super.initState();
    print('initstate tetiklendi');
  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.name;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 10),
          ]),
      child: ListTile(
          leading: GestureDetector(
            onTap: () {
              widget.task.isCompleted = !widget.task.isCompleted;
              _localStorage.UpdateTask(task: widget.task);
              setState(() {});
            },
            child: Container(
                decoration: BoxDecoration(
                    color:
                        widget.task.isCompleted ? Colors.green : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 0.8)),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                )),
          ),
          title: widget.task.isCompleted
              ? Text(
                  widget.task.name,
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey),
                )
              : TextField(
                  textInputAction: TextInputAction.done,
                  minLines: 1,
                  maxLines: null,
                  controller: _taskNameController,
                  decoration: InputDecoration(border: InputBorder.none),
                  onSubmitted: (yenideger) {
                    if (yenideger.length > 3) {
                      widget.task.name = yenideger;
                      _localStorage.UpdateTask(task: widget.task);
                    }
                  }),
          trailing: Text(
            DateFormat('hh:mm a').format(widget.task.createdAt),
            style: TextStyle(fontSize: 14, color: Colors.grey),
          )),
    );
  }
}
