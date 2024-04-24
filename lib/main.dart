import 'package:flutter/material.dart';
import 'package:minimal_notes_app/models/note.dart';
import 'package:minimal_notes_app/models/note_database.dart';
import 'package:minimal_notes_app/pages/notes_page.dart';
import 'package:minimal_notes_app/theme/theme.dart';
import 'package:minimal_notes_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  //init notes db
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
        providers: [
          //Note DB
          ChangeNotifierProvider(create: (context) => NoteDatabase()),
          //Themes
          ChangeNotifierProvider(create: (context) => ThemeProvider(
              isDarkMode: prefs.getBool("isDarkTheme") ?? false
          ))
        ],
        child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotesPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}