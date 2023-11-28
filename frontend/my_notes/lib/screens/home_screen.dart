import 'package:flutter/material.dart';
import 'package:my_notes/models/note_model.dart';
import 'package:my_notes/screens/create_note.dart';
import 'package:my_notes/screens/detail_note.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];

  Future<void> fetchNotes() async {
    final response = await http.get(Uri.parse('http://localhost:3567/api/v1/notes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Note> fetchedNotes = data.map((note) => Note.fromJson(note)).toList();

      setState(() {
        notes = fetchedNotes;
      });
    } else {
    }
  }

  @override
  void initState() {
    fetchNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.blue,
            child: ListTile(
              title: Text(notes[index].title, 
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold, fontSize: 20, 
                )
              ),
              subtitle: Text(notes[index].text,
                style: const TextStyle(
                  color: Colors.white, 
                  )
                ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Voulez-vous vraiment supprimer cette note ?'),
                  titleTextStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Annuler', style: TextStyle(color: Colors.black)),
                    ),
                    TextButton(
                  onPressed: () async {
                    final response = await http.delete(Uri.parse('http://localhost:3567/api/v1/notes/${notes[index].id}'));
                    if (response.statusCode == 200) {
                      fetchNotes();
                      Navigator.pop(context, 'OK');
                      Fluttertoast.showToast(
                        msg: "Note supprimé avec succès",
                        gravity: ToastGravity.BOTTOM_LEFT,
                        timeInSecForIosWeb: 2,
                        webBgColor: "green",
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0
                      );
                    }
                    else {
                      print('Échec de la requête DELETE : ${response.statusCode}');
                      Fluttertoast.showToast(
                        msg: "Erreur lors de la suppression de la note",
                        gravity: ToastGravity.BOTTOM_LEFT,
                        timeInSecForIosWeb: 2,
                        webBgColor: "red",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                      );
                    }
                  },                      
                  child: const Text('Oui', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetailNote(note: notes[index])));
            },
          )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const CreateNote()));
        },
        child: const Icon(Icons.add, color: Colors.white),
        ),
    );
  }
}

class FloatingActionButtonStyle {
}