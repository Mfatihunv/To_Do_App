import 'package:flutter/material.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/widgets/task_list_item.dart';

import '../models/task_model.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  final List<Task> allTask;

  CustomSearchDelegate({required this.allTask});

  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
        onTap: () {
          close(context, null);
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: 20,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTask
        .where(
            (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.length > 0
        ? ListView.builder(
            itemBuilder: (context, index) {
              var oankiListeElemani = filteredList[index];
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
                  onDismissed: (direction) async {
                    filteredList.removeAt(index);
                    await locator<LocalStorage>()
                        .deleteTask(task: oankiListeElemani);
                    // _localStorage.deleteTask(task: oankiListeElemani);
                  },
                  child: TaskItem(task: oankiListeElemani));
            },
            itemCount: filteredList.length,
          )
        : Center(
            child: Text('Aradığnızı Bulamadık'),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
