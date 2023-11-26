import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_notes/models/note_model.dart';
import 'package:my_notes/screens/home_screen.dart';

class DetailNote extends StatefulWidget {
  const DetailNote({super.key, required this.note});

  final Note note;

  @override
  State<DetailNote> createState() => _DetailNoteState();
}

class _DetailNoteState extends State<DetailNote> {
  late TextEditingController titleController;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    // Initialisez les contrôleurs avec les valeurs actuelles de la note
    titleController = TextEditingController(text: widget.note.title);
    textController = TextEditingController(text: widget.note.text);
  }

  Future<void> updateNote() async {
    final url = Uri.parse('http://localhost:3567/api/v1/notes/${widget.note.id}');

    final Map<String, dynamic> data = {
      'title': titleController.text,
      'text': textController.text,
    };

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Note mise à jour avec succès');
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const HomeScreen()));
    } else {
      print('Échec de la requête PUT : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de la note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Titre de la note',
                labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Contenu de la note'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                updateNote();
              },
              child: const Text('Sauvegarder les modifications', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
