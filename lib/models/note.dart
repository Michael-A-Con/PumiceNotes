import 'package:isar/isar.dart';

//generate this file so we can store notes in isar database
//command used: dart run build_runner build
part 'note.g.dart';


@Collection()
class Note {
  Id id = Isar.autoIncrement;
  late String text;
}