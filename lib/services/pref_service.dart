import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';

class Preference {
  static Future<bool> storeNote(Note note) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String noteString = jsonEncode(note.toJson());
    return await pref.setString('note', noteString);
  }

  static Future<Note> loadNote() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? noteString = pref.getString('note');
    return Note.fromJson(jsonDecode(noteString!));
  }

  static Future<bool> storeNoteList(List<Note> note) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> stringList =
        note.map((note) => jsonEncode(note.toJson())).toList();
    return await pref.setStringList('noteList', stringList);
  }

  static Future<List<Note>> loadNoteList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? stringList = pref.getStringList('noteList');
    return stringList!.map((note) => Note.fromJson(jsonDecode(note))).toList();
  }

  static Future<bool> removeNoteList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.remove('noteList');
  }
}
