import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class Note {
  String title;
  String text;

  Note(this.title, this.text);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteList(),
    );
  }
}

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final response = await http.get(Uri.parse('http://localhost:3567/api/v1/notes'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      setState(() {
        notes = data.map((note) => Note(note['title'], note['text'])).toList();
      });
    } else {
      throw Exception('Failed to load notes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Notes'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetail(note: notes[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToNoteDetail(context);
        },
        tooltip: 'Ajouter une note',
        child: Icon(Icons.add),
      ),
    );
  }

  _navigateToNoteDetail(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNoteScreen()),
    );

    if (result != null && result is Note) {
      // Ajoute la nouvelle note à la liste
      setState(() {
        notes.add(result);
      });
    }
  }
}

class NoteDetail extends StatelessWidget {
  final Note note;

  NoteDetail({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(note.text),
          ],
        ),
      ),
    );
  }
}

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Titre de la note'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Contenu de la note'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _postNote();
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _postNote() async {
    final response = await http.post(
      Uri.parse('http://localhost:3567/api/v1/notes'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': titleController.text,
        'text': textController.text,
      }),
    );

    if (response.statusCode == 201) {
      // La note a été créée avec succès
      Navigator.pop(
        context,
        Note(
          titleController.text,
          textController.text,
        ),
      );
    } else {
      // Gérer les erreurs ici
      print('Échec de la création de la note');
      print('StatusCode: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }
}
