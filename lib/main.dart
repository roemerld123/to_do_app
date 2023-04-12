import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do-Liste App',
      home: ToDoListe(),
    );
  }
}

class ToDoListe extends StatefulWidget {
  @override
  _ToDoListeState createState() => _ToDoListeState();
}

class _ToDoListeState extends State<ToDoListe> {
  List<String> aufgaben = [];

  TextEditingController aufgabenController = TextEditingController();

  void hinzufuegenAufgabe(String aufgabe) {
    setState(() {
      aufgaben.add(aufgabe);
    });
    aufgabenController.clear();
  }

  void entfernenAufgabe(String aufgabe) {
    setState(() {
      aufgaben.remove(aufgabe);
    });
  }

  void bearbeitenAufgabe(int index, String aufgabe) {
    setState(() {
      aufgaben[index] = aufgabe;
    });
    aufgabenController.clear();
  }

  void abhakenAufgabe(int index) {
    setState(() {
      aufgaben[index] = aufgaben[index] + ' (erledigt)';
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do-Liste'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: aufgabenController,
              decoration: InputDecoration(
                hintText: 'Aufgabe hinzufügen',
              ),
              onSubmitted: hinzufuegenAufgabe,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: aufgaben.length,
              itemBuilder: (context, index) {
                final aufgabe = aufgaben[index];
                return Dismissible(
                  key: Key(aufgabe),
                  onDismissed: (direction) {
                    entfernenAufgabe(aufgabe);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$aufgabe entfernt'),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      aufgabe,
                      style: TextStyle(
                        decoration: aufgabe.contains('(erledigt)')
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          String bearbeiteteAufgabe = aufgabe;
                          return AlertDialog(
                            title: Text('Aufgabe bearbeiten'),
                            content: TextField(
                              controller: TextEditingController(text: aufgabe),
                              onChanged: (value) {
                                bearbeiteteAufgabe = value;
                              },
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  bearbeitenAufgabe(index, bearbeiteteAufgabe);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Speichern'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    trailing: Checkbox(
                      value: aufgabe.contains('(erledigt)'),
                      onChanged: (value) {
                        abhakenAufgabe(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
