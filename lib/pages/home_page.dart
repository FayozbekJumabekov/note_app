import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/services/pref_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  late List<bool> checkedits = List.generate(noteList.length, (index) => false);
  bool editText = false;

  bool themeMode = false;

  List<Note> noteList = [];

  bool isSelected = false;

  createNote() {
    String title = titleController.text.toString().trim();
    String content = contentController.text.toString().trim();
    Note note = Note(
      id: content.hashCode,
      createTime: DateTime.now(),
      editTime: DateTime.now(),
      title: title,
      content: content,
    );
    setState(() {
      noteList.add(note);
    });
    storeNote();
  }

  storeNote() async {
    checkedits = List.generate(noteList.length, (index) => false);
    var isStored = await Preference.storeNoteList(noteList);
    if (isStored) {
      if (kDebugMode) {
        print("Note successfully saved!!!");
      }
    }
  }

  void _loadNoteList() async {
    await Preference.loadNoteList().then((list) => {
          setState(() {
            noteList = list;
          })
        });
  }

  void removeNoteList([Note? note]) async {
    if (isSelected) {
      List<Note> list = [];
      for (var i = 0; i < checkedits.length; i++) {
        if (!checkedits[i]) list.add(noteList[i]);
      }
      noteList = list;
      isSelected = false;
      storeNote();
      setState(() {});
    } else {
      setState(() {
        noteList.remove(note);
        storeNote();
      });
    }
  }

  @override
  void initState() {
    _loadNoteList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes",
          style: TextStyle(fontSize: 22),
        ),
        actions: [
          (isSelected)
              ? IconButton(
                  onPressed: () {
                    removeNoteList();
                  },
                  icon: Icon(Icons.delete))
              : SizedBox.shrink(),
          IconButton(
              onPressed: () {
                setState(() {
                  themeMode  ? MyApp.of(context)?.changeTheme(ThemeMode.light) :  MyApp.of(context)?.changeTheme(ThemeMode.dark);
                  themeMode = !themeMode;
                });
              },
              icon:
                  (themeMode) ? Icon(Icons.light_mode) : Icon(Icons.dark_mode))
        ],
      ),
      body: Builder(builder: (context) {
        return SingleChildScrollView(
            child: (noteList.isNotEmpty)
                ? Column(
                    children: List.generate(noteList.length,
                        (index) => noteItems(context, noteList[index], index)))
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text(
                        "No Items!!!",
                        style: TextStyle( fontSize: 20),
                      ),
                    ),
                  ));
      }),
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: 65,
        height: 65,
        decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor, borderRadius: BorderRadius.circular(50)),
        child: awesomeDialog(context),
      ),
    );
  }


  /// # awesome dialog to create note
  IconButton awesomeDialog(BuildContext context) {
    return IconButton(
        onPressed: () {
          late AwesomeDialog dialog;
          dialog = AwesomeDialog(
            dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.NO_HEADER,
            keyboardAware: true,
            onDissmissCallback: (DismissType){
              setState(() {
                contentController.clear();
                titleController.clear();
              });
            },
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Create Note',
                    style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Material(
                    elevation: 0,
                    color: Colors.blueGrey.withAlpha(40),
                    child: TextFormField(
                      controller: titleController,
                      style: TextStyle(color: Theme.of(context).textTheme.subtitle2!.color),
                      autofocus: true,
                      minLines: 1,
                      decoration: InputDecoration(

                        border: InputBorder.none,
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Theme.of(context).listTileTheme.textColor),

                        prefixIcon: Icon(Icons.text_fields,color: Theme.of(context).appBarTheme.iconTheme!.color,),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Material(
                    elevation: 0,
                    color: Colors.blueGrey.withAlpha(40),
                    child: TextFormField(
                      controller: contentController,
                      style: TextStyle(color: Theme.of(context).textTheme.subtitle2!.color),
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      maxLengthEnforced: true,
                      minLines: 2,
                      maxLines: 8,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Content',
                        labelStyle: TextStyle(color: Theme.of(context).listTileTheme.textColor),
                        prefixIcon: Icon(Icons.text_fields,color: Theme.of(context).appBarTheme.iconTheme!.color,),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedButton(
                            color: Colors.red,
                            isFixedHeight: false,
                            text: 'Close',
                            pressEvent: () {
                              dialog.dismiss();
                            }),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: AnimatedButton(
                            color: Colors.green,
                            isFixedHeight: false,
                            text: 'Save',
                            pressEvent: () {
                              setState(() {
                                createNote();
                                dialog.dismiss();
                                contentController.clear();
                                titleController.clear();
                              });
                            }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )..show();
        },
        icon: Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ));
  }

  /// # note items ui
  Widget noteItems(BuildContext context, Note note, index) {
    return Container(
      color: (checkedits[index]) ? Colors.blue.shade100 : Colors.transparent,
      child: Dismissible(
        onDismissed: (direction) {
          setState(() {
            showSnackBar(context, index);
            removeNoteList(note);
          });
        },
        background: slideLeftBackground(),
        key: ValueKey(noteList[index]),
        child: Column(
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      note.createTime.toString().substring(0, 16),
                      style:
                          TextStyle(fontSize: 12, ),
                    ),
                    Text(
                      note.title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
              subtitle: Text(
                note.content,
                style: TextStyle(fontSize: 14),
              ),
              trailing: editButton(context, index),
              onLongPress: () {
                isSelected = true;
                setState(() {
                  checkedits[index] = true;
                });
              },
              onTap: () {
                if (isSelected)
                  setState(() {
                    checkedits[index] = !checkedits[index];
                  });
                for (var checked in checkedits) {
                  if (checked) {
                    isSelected = true;
                    break;
                  } else {
                    setState(() {
                      isSelected = false;
                    });
                  }
                }
              },
            ),
            Divider()
          ],
        ),
      ),
    );
  }

  /// # edit awesome button
  IconButton editButton(BuildContext context, int index) {
    return IconButton(
        onPressed: () {
          setState(() {
            editText = true;
          });
          late AwesomeDialog dialog;
          dialog = AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.INFO_REVERSED,
            keyboardAware: true,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Edit Note',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Material(
                    elevation: 0,
                    color: Colors.blueGrey.withAlpha(40),
                    child: TextFormField(
                      controller: titleController
                        ..text = (editText) ? noteList[index].title : "",
                      autofocus: true,
                      minLines: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Title',
                        prefixIcon: Icon(Icons.text_fields),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Material(
                    elevation: 0,
                    color: Colors.blueGrey.withAlpha(40),
                    child: TextFormField(
                      controller: contentController
                        ..text = (editText) ? noteList[index].content : "",
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      maxLengthEnforced: true,
                      minLines: 2,
                      maxLines: 8,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Content',
                        prefixIcon: Icon(Icons.text_fields),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedButton(
                            color: Colors.red,
                            isFixedHeight: false,
                            text: 'Close',
                            pressEvent: () {
                              dialog.dismiss();
                              setState(() {
                                contentController.clear();
                                titleController.clear();
                              });
                            }),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: AnimatedButton(
                            color: Colors.green,
                            isFixedHeight: false,
                            text: 'Save',
                            pressEvent: () {
                              setState(() {
                                noteList[index].content =
                                    contentController.text.toString();
                                noteList[index].title =
                                    titleController.text.toString();
                                Preference.storeNoteList(noteList);
                                dialog.dismiss();
                                contentController.clear();
                                titleController.clear();
                                editText = false;
                              });
                            }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )..show();
        },
        icon: Icon(Icons.edit));
  }

  /// # Slide to delete function
  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  /// # Snackbar
  void showSnackBar(BuildContext context, int index) {
    var deletedNote = noteList[index];
    setState(() {
      noteList.removeAt(index);
    });
    SnackBar snackBar = SnackBar(
      content: Text('Deleted ${deletedNote.title}'),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {
          setState(() {
            noteList.insert(index, deletedNote);
            storeNote();
            _loadNoteList();
          });
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
