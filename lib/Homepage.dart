import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  dynamic poster;
  String? body = '', hasil = '';
  String? info;
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    info = 'Silakan Masukkan Judul Film';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pencarian Judul Film'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            ElevatedButton(
              onPressed: (() async {
                var response = await http
                    .get(Uri.parse('http://www.omdbapi.com/?apikey=65159463&s='
                        '${titleController.text}'));
                var data = json.decode(response.body) as Map<dynamic, dynamic>;
                if (response.statusCode == 200 && data['Response'] == 'True') {
                  info = 'Pencarian berhasil';
                  setState(() {
                    body = data['Search'][0]['Title'];
                    hasil = 'Year : ${data['Search'][0]['Year']}';
                  });
                } else {
                  info = 'Judul film tidak ditemukan';
                  setState(() {
                    body = '';
                  });
                }
              }),
              child: Text('Cari'),
            ),
            Text(
              info!,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  if (isExpanded == false) {
                    isExpanded = true;
                  } else {
                    isExpanded = false;
                  }
                });
              },
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(body!),
                    );
                  },
                  body: ListTile(
                    title: Text(hasil!),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
