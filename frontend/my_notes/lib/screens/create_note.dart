import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_notes/screens/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();

  Future<void> saveNote() async {
    final url = Uri.parse('http://localhost:3567/api/v1/notes');

    final Map<String, dynamic> data = {
      'title': titleController.text,
      'text': textController.text,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      print('Note créée avec succès');
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const HomeScreen()));
      Fluttertoast.showToast(
        msg: "Note créée avec succès",
        gravity: ToastGravity.BOTTOM_LEFT,
        timeInSecForIosWeb: 2,
        webBgColor: "green",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );
    } else {
      print('Échec de la requête POST : ${response.statusCode}');
      Fluttertoast.showToast(
        msg: "Erreur lors de la création de la note",
        gravity: ToastGravity.BOTTOM_LEFT,
        timeInSecForIosWeb: 2,
        webBgColor: "red",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une note', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
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
                saveNote();
              },
              child: const Text('Enregistrer la note', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
