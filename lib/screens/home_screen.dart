import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_flutter/controller/sqlite_controller.dart';
import 'package:sqlite_flutter/model/notes_model.dart';
import 'package:sqlite_flutter/screens/add_note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Notes>? notes;
  bool loading = true;

  //we will give dynamic colors to containers
  final List colors = [
    Colors.deepPurple,
    Colors.green,
    Colors.teal,
    Colors.indigo,
    Colors.deepOrangeAccent,
  ];

  @override
  void initState() {
    super.initState();
    getItems();
  }

  //Get all notes
  void getItems() async {
    notes = await SQLiteController().getNotes();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            "My Notes",
            style: TextStyle(color: Colors.white),
          ),
        ),
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNote(),
                ));
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                color: Colors.deepPurple, shape: BoxShape.circle),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        body: loading
            ? Platform.isIOS
                ? const Center(child: CupertinoActivityIndicator())
                : const Center(child: CircularProgressIndicator())
            : notes!.isEmpty
                ? const Center(
                    child: Text("Click add button to make notes!"),
                  )
                : ListView.builder(
                    itemCount: notes!.length,
                    padding: const EdgeInsets.all(20),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: colors[index % colors.length],
                            borderRadius: BorderRadius.circular(14)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              notes![index].title!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.6,
                                  child: Text(
                                    notes![index].description!,
                                    maxLines: 10,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AddNote(
                                                  note: notes![index],
                                                ),
                                              ));
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        )),
                                    IconButton(
                                        onPressed: () async {
                                          await SQLiteController()
                                              .deleteNote(notes![index].id!);
                                          notes!.removeAt(index);
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ));
  }
}
