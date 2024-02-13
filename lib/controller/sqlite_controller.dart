import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/notes_model.dart';

class SQLiteController {
  //Initilize Database - Create table if not exists
  Future<Database> initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'notes.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Notes (
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT
          )
        ''');
      },
    );
  }

  //Insert Note in Table
  Future<void> insertNote(Notes note) async {
    final Database db = await initDatabase();
    await db.insert('Notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Get Notes from Table
  Future<List<Notes>> getNotes() async {
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> queryResult = await db.query('Notes');
    return queryResult.map((e) => Notes.fromMap(e)).toList();
  }

  //Update Note in Table
  Future<void> updateNote(Notes note) async {
    final Database db = await initDatabase();
    await db.update('Notes', note.toMap(),
        where: "id = ?",
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Delete Note from Table
  Future deleteNote(int id) async {
    final Database db = await initDatabase();
    await db.delete("Notes", where: "id = ?", whereArgs: [id]);
  }
}
