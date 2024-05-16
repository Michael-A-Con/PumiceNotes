import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_notes_app/components/drawer.dart';
import 'package:minimal_notes_app/models/note_database.dart';
import 'package:provider/provider.dart';
import '../components/note_tile.dart';
import '../models/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //on startup fectch existing notes
    readNotes();
  }

  //CREATE notes
  void createNote() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
              content: TextField(
                controller: textController,
                cursorColor: Theme.of(context).colorScheme.inversePrimary,
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    context.read<NoteDatabase>().addNote(textController.text);
                    textController.clear();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Create",
                    style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                )
              ],
            ));
  }

  //READ notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  //UPDATE note
  void updateNote(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Update Note"),
        content: TextField(controller: textController),
        actions: [
          MaterialButton(
            onPressed: () {
              //save to db
              context.read<NoteDatabase>().update(note.id, textController.text);

              //clear controller
              textController.clear();

              //pop box
              Navigator.pop(context);
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }

  //DELETE note
  void delete(int id) {
    context.read<NoteDatabase>().delete(id);
  }

  @override
  Widget build(BuildContext context) {
    //notes db
    final noteDatabase = context.watch<NoteDatabase>();

    //current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: createNote,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      drawer: MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Header
           Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Notes',
              style: GoogleFonts.dmSerifText(
                  fontSize: 48,
                  color: Theme.of(context).colorScheme.inversePrimary,
              ),
             ),
          ),

          //List of Notes
          Expanded(
            child: ListView.builder(
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  final note = currentNotes[index];

                  //UI
                  return NoteTile(
                    text: note.text,
                    updateOnPressed: () => updateNote(note),
                    deleteOnPressed: () => delete(note.id),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
