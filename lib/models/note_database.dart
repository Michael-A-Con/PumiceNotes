import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier{
  //INIT Database
  static late Isar isar;
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
        [NoteSchema],
        directory: dir.path
    );
  }

  final List<Note> currentNotes = [];

  //CRUD -- Database actions

  //CREATE
  Future<void> addNote(String textFromUser) async {
    //create new note object
    final newNote = Note()..text = textFromUser;

    // save to database
    await isar.writeTxn(() => isar.notes.put(newNote));

    //refresh currentNotes List
    fetchNotes();
  }

  //READ
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  //UPDATE
  Future<void> update(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  //DELETE
  Future<void> delete(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }

}