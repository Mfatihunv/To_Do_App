import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/widgets/custom_search_delegate.dart';
import 'package:to_do_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    _allTasks = <Task>[];
    _localStorage = locator<LocalStorage>();

    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              _showAddTaskBottomSheet(context);
            },
            child: const Text(
              'Bugün Neler Yapacaksın ?',
              style: TextStyle(color: Colors.black),
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                _showSearchPage();
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                _showAddTaskBottomSheet(context);
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: _allTasks.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  var oankiListeElemani = _allTasks[index];
                  return Dismissible(
                      background: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Icon(
                            Icons.delete_forever,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text('bU gÖREV sİLİNDİ KNK')
                        ],
                      ),
                      key: Key(oankiListeElemani.id),
                      onDismissed: (direction) {
                        _allTasks.removeAt(index);
                        _localStorage.deleteTask(task: oankiListeElemani);
                        setState(() {});
                      },
                      child: TaskItem(task: oankiListeElemani));
                },
                itemCount: _allTasks.length,
              )
            : Center(
                child: Text('Hadi Görev Ekle'),
              ));
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    /* Uyarı Ekranı */ showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              textInputAction: TextInputAction.done,
              autofocus: true,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                  hintText: 'Görevi Girin?', border: InputBorder.none),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(context, showSecondsColumn: false,
                      onConfirm: ((time) async {
                    var yeniEklenecekGorev =
                        Task.create(name: value, createdAt: time);
                    _allTasks.insert(0, yeniEklenecekGorev);
                    await _localStorage.addTask(task: yeniEklenecekGorev);
                    setState(() {});
                  }));
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }

  Future<void> _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTask: _allTasks));

    _getAllTaskFromDb();
  }
}
