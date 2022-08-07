import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zxc/colors/app_colors.dart';
import '/database/database.dart';
import '/models/note_model.dart';
import '/screens/home_screen.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  final Function? updateNoteList;

  AddNoteScreen({this.note, this.updateNoteList});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime _date = DateTime.now();
  String _priority = 'Нет';
  String _title = '';
  String btnText = 'Add Note';
  String titleText = 'todo';

  final TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ['Нет', 'Низкий', 'Высокии'];

  delete() {
    DatabaseHelper.instance.deleteNote(widget.note!.id!);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ));

    widget.updateNoteList!();
  }

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _title = widget.note!.title!;
      _date = widget.note!.date!;
      _priority = widget.note!.priority!;

      setState(() {
        btnText = 'Update Note';
        titleText = 'Update ToDo';
      });
    } else {
      setState(() {
        btnText = 'Add Note';
        titleText = 'Add ToDo';
      });
    }

    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('$_title, $_date, $_priority');

      Note note = Note(title: _title, date: _date, priority: _priority);

      if (widget.note == null) {
        note.status = 0;
        DatabaseHelper.instance.insertNote(note);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(),
            ));
      } else {
        note.id = widget.note!.id;
        note.status = widget.note!.status;
        DatabaseHelper.instance.updateNote(note);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(),
            ));
      }

      widget.updateNoteList!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.clear,
            size: 25.0,
            color: Theme.of(context).hintColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text(
              'CОХРАНИТЬ',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          child: TextFormField(
                            maxLines: null,
                            minLines: 5,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: new BorderSide(width: 0)),
                              hintText: 'Что-то надо сделать...',
                              hintStyle: TextStyle(
                                color: Theme.of(context).cardColor,
                              ),
                              labelStyle: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black54,
                              ),
                              filled: true,
                              fillColor: Theme.of(context).accentColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            validator: (input) => input!.trim().isEmpty
                                ? 'Please enter a title'
                                : null,
                            onSaved: (input) => _title = input!,
                            initialValue: _title,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: DropdownButtonFormField(
                            isDense: true,
                            iconSize: 0,
                            items: _priorities.map((priority) {
                              return DropdownMenuItem(
                                value: priority,
                                child: Text(
                                  priority,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18.0,
                                  ),
                                ),
                              );
                            }).toList(),
                            style: const TextStyle(fontSize: 16.0),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Важность',
                              labelStyle: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            validator: (input) => _priority == null
                                ? 'Please select a priority level'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                _priority = value.toString();
                              });
                            },
                            value: _priority,
                          ),
                        ),
                        const Divider(height: 1, color: Colors.grey),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          child: TextFormField(
                            readOnly: true,
                            controller: _dateController,
                            onTap: _handleDatePicker,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.lightBlue),
                            decoration: const InputDecoration(
                              labelText: 'Сделать до',
                              labelStyle: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const Divider(height: 1, color: Colors.grey),
                        const SizedBox(height: 15),
                        widget.note != null
                            ? Container(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  onPressed: delete,
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 25,
                                    color: AppColors.mainRed,
                                  ),
                                  label: const Text(
                                    'Удалить',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Color(0xFFFF3B30),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
