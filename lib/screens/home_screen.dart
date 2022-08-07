import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../colors/app_colors.dart';
import '/database/database.dart';
import '/models/note_model.dart';

import 'add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  Widget _buildTask(Note note, BuildContext context) {
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
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Slidable(
          actionPane: const SlidableBehindActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(
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
            color: Theme.of(context).accentColor,
            child: ListTile(
              title: Transform.translate(
                offset: const Offset(-15, 0),
                child: Text(
                  note.title!,
                  style: TextStyle(
                    fontSize: 18.0,
                    decoration: note.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                  ),
                ),
              ),
              subtitle: Transform.translate(
                offset: const Offset(-15, 0),
                child: Text(
                  '${_dateFormatter.format(note.date!)} - ${note.priority}',
                  style: TextStyle(
                    fontSize: 15.0,
                    decoration: note.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                  ),
                ),
              ),
              trailing: const Icon(Icons.warning_amber),
              leading: Transform.translate(
                offset: const Offset(-15, 0),
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
        backgroundColor: AppColors.mainBlue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddNoteScreen(
                updateNoteList: _updateNoteList,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
          future: _noteList,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final int completeNoteCount = snapshot.data!
                .where((Note note) => note.status == 1)
                .toList()
                .length;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              itemCount: int.parse(snapshot.data.length.toString()) + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 60, right: 60, bottom: 20, top: 160),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Мои дела',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
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
                return _buildTask(snapshot.data![index - 1], context);
              },
            );
          }),
    );
  }
}
