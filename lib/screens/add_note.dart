import 'package:flutter/material.dart';
import 'package:sqlite_flutter/controller/sqlite_controller.dart';
import 'package:sqlite_flutter/model/notes_model.dart';
import 'package:sqlite_flutter/screens/home_screen.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key, this.note});

  final Notes? note;

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    //Set text when editing a note
    if (widget.note != null) {
      titleController.text = widget.note!.title!;
      descController.text = widget.note!.description!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: Text(
          "${widget.note != null ? "Edit" : "Add"} Note",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black54, width: 1)),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    }
                    return null;
                  },
                  maxLines: 1,
                  maxLength: 50,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  controller: titleController,
                  decoration: const InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 10, top: 10),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black54, width: 1)),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    }
                    return null;
                  },
                  maxLines: 6,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  controller: descController,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 10, top: 10),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: 'Type description here',
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (widget.note != null) {
                        //This method will be called when editing a note
                        await SQLiteController()
                            .updateNote(Notes(
                                id: widget.note!.id,
                                title: titleController.text.trim(),
                                description: descController.text.trim()))
                            .then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                              (route) => false);
                        });
                      } else {
                        //This method will be called when makeing a new note
                        await SQLiteController()
                            .insertNote(Notes(
                                title: titleController.text.trim(),
                                description: descController.text.trim()))
                            .then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                              (route) => false);
                        });
                      }
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
