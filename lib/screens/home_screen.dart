import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zxc/colors/app_colors.dart';
import '/database/database.dart';
import '/models/note_model.dart';

import 'add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final Note? note;
  // final Function? updateNoteList;

  // _HomeScreenState({this.note, this.updateNoteList});

  late Future<List<Note>> _noteList;

  final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");

  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _updateNoteList();
  }

  _updateNoteList() {
    _noteList = DatabaseHelper.instance.getNoteList();
  }

  Widget _buildTaskDesign(Note note, BuildContext context) {
    // qwe() {
    //   (value) {
    //     note.status = value! ? 1 : 0;

    //     DatabaseHelper.instance.updateNote(note);
    //     _updateNoteList();
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (_) => HomeScreen()));
    //   };
    // }

    delete() {
      DatabaseHelper.instance.deleteNote(note.id!);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ));

      _updateNoteList();
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Slidable(
          actionPane: const SlidableBehindActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: AppColors.mainRed,
              icon: Icons.delete,
              onTap: delete,
            ),
          ],
          actions: <Widget>[
            IconSlideAction(
              color: AppColors.mainGreen,
              iconWidget: Checkbox(
                onChanged: (value) {
                  note.status = value! ? 1 : 0;
                  DatabaseHelper.instance.updateNote(note);
                  _updateNoteList();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => HomeScreen()));
                },
                activeColor: AppColors.mainGreen,
                value: note.status == 1 ? true : false,
              ),
            ),
          ],
          child: ColoredBox(
            color: Colors.white,
            child: ListTile(
              title: Transform.translate(
                offset: Offset(-15, 0),
                child: Text(
                  note.title!,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    decoration: note.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                  ),
                ),
              ),
              subtitle: Transform.translate(
                offset: Offset(-15, 0),
                child: Text(
                  '${_dateFormatter.format(note.date!)} - ${note.priority}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black38,
                    decoration: note.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                  ),
                ),
              ),
              trailing: Icon(Icons.warning_amber),
              leading: Transform.translate(
                offset: Offset(-15, 0),
                child: Checkbox(
                  onChanged: (value) {
                    note.status = value! ? 1 : 0;
                    DatabaseHelper.instance.updateNote(note);
                    _updateNoteList();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => HomeScreen()));
                  },
                  activeColor: AppColors.mainGreen,
                  value: note.status == 1 ? true : false,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => AddNoteScreen(
                      updateNoteList: _updateNoteList(),
                      note: note,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AddNoteScreen(
                updateNoteList: _updateNoteList,
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).canvasColor,
        ),
      ),
      body: FutureBuilder(
          future: _noteList,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final int completeNoteCount = snapshot.data!
                .where((Note note) => note.status == 1)
                .toList()
                .length;

            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              itemCount: int.parse(snapshot.data.length.toString()) + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: 60, right: 60, bottom: 20, top: 160),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Мои дела',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        Text(
                          'Выполнено $completeNoteCount - ${snapshot.data.length}',
                          style: TextStyle(
                            color: Colors.lightBlueAccent.shade100,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return _buildTaskDesign(snapshot.data![index - 1], context);
              },
            );
          }),
    );
  }
}
